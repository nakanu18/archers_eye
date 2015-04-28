//
//  BowInfoViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BowInfo.h"
#import "BowAccessoryViewController.h"

@interface BowInfoViewController : UITableViewController <UITextFieldDelegate, BowAccessoryViewControllerDelegate>
{
}

@property (nonatomic, weak)            AppDelegate        *appDelegate;
@property (nonatomic, weak)            ArchersEyeInfo     *archersEyeInfo;
@property (nonatomic, weak) IBOutlet   UIBarButtonItem    *barButtonSave;

@property (nonatomic, weak) IBOutlet   UITextField        *textBowName;
@property (nonatomic, weak) IBOutlet   UITextField        *textBowDrawWeight;
@property (nonatomic, weak) IBOutlet   UILabel            *labelBowType;
@property (nonatomic, weak) IBOutlet   UISwitch           *switchBowClicker;
@property (nonatomic, weak) IBOutlet   UISwitch           *switchBowStabilizers;
@property (nonatomic, weak) IBOutlet   UILabel            *labelAiming;

@property (nonatomic, weak)            UITextField        *textActive;





- (IBAction)bowClickerSwitched:(id)sender;
- (IBAction)bowStabilizersSwitched:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
