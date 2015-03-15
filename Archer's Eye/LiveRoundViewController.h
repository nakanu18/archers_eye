//
//  LiveRoundViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EndCell.h"

@interface LiveRoundViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSInteger _currEndID;
    NSInteger _currArrowID;
}

@property (weak)          AppDelegate *appDelegate;
@property (weak) IBOutlet UITableView *tableView;
@property (weak) IBOutlet UIButton    *doneButton;

- (EndCell *)getCurrEndCell;
- (UILabel *)getCurrArrowLabel;

- (void)setCurrEndID:(NSInteger)currEndID andCurrArrowID:(NSInteger)currArrowID;
- (void)incArrowID;
- (void)decArrowID;
- (void)setScoreForCurrArrow:(NSInteger)score;
- (void)setVisualScore:(NSInteger)score forLabel:(UILabel *)label;
- (void)eraseScoreForCurrArrow;

- (void)updateTotalScores;

- (IBAction)scoreXButtonPressed:(id)sender;
- (IBAction)score10ButtonPressed:(id)sender;
- (IBAction)score9ButtonPressed:(id)sender;
- (IBAction)score8ButtonPressed:(id)sender;
- (IBAction)score7ButtonPressed:(id)sender;
- (IBAction)score6ButtonPressed:(id)sender;
- (IBAction)score5ButtonPressed:(id)sender;
- (IBAction)score4ButtonPressed:(id)sender;
- (IBAction)score3ButtonPressed:(id)sender;
- (IBAction)score2ButtonPressed:(id)sender;
- (IBAction)score1ButtonPressed:(id)sender;
- (IBAction)score0ButtonPressed:(id)sender;

- (IBAction)eraseButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
