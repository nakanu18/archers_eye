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
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"Past Rounds";
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
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];
}



//------------------------------------------------------------------------------
- (void)configureChart
{
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create chart
    CPTPieChart *pieChart   = [[CPTPieChart alloc] init];
    pieChart.dataSource     = self;
    pieChart.delegate       = self;
    pieChart.pieRadius      = (self.hostView.bounds.size.height * 0.45) / 2;
    pieChart.identifier     = graph.title;
    pieChart.startAngle     = 0;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.labelOffset    = 0.0f;
    
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
- (void)configureLegend
{
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    
    // 3 - Configure legend
    theLegend.numberOfColumns   = 1;
    theLegend.fill              = [CPTFill fillWithColor:[CPTColor lightGrayColor]];
    theLegend.borderLineStyle   = [CPTLineStyle lineStyle];
    theLegend.cornerRadius      = 5.0;
    
    // 4 - Add legend to graph
    graph.legend             = theLegend;
    graph.legendAnchor       = CPTRectAnchorRight;
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
        NSRange   range      = [RoundInfo rangeForSection:index forType:_currPastRound.type];
        NSInteger numArrows  = [_currPastRound getNumberOfArrowsWithMinScore:range.location andMaxScore:range.location + range.length];
        
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
    
    if( !labelText )
    {
        labelText       = [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
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
    NSString *labelValue = [NSString stringWithFormat:@"%ld (%0.0f%%)", [num integerValue], [percent floatValue] * 100.0f];
    
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}



//------------------------------------------------------------------------------
- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    return [RoundInfo stringForSection:index forType:_currPastRound.type];
}
























//------------------------------------------------------------------------------
- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    CPTColor *color;
    CPTColor *endColor = [CPTColor whiteColor];
    
    switch( index )
    {
        case 0:     color = [CPTColor orangeColor]; break;
        case 1:     color = [CPTColor whiteColor];  break;
        case 2:     color = [CPTColor blackColor];  break;
        case 3:     color = [CPTColor blueColor];   break;
        case 4:     color = [CPTColor redColor];    break;
        case 5:     color = [CPTColor yellowColor]; break;
        default:    color = [CPTColor grayColor];   break;
    }
    endColor = color;
    
    return [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:color endingColor:endColor]];
}

@end
