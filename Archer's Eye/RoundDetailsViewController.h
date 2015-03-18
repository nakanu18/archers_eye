//
//  ChooseDistanceViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RoundDetailsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    __weak AppDelegate *_appDelegate;
    
    NSInteger _leftID;
    NSInteger _rightID;
}

@property (weak) AppDelegate *appDelegate;

- (NSInteger)getCurrDistance;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
