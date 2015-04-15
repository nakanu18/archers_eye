//
//  BreakdownGraphView.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/14/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RoundInfo.h"

@interface BreakdownGraphView : UIView <CPTPlotDataSource, CPTPieChartDataSource>
{
    
}

@property (nonatomic, strong) RoundInfo             *currRound;
@property (nonatomic, strong) CPTGraphHostingView   *hostView;






- (void)initPlot;
- (void)configureHost;
- (void)configureGraph;
- (void)configureChart;
- (void)configureLegend;

@end
