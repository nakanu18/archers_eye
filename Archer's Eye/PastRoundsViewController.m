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





















#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Number of sections.
//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
// Number of rows for a section.
//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.archersEyeInfo.pastRounds count];
}



//------------------------------------------------------------------------------
// Build the rows.
//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray  *scores      = self.archersEyeInfo.pastRounds;
    RoundDescCell   *cell        = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo       *info        = scores[indexPath.row];
    NSInteger        totalScore  = [info getRealTotalScore];
    NSInteger        totalArrows = info.numEnds * info.numArrowsPerEnd;

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
        // Delete the row from the data source
        [self.archersEyeInfo.pastRounds removeObjectAtIndex:indexPath.row];
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
