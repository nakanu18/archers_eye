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

@property (nonatomic, weak)          AppDelegate        *appDelegate;
@property (nonatomic, weak)          ArchersEyeInfo     *archersEyeInfo;
@property (nonatomic, weak)          RoundInfo          *currRound;
@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *exitButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *doneButton;           // Not currently used
@property (nonatomic, weak) IBOutlet UIButton           *buttonConfigureBow;
@property (nonatomic, weak) IBOutlet UIView             *controlsFITA;
@property (nonatomic, weak) IBOutlet UIView             *controlsNFAA;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintFITA;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *constraintNFAA;

@property (nonatomic, weak) IBOutlet UIButton           *buttonErase;

// Used to pull the color properties from the storyboard
@property (nonatomic, weak) IBOutlet UIButton           *buttonFITAYellow;
@property (nonatomic, weak) IBOutlet UIButton           *buttonFITARed;
@property (nonatomic, weak) IBOutlet UIButton           *buttonFITABlue;
@property (nonatomic, weak) IBOutlet UIButton           *buttonFITABlack;
@property (nonatomic, weak) IBOutlet UIButton           *buttonFITAWhite;

// Used to pull the color properties from the storyboard
@property (nonatomic, weak) IBOutlet UIButton           *buttonNFAAWhite;
@property (nonatomic, weak) IBOutlet UIButton           *buttonNFAABlue;





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
- (IBAction)configureBowPressed:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
