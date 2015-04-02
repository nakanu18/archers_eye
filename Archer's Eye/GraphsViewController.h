//
//  GraphsViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/1/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GraphsViewController : UIViewController <CPTPlotDataSource, CPTPieChartDataSource, UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, weak)             AppDelegate         *appDelegate;
@property (nonatomic, weak)             ArchersEyeInfo      *archersEyeInfo;
@property (nonatomic, weak)             RoundInfo           *currPastRound;
@property (nonatomic, weak)   IBOutlet  UITableView         *tableView;
@property (nonatomic, weak)   IBOutlet  UIView              *graphView;

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme            *selectedTheme;






- (void)initPlot;
- (void)configureHost;
- (void)configureGraph;
- (void)configureChart;

@end
