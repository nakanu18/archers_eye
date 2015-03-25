//
//  ChooseDistanceViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RoundInfoViewController : UIViewController
{
}

@property (weak)            AppDelegate         *appDelegate;
@property (weak) IBOutlet   UIBarButtonItem     *barButtonSave;

@property (weak) IBOutlet   UITextField         *textName;
@property (weak) IBOutlet   UISegmentedControl  *segControlRoundType;
@property (weak) IBOutlet   UITextField         *textNumEnds;
@property (weak) IBOutlet   UITextField         *textNumArrows;
@property (weak) IBOutlet   UITextField         *textDefaultDistance;






- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
