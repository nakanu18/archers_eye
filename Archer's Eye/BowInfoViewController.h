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

@interface BowInfoViewController : KeyboardHandlerViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
}

@property (nonatomic, weak)            AppDelegate        *appDelegate;
@property (nonatomic, weak)            ArchersEyeInfo     *archersEyeInfo;
@property (nonatomic, weak) IBOutlet   UIBarButtonItem    *barButtonSave;

@property (nonatomic, weak) IBOutlet   UITextField        *textBowName;
@property (nonatomic, weak) IBOutlet   UILabel            *labelBowDrawWeight;
@property (nonatomic, weak) IBOutlet   UISlider           *sliderBowDrawWeight;
@property (nonatomic, weak) IBOutlet   UIStepper          *stepperBowDrawWeight;
@property (nonatomic, weak) IBOutlet   UISegmentedControl *segControlBowType;
@property (nonatomic, weak) IBOutlet   UIPickerView       *pickerBowAim;
@property (nonatomic, weak) IBOutlet   UISwitch           *switchBowClicker;
@property (nonatomic, weak) IBOutlet   UISwitch           *switchBowStabilizers;






- (IBAction)bowDrawWeightChanged:(id)sender;
- (IBAction)bowTypeChanged:(id)sender;
- (IBAction)bowClickerSwitched:(id)sender;
- (IBAction)bowStabilizersSwitched:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
