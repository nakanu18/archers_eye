//
//  GraphsViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/1/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "PointsBreakdownViewController.h"
#import "RoundDescCell.h"

@interface PointsBreakdownViewController ()

@end



@implementation PointsBreakdownViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    self.groupedRounds  = [self.archersEyeInfo matrixOfRoundsByMonth:self.archersEyeInfo.pastRounds];

    _showXs = NO;
}



//------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.archersEyeInfo showHintPopupIfNecessary:eHint_Graphs_PointsBreakdown];

    // Select the first item if it exists
    if( [self.groupedRounds count] > 0 )
    {
        if( [self.groupedRounds[0] count] > 0 )
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }   
    }
}



//------------------------------------------------------------------------------
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self initPlot];
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
    return [self.groupedRounds count];
}



//------------------------------------------------------------------------------
// Number of rows in a section.
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
    RoundDescCell   *cell        = [tableView dequeueReusableCellWithIdentifier:@"RoundDescCell"];
    RoundInfo       *info        = self.groupedRounds[indexPath.section][indexPath.row];
    NSInteger        totalScore  = [info getRealTotalScore];
    NSInteger        totalArrows = info.numEnds * info.numArrowsPerEnd;
    
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
    self.currPastRound = self.groupedRounds[indexPath.section][indexPath.row];
    
    [self initPlot];
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
























#pragma mark - Chart behavior

//------------------------------------------------------------------------------
// Create a new plot.
//------------------------------------------------------------------------------
- (void)initPlot
{
    self.breakdownView.currRound = self.currPastRound;
    [self.breakdownView initPlot];
}
























//------------------------------------------------------------------------------
- (IBAction)showX:(id)sender
{
    _showXs = !_showXs;
    
    if( _showXs )
        self.showXsButton.title = @"Avg";
    else
        self.showXsButton.title = @"X's";
    
    [self.tableView reloadData];
}

@end
