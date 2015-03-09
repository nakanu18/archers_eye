//
//  PastScoresViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "PastRoundsViewController.h"
#import "RoundInfo.h"
#import "RoundCell.h"

@interface PastRoundsViewController ()

@end

@implementation PastRoundsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [self setAppDelegate:(AppDelegate *)[UIApplication sharedApplication].delegate];
    
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
    return [[_appDelegate roundScores] count];
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray  *scores      = [_appDelegate roundScores];
    RoundCell       *cell        = [tableView dequeueReusableCellWithIdentifier:@"PastRoundCell"];
    RoundInfo       *info        = [scores objectAtIndex:indexPath.row];
    float            totalArrows = [info getTotalArrows];
    float            totalScore  = [info getTotalScore];
    
    [[cell dateLabel]       setText:[[info date] description]];
    [[cell arrowsLabel]     setText:[NSString stringWithFormat:@"%d",   (int)totalArrows]];
    [[cell scoreLabel]      setText:[NSString stringWithFormat:@"%d",   (int)totalScore]];
    [[cell averageLabel]    setText:[NSString stringWithFormat:@"%.1f", totalScore / totalArrows]];
    
    return cell;
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
