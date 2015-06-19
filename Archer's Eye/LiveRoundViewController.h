//
//  LiveRoundViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BreakdownGraphView.h"

@interface LiveRoundViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, weak)             AppDelegate         *appDelegate;
@property (nonatomic, weak)             ArchersEyeInfo      *archersEyeInfo;
@property (nonatomic, weak)   IBOutlet  UITableView         *tableView;
@property (nonatomic, weak)   IBOutlet  BreakdownGraphView  *breakdownView;
@property (nonatomic, weak)   IBOutlet  UIButton            *startButton;

@property (nonatomic, weak)   IBOutlet  UILabel             *scoreTotalLabel;
@property (nonatomic, weak)   IBOutlet  UILabel             *xTotalLabel;
@property (nonatomic, weak)   IBOutlet  UILabel             *scoreAvgLabel;






- (void)initPlot;

- (void)updateScores;

- (IBAction)unwindToLiveRound:(UIStoryboardSegue *)segue;

@end
