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

@interface BowInfoViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextField *_activeTextField;
}

@property (weak)    AppDelegate              *appDelegate;
@property (strong)  BowInfo                  *bowInfo;

@property (weak)    IBOutlet UIScrollView    *scrollView;
@property (weak)    IBOutlet UITextField     *bowName;
@property (weak)    IBOutlet UITextField     *bowDrawWeight;
@property (weak)    IBOutlet UIBarButtonItem *barButtonSave;





- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
