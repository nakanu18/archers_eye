//
//  ChooseDistanceViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeyboardHandlerViewController.h"

@interface RoundInfoViewController : UITableViewController <UITextFieldDelegate>
{
}

@property (nonatomic, weak)            AppDelegate         *appDelegate;
@property (nonatomic, weak)            ArchersEyeInfo      *archersEyeInfo;
@property (nonatomic, weak) IBOutlet   UIBarButtonItem     *barButtonSave;

@property (nonatomic, weak) IBOutlet   UITextField         *textName;
@property (nonatomic, weak) IBOutlet   UISegmentedControl  *segControlRoundType;
@property (nonatomic, weak) IBOutlet   UITextField         *textNumEnds;
@property (nonatomic, weak) IBOutlet   UITextField         *textNumArrows;
@property (nonatomic, weak) IBOutlet   UITextField         *textDistance;
@property (nonatomic, weak) IBOutlet   UISwitch            *switchXExtraPoint;

@property (nonatomic, weak)            UITextField         *textActive;





- (IBAction)xExtraPointChanged:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
