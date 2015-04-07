//
//  MenuViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/6/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MenuViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    
}

@property (nonatomic, weak) AppDelegate     *appDelegate;
@property (nonatomic, weak) ArchersEyeInfo  *archersEyeInfo;






- (IBAction)exportSaveData:(id)sender;

@end
