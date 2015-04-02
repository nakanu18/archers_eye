//
//  GraphsViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/1/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "GraphsViewController.h"
#import "RoundDescCell.h"

@interface GraphsViewController ()

@end



@implementation GraphsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo = self.appDelegate.archersEyeInfo;
}



//------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Need to leave this here and not in viewDidLoad because auto-layout hasn't
    // worked out yet and the graph will be the wrong width.
    [self initPlot];
}


//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // The plot is initialized here, since the view bounds have not transformed for landscape till now
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



//------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.archersEyeInfo.pastRounds count];
}



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
    cell.dist.text  = [NSString stringWithFormat:@"%ld yds", info.distance];
    cell.desc.text  = [NSString stringWithFormat:@"%ldx%ld", info.numEnds,  info.numArrowsPerEnd];
    cell.avg.text   = [NSString stringWithFormat:@"%.2f avg", (float)totalScore / (totalArrows)];
    cell.score.text = [NSString stringWithFormat:@"%ld/%ld pts", totalScore, totalArrows * [info getMaxArrowScore]];
    
    return cell;
}



//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currPastRound = _archersEyeInfo.pastRounds[indexPath.row];
    
    [self initPlot];
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
























#pragma mark - Chart behavior

//------------------------------------------------------------------------------
- (void)initPlot
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
}



//------------------------------------------------------------------------------
- (void)configureHost
{
    // 1 - Set up view frame
    CGRect parentRect = self.graphView.frame;
    
    // 2 - Create host view
    self.hostView                   = [(CPTGraphHostingView *)[CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
}



//------------------------------------------------------------------------------
- (void)configureGraph
{
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph   = graph;
    graph.paddingLeft           = 0.0f;
    graph.paddingTop            = 0.0f;
    graph.paddingRight          = 0.0f;
    graph.paddingBottom         = 0.0f;
    graph.axisSet               = nil;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color     = [CPTColor grayColor];
    textStyle.fontName  = @"Helvetica-Bold";
    textStyle.fontSize  = 16.0f;
    
    // 3 - Configure title
    NSString *title = @"Points Breakdown";
    graph.title                     = title;
    graph.titleTextStyle            = textStyle;
    graph.titlePlotAreaFrameAnchor  = CPTRectAnchorTop;
    graph.titleDisplacement         = CGPointMake(0.0f, -12.0f);
    
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];
}



//------------------------------------------------------------------------------
- (void)configureChart
{
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource     = self;
    pieChart.delegate       = self;
    pieChart.pieRadius      = (self.hostView.bounds.size.height * 0.7) / 2;
    pieChart.identifier     = graph.title;
    pieChart.startAngle     = 0;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient              = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient              = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill         = [CPTFill fillWithGradient:overlayGradient];

    // 4 - Add chart to graph
    [graph addPlot:pieChart];
}






















#pragma mark - CPTPlotDataSource methods

//------------------------------------------------------------------------------
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 6;
}



//------------------------------------------------------------------------------
- (NSNumber *)numberForPlot:(CPTPlot *)plot
                      field:(NSUInteger)fieldEnum
                recordIndex:(NSUInteger)index
{
    NSNumber *num = [NSNumber numberWithInteger:0];
    
    if( CPTPieChartFieldSliceWidth == fieldEnum )
    {
        NSInteger range[][2] = { {0,0}, {1,2}, {3,4}, {5,6}, {7,8}, {9,11}, };
        NSInteger  numArrows = [_currPastRound getNumberOfArrowsWithMinScore:range[index][0] andMaxScore:range[index][1]];
        
        num = [NSNumber numberWithInteger:numArrows];
    }
    return num;
}



//------------------------------------------------------------------------------
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot
                   recordIndex:(NSUInteger)index
{
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    
    if (!labelText)
    {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    // 2 - Calculate the number of arrows
    NSInteger  range[][2] = { {0,0}, {1,2}, {3,4}, {5,6}, {7,8}, {9,11}, };
    NSInteger  numArrows  = [_currPastRound getNumberOfArrowsWithMinScore:range[index][0] andMaxScore:range[index][1]];
    NSNumber  *num        = [NSNumber numberWithInteger:numArrows];
    
    // 3 - Calculate percentage value
    NSNumber *percent = [NSNumber numberWithFloat:((float)numArrows)/[_currPastRound getTotalArrows]];
    
    // 4 - Set up display label
    NSString *labelValue = [NSString stringWithFormat:@"%ld (%0.1f %%)", [num integerValue], [percent floatValue] * 100.0f];
    
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}
























//------------------------------------------------------------------------------
- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    CPTFill *areaGradientFill;
    
    if( index == 0 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor orangeColor]];
    else if( index == 1 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    else if( index == 2 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor blackColor]];
    else if( index == 3 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor blueColor]];
    else if( index == 4 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor redColor]];
    else if( index == 5 )
        areaGradientFill = [CPTFill fillWithColor:[CPTColor yellowColor]];
    
    return areaGradientFill;
}

@end
