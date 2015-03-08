//
//  PastScoresViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "PastScoresViewController.h"
#import "RoundInfo.h"
#import "RoundCell.h"

@interface PastScoresViewController ()

@end

@implementation PastScoresViewController

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
    NSMutableArray  *scores = [_appDelegate roundScores];
    RoundCell       *cell   = [tableView dequeueReusableCellWithIdentifier:@"RoundCell"];
    RoundInfo       *info   = [scores objectAtIndex:indexPath.row];

    [[cell dateLabel]   setText:[[info date] description]];
    [[cell arrowsLabel] setText:@"12"];
    [[cell scoreLabel]  setText:@"102"];
    
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
