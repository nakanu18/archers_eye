//
//  GraphsViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/1/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BreakdownGraphView.h"
#import "PastRoundsViewController.h"

@interface PointsBreakdownViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
}

@property (nonatomic, weak)             AppDelegate         *appDelegate;
@property (nonatomic, weak)             ArchersEyeInfo      *archersEyeInfo;
@property (nonatomic, strong)           NSMutableArray      *groupedRounds;
@property (nonatomic, weak)             RoundInfo           *currPastRound;
@property (nonatomic, weak)   IBOutlet  UITableView         *tableView;
@property (nonatomic, weak)   IBOutlet  BreakdownGraphView  *breakdownView;
@property (nonatomic, weak)   IBOutlet  UIBarButtonItem     *showXsButton;
@property (nonatomic, readwrite)         ePastRoundEx     roundExInfo;






- (void)initPlot;

- (IBAction)showX:(id)sender;

@end
