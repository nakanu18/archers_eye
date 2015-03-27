//
//  BowInfoViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeyboardHandlerViewController.h"
#import "BowInfo.h"

@interface BowInfoViewController : KeyboardHandlerViewController <UITextFieldDelegate>
{
}

@property (weak)            AppDelegate        *appDelegate;
@property (weak) IBOutlet   UIBarButtonItem    *barButtonSave;

@property (weak) IBOutlet   UITextField        *textBowName;
@property (weak) IBOutlet   UILabel            *labelBowDrawWeight;
@property (weak) IBOutlet   UISlider           *sliderBowDrawWeight;
@property (weak) IBOutlet   UISegmentedControl *segControlBowType;
@property (weak) IBOutlet   UISwitch           *switchBowSight;
@property (weak) IBOutlet   UISwitch           *switchBowClicker;
@property (weak) IBOutlet   UISwitch           *switchBowStabilizers;






- (IBAction)bowDrawWeightChanged:(id)sender;
- (IBAction)bowTypeChanged:(id)sender;
- (IBAction)bowSightSwitched:(id)sender;
- (IBAction)bowClickerSwitched:(id)sender;
- (IBAction)bowStabilizersSwitched:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
