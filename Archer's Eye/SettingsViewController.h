//
//  SettingsViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    
}

@property (nonatomic, weak)      AppDelegate     *appDelegate;
@property (nonatomic, weak)      ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, readwrite) BOOL             confirmPurge;







- (void)exportSaveData;
- (void)confirmPurgeSaveData;

- (void)confirmResetAllHints;

@end
