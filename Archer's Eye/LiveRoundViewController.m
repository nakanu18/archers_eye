//
//  LiveRoundViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "LiveRoundViewController.h"
#import "EndCell.h"

@interface LiveRoundViewController ()

@end

@implementation LiveRoundViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [self setAppDelegate:(AppDelegate *)[UIApplication sharedApplication].delegate];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 12;
}



//------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveEndCell"];
    
    [[cell endNumLabel]     setText:[NSString stringWithFormat:@"%ld:", (long)indexPath.row + 1]];
    
    [[cell arrow0Label]     setText:[NSString stringWithFormat:@"_"]];
    [[cell arrow1Label]     setText:[NSString stringWithFormat:@"_"]];
    [[cell arrow2Label]     setText:[NSString stringWithFormat:@"_"]];
    [[cell arrow3Label]     setText:[NSString stringWithFormat:@"_"]];
    [[cell arrow4Label]     setText:[NSString stringWithFormat:@"_"]];
    [[cell arrow5Label]     setText:[NSString stringWithFormat:@"_"]];
    
    [[cell endScoreLabel]   setText:[NSString stringWithFormat:@"0"]];
    [[cell totalScoreLabel] setText:[NSString stringWithFormat:@"0"]];
    
    return cell;
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

@end
