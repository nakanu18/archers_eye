//
//  PastScoresViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "PastRoundsViewController.h"
#import "RoundInfo.h"
#import "RoundDescCell.h"

@interface PastRoundsViewController ()

@end



@implementation PastRoundsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;
    
    // Sort the past rounds so that the newest one is first
    [self.archersEyeInfo sortRoundInfosByDate:self.archersEyeInfo.pastRounds ascending:NO];
    
    
    
    self.groupedPastRounds = [NSMutableArray new];
    
    NSInteger prevMonth = -1;
    NSInteger prevYear  = -1;
    
    // Parse through pastRounds - create a new array for each new month
    for( RoundInfo *roundInfo in self.archersEyeInfo.pastRounds )
    {
        NSInteger month = [roundInfo.date month];
        NSInteger year  = [roundInfo.date year];
        
        // New month was found: create a new array
        if( prevMonth != month  ||  prevYear != year )
            [self.groupedPastRounds addObject:[NSMutableArray new]];
        
        // Add the temp round into it's correct group
        [[self.groupedPastRounds lastObject] addObject:roundInfo];
        
        prevMonth = month;
        prevYear  = year;
    }
    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"gotoRoundEditorFromPastRounds"] )
    {
        UINavigationController    *nav         = (UINavigationController    *)segue.destinationViewController;
        RoundEditorViewController *roundEditor = (RoundEditorViewController *)nav.topViewController;
        
        roundEditor.delegate = self;
    }
}



//------------------------------------------------------------------------------
// Protocol: RoundEditorViewControllerDelegate
//------------------------------------------------------------------------------
- (void)currItemChanged
{
    // Sort the past rounds so that the newest one is first
    [self.archersEyeInfo sortRoundInfosByDate:self.archersEyeInfo.pastRounds ascending:NO];

    [self.tableView reloadData];
}




















#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Number of sections.
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupedPastRounds count];
}



//------------------------------------------------------------------------------
// Number of rows for a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupedPastRounds[section] count];
}



//------------------------------------------------------------------------------
// Section name.
//------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    if( [self.groupedPastRounds[section] count] > 0 )
    {
        RoundInfo       *pastRoundInfo  = self.groupedPastRounds[section][0];
        NSDateFormatter *formatter      = [NSDateFormatter new];
        
        [formatter setDateFormat:@"MMMM yyyy"];
        title = [formatter stringFromDate:pastRoundInfo.date];
    }
    return title;
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundDescCell   *cell           = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo       *pastRoundInfo  = self.groupedPastRounds[indexPath.section][indexPath.row];
    RoundInfo       *info           = pastRoundInfo;
    NSInteger        totalScore     = [info getRealTotalScore];
    NSInteger        totalArrows    = info.numEnds * info.numArrowsPerEnd;

    cell.name.text  = info.name;
    cell.date.text  = [AppDelegate basicDate:info.date];
    cell.dist.text  = [NSString stringWithFormat:@"%ld yds", (long)info.distance];
    cell.desc.text  = [NSString stringWithFormat:@"%ldx%ld", (long)info.numEnds,  (long)info.numArrowsPerEnd];
    cell.avg.text   = [NSString stringWithFormat:@"%.2f avg", (float)totalScore / (totalArrows)];
    cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", (long)totalScore, (long)totalArrows * [info getMaxArrowRealScore]];
    
    return cell;
}



//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.archersEyeInfo selectRound:indexPath.row andCategory:eRoundCategory_Past];
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
//------------------------------------------------------------------------------
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        RoundInfo *pastRoundInfo = self.groupedPastRounds[indexPath.section][indexPath.row];
        
        // Delete the row from the data source
        [self.archersEyeInfo.pastRounds removeObject:pastRoundInfo];
        [self.groupedPastRounds[indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if( editingStyle == UITableViewCellEditingStyleInsert )
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}




//------------------------------------------------------------------------------
- (IBAction)unwindToPastRounds:(UIStoryboardSegue *)segue
{
}

@end
