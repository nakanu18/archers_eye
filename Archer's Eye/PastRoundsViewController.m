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
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    self.groupedRounds  = [self.archersEyeInfo arrayOfPastRoundsByMonth];
    
    _showXs = NO;
    
    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // Reload the data;  This is in case we created a live round and need to add
    // that into our list
    self.groupedRounds = [self.archersEyeInfo arrayOfPastRoundsByMonth];
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
    self.groupedRounds = [self.archersEyeInfo arrayOfPastRoundsByMonth];
    [self.tableView reloadData];
}




















#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Number of sections.
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groupedRounds count];
}



//------------------------------------------------------------------------------
// Number of rows for a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupedRounds[section] count];
}



//------------------------------------------------------------------------------
// Section name.
//------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    if( [self.groupedRounds[section] count] > 0 )
    {
        RoundInfo       *pastRoundInfo  = self.groupedRounds[section][0];
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
    RoundInfo       *info           = self.groupedRounds[indexPath.section][indexPath.row];
    NSInteger        totalScore     = [info getRealTotalScore];
    NSInteger        totalArrows    = info.numEnds * info.numArrowsPerEnd;

    cell.name.text  = info.name;
    cell.date.text  = [AppDelegate basicDate:info.date];
    cell.dist.text  = [NSString stringWithFormat:@"%ld yds", (long)info.distance];
    cell.desc.text  = [NSString stringWithFormat:@"%ldx%ld", (long)info.numEnds,  (long)info.numArrowsPerEnd];
    cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", (long)totalScore, (long)totalArrows * [info getMaxArrowRealScore]];
    
    if( _showXs )
        cell.avg.text = [NSString stringWithFormat:@"%ld X's", [info getNumberOfArrowsWithScore:11]];
    else
        cell.avg.text = [NSString stringWithFormat:@"%.2f avg", (float)totalScore / (totalArrows)];
    
    return cell;
}



//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoundInfo *info = self.groupedRounds[indexPath.section][indexPath.row];

    [self.archersEyeInfo selectRoundInfo:info andCategory:eRoundCategory_Past];
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
        RoundInfo *pastRoundInfo = self.groupedRounds[indexPath.section][indexPath.row];
        
        // Delete the row from the data source
        [self.archersEyeInfo.pastRounds removeObject:pastRoundInfo];
        [self.groupedRounds[indexPath.section] removeObjectAtIndex:indexPath.row];
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
- (IBAction)showX:(id)sender
{
    _showXs = !_showXs;
    
    if( _showXs )
        self.showXsButton.title = @"Show Avg";
    else
        self.showXsButton.title = @"Show X's";
    
    [self.tableView reloadData];
}



//------------------------------------------------------------------------------
- (IBAction)unwindToPastRounds:(UIStoryboardSegue *)segue
{
}

@end
