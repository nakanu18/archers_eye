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

@interface RoundEditorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSInteger _currEndID;
    NSInteger _currArrowID;
}

@property (weak)          AppDelegate        *appDelegate;
@property (weak)          RoundInfo          *currRound;
@property (weak) IBOutlet UITableView        *tableView;
@property (weak) IBOutlet UIBarButtonItem    *exitButton;
@property (weak) IBOutlet UIBarButtonItem    *doneButton;           // Not currently used
@property (weak) IBOutlet UIButton           *buttonChangeBow;
@property (weak) IBOutlet UIView             *controlsFITA;
@property (weak) IBOutlet UIView             *controlsNFAA;
@property (weak) IBOutlet NSLayoutConstraint *constraintFITA;
@property (weak) IBOutlet NSLayoutConstraint *constraintNFAA;

@property (weak) IBOutlet UIButton           *buttonErase;

// Used to pull the color properties from the storyboard
@property (weak) IBOutlet UIButton           *buttonFITAYellow;
@property (weak) IBOutlet UIButton           *buttonFITARed;
@property (weak) IBOutlet UIButton           *buttonFITABlue;
@property (weak) IBOutlet UIButton           *buttonFITABlack;
@property (weak) IBOutlet UIButton           *buttonFITAWhite;

// Used to pull the color properties from the storyboard
@property (weak) IBOutlet UIButton           *buttonNFAAWhite;
@property (weak) IBOutlet UIButton           *buttonNFAABlue;





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
- (IBAction)exitButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
