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

@interface BowInfoViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *_activeTextField;
}

@property (weak)    AppDelegate                 *appDelegate;

@property (weak)    IBOutlet UIScrollView       *scrollView;
@property (weak)    IBOutlet UIBarButtonItem    *barButtonSave;

@property (weak)    IBOutlet UITextField        *bowName;
@property (weak)    IBOutlet UITextField        *bowDrawWeight;
@property (weak)    IBOutlet UISegmentedControl *bowType;
@property (weak)    IBOutlet UISwitch           *bowSight;
@property (weak)    IBOutlet UISwitch           *bowClicker;
@property (weak)    IBOutlet UISwitch           *bowStabilizers;






- (IBAction)bowTypeChanged:(id)sender;
- (IBAction)bowSightSwitched:(id)sender;
- (IBAction)bowClickerSwitched:(id)sender;
- (IBAction)bowStabilizersSwitched:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
