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
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





















#pragma mark - Table view data source

//------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_appDelegate.pastRounds count];
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray  *scores      = _appDelegate.pastRounds;
    RoundDescCell   *cell        = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo       *info        = scores[indexPath.row];

    cell.name.text  = info.name;
    cell.date.text  = [_appDelegate basicDate:info.date];
    cell.desc.text  = [NSString stringWithFormat:@"%ldx%ld", info.numEnds,  info.numArrowsPerEnd];
    cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", [info getTotalScore], info.numEnds * info.numArrowsPerEnd * 10];
    
    return cell;
}



//------------------------------------------------------------------------------
// Override to support editing the table view.
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {
        // Delete the row from the data source
        [_appDelegate.pastRounds removeObjectAtIndex:indexPath.row];
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

@end
