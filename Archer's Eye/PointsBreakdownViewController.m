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
    if( self.currPastRound != nil )
    {
        // Make sure to remove a previous graph if it exists
        if( self.hostView != nil )
        {
            [self.hostView removeFromSuperview];
             self.hostView = nil;
        }
        
        [self configureHost];
        [self configureGraph];
        [self configureChart];
        [self configureLegend];
    }
}



//------------------------------------------------------------------------------
// Configure the holding area.
//------------------------------------------------------------------------------
- (void)configureHost
{
    // 1 - Set up view frame
    CGRect parentRect = self.graphView.bounds;
    float  percentage = 0.95f;
    
    parentRect.size.width  *= percentage;
    parentRect.size.height *= percentage;
    parentRect.origin.x     = self.graphView.bounds.size.width  * (1-percentage)/2;
    parentRect.origin.y     = self.graphView.bounds.size.height * (1-percentage)/2;
    
    // 2 - Create host view
    self.hostView                   = [(CPTGraphHostingView *)[CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.graphView addSubview:self.hostView];
}



//------------------------------------------------------------------------------
// Configure some general values.
//------------------------------------------------------------------------------
- (void)configureGraph
{
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph   = graph;
    graph.paddingLeft           = 0.0f;
    graph.paddingTop            = 0.0f;
    graph.paddingRight          = 60.0f;
    graph.paddingBottom         = 0.0f;
    graph.axisSet               = nil;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color     = [CPTColor grayColor];
    textStyle.fontName  = @"Helvetica-Bold";
    textStyle.fontSize  = 16.0f;
    
    // 3 - Configure title
    NSString *title = @"";
    graph.title                     = title;
    graph.titleTextStyle            = textStyle;
    graph.titlePlotAreaFrameAnchor  = CPTRectAnchorTop;
    graph.titleDisplacement         = CGPointMake(0.0f, -12.0f);
    
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:self.selectedTheme];
}



//------------------------------------------------------------------------------
// Configure the piechart.
//------------------------------------------------------------------------------
- (void)configureChart
{
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create chart
    CPTPieChart *pieChart   = [[CPTPieChart alloc] init];
    pieChart.dataSource     = self;
    pieChart.delegate       = self;
    pieChart.pieRadius      = (self.hostView.bounds.size.width * 0.43) / 2;
    pieChart.identifier     = graph.title;
    pieChart.startAngle     = 0;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.labelOffset    = 0.0f;
    pieChart.pieInnerRadius = 25.0f;
    
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient              = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient              = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill         = [CPTFill fillWithGradient:overlayGradient];

    // 4 - Add chart to graph
    [graph addPlot:pieChart];
}



//------------------------------------------------------------------------------
// Configure the legend.
//------------------------------------------------------------------------------
- (void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    
    // 3 - Configure legend
    theLegend.numberOfColumns   = 1;
    theLegend.fill              = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    theLegend.borderLineStyle   = [CPTLineStyle lineStyle];
    theLegend.cornerRadius      = 5.0;
    
    // 4 - Add legend to graph
    graph.legend             = theLegend;
    graph.legendAnchor       = CPTRectAnchorRight;
}






















#pragma mark - CPTPlotDataSource methods

//------------------------------------------------------------------------------
// PieChart - number of sections.
//------------------------------------------------------------------------------
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 7;
}



//------------------------------------------------------------------------------
// PieChart - values for each section.
//------------------------------------------------------------------------------
- (NSNumber *)numberForPlot:(CPTPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index
{
    NSNumber *num = [NSNumber numberWithInteger:0];
    
    if( CPTPieChartFieldSliceWidth == fieldEnum )
    {
        NSRange   range      = [RoundInfo rangeForSection:index forType:_currPastRound.type];
        NSInteger numArrows  = [_currPastRound getNumberOfArrowsWithMinScore:range.location andMaxScore:range.location + range.length];
        
//        DLog( @"NumArrows: %ld forSection: %ld", numArrows, index );
        num = [NSNumber numberWithInteger:numArrows];
    }
    return num;
}



//------------------------------------------------------------------------------
// PieChart - data label for each section.
//------------------------------------------------------------------------------
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot
                   recordIndex:(NSUInteger)index
{
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    
    if( !labelText )
    {
        labelText       = [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor blackColor];
    }
    
    // 2 - Calculate the number of arrows
    NSRange   range     = [RoundInfo rangeForSection:index forType:_currPastRound.type];
    NSInteger numArrows = [_currPastRound getNumberOfArrowsWithMinScore:range.location andMaxScore:range.location + range.length];
    NSNumber  *num      = [NSNumber numberWithInteger:numArrows];
    
    // Don't print anything if the value is zero
    if( numArrows == 0 )
        return nil;
    
    // 3 - Calculate percentage value
    NSNumber *percent = [NSNumber numberWithFloat:((float)numArrows)/[_currPastRound getTotalArrows]];
    
    // 4 - Set up display label
    NSString *labelValue = [NSString stringWithFormat:@"%ld (%0.0f%%)", (long)[num integerValue], [percent floatValue] * 100.0f];
    
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}



//------------------------------------------------------------------------------
// Legend - build each row.
//------------------------------------------------------------------------------
- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    return [RoundInfo stringForSection:index forType:_currPastRound.type];
}
























//------------------------------------------------------------------------------
// PieChart - colors
//------------------------------------------------------------------------------
- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    CPTColor *color;
    CPTColor *endColor = [CPTColor whiteColor];
    
//    if( _currPastRound.type == eRoundType_FITA )
    {
        switch( index )
        {
            case 0:     color = [CPTColor magentaColor]; break;
            case 1:     color = [CPTColor whiteColor];   break;
            case 2:     color = [CPTColor blackColor];   break;
            case 3:     color = [CPTColor colorWithComponentRed:0.3f green:0.3f blue:1.0f alpha:1.0f]; break;
            case 4:     color = [CPTColor redColor];     break;
            case 5:     color = [CPTColor colorWithComponentRed:0.9f green:0.9f blue:0.0f alpha:1.0f]; break;
            case 6:     color = [CPTColor colorWithComponentRed:0.7f green:0.7f blue:0.0f alpha:1.0f]; break;
            default:    color = [CPTColor grayColor];    break;
        }
    }
//    else if( _currPastRound.type == eRoundType_NFAA )
//    {
//        switch( index )
//        {
//            case 0:     color = [CPTColor magentaColor]; break;
//            case 1:     color = [CPTColor colorWithComponentRed:0.0f green:0.0f blue:1.0f alpha:1.0f]; break;
//            case 2:     color = [CPTColor colorWithComponentRed:0.2f green:0.2f blue:1.0f alpha:1.0f]; break;
//            case 3:     color = [CPTColor colorWithComponentRed:0.4f green:0.4f blue:1.0f alpha:1.0f]; break;
//            case 4:     color = [CPTColor colorWithComponentRed:0.6f green:0.6f blue:1.0f alpha:1.0f]; break;
//            case 5:     color = [CPTColor colorWithComponentRed:0.8f green:0.8f blue:1.0f alpha:1.0f]; break;
//            case 6:     color = [CPTColor colorWithComponentRed:1.0f green:2.0f blue:1.0f alpha:1.0f]; break;
//            default:    color = [CPTColor grayColor];    break;
//        }
//    }
    endColor = color;
    
    return [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:color endingColor:endColor]];
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
