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
    self.roundExInfo    = ePastRoundEx_Average;
}



//------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Only show the hint if we have no rounds to show
    if( [self.groupedRounds count] == 0 )
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
    
    switch( self.roundExInfo )
    {
        case ePastRoundEx_Average:
            cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", (long)totalScore, (long)totalArrows * [info getMaxArrowRealScore]];
            cell.avg.text   = [NSString stringWithFormat:@"%.2f avg", (float)totalScore / (totalArrows)];
            break;
        case ePastRoundEx_Bullseyes:
            cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", (long)totalScore, (long)totalArrows * [info getMaxArrowRealScore]];
            cell.avg.text   = [NSString stringWithFormat:@"%ld X's", [info getNumberOfArrowsWithScore:11]];
            break;
        case ePastRoundEx_BowName:
            cell.score.text = info.bow.name;
            cell.avg.text   = [NSString stringWithFormat:@"%ld lbs", info.bow.drawWeight];
            break;
        default:
            break;
    }
        
    // Set the colors for each round
    cell.name.textColor  = [RoundInfo typeAsFontColor:info.type];
    cell.score.textColor = [RoundInfo typeAsFontColor:info.type];
    
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
    self.roundExInfo = (self.roundExInfo + 1) % ePastRoundEx_Count;
    
    switch( (self.roundExInfo + 1) % ePastRoundEx_Count )
    {
        case ePastRoundEx_Average:      self.showXsButton.title = @"Avg";   break;
        case ePastRoundEx_Bullseyes:    self.showXsButton.title = @"X's";   break;
        case ePastRoundEx_BowName:      self.showXsButton.title = @"Bow";   break;
        default:                        self.showXsButton.title = @"";      break;
    }
    
    [self.tableView reloadData];
}

@end
