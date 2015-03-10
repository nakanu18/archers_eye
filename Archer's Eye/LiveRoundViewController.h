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
    int _currEndID;
    int _currArrowID;
}

@property (nonatomic, weak)          AppDelegate *appDelegate;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton    *doneButton;

- (EndCell *)getCurrEndCell;
- (UILabel *)getCurrArrowLabel;

- (void)setCurrEndID:(int)currEndID andCurrArrowID:(int)currArrowID;
- (void)incArrowID;
- (void)decArrowID;
- (void)setScoreForCurrArrow:(int)score;
- (void)setVisualScore:(int)score forLabel:(UILabel *)label;
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
