//
//  SettingsViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/9/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
}




//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
























#pragma mark - Table view data source

//------------------------------------------------------------------------------
// Did select a row.
//------------------------------------------------------------------------------
-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Manage data
    if( indexPath.section == 0 )
    {
        if( indexPath.row == 1 )
            [self exportSaveData];
        else if( indexPath.row == 2 )
            [self confirmPurgeSaveData];
    }
    // Hints
    else if( indexPath.section == 1 )
    {
        if( indexPath.row == 0 )
            [self confirmResetAllHints];
    }
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}





















#pragma mark - Data

//------------------------------------------------------------------------------
// Package save data and export via email.
//------------------------------------------------------------------------------
- (void)exportSaveData
{
    NSData *data = [self.archersEyeInfo jsonData];
    
    if( data != nil )
    {
        MFMailComposeViewController *picker = [MFMailComposeViewController new];
        NSString                     *body;
        NSString                     *saveFile;
        
        body     = @"The attached .aed file is save data for Archer's Eye.\n\nMail this to yourself for safe keeping.\n\nPLEASE SAVE REGULARLY.\n\nTo load, open this mail on your iOS device.  Press and hold on the .aed file.  From the list of apps that appears, pick Archer's Eye.";
        saveFile = [NSString stringWithFormat:@"ArchersEye - %@.aed", [AppDelegate shortDate:[NSDate date]]];
        
        [picker setSubject:@"Archer's Eye Data"];
        [picker addAttachmentData:data mimeType:@"application/archerseye" fileName:saveFile];
        [picker setToRecipients:[NSArray array]];
        [picker setMessageBody:body isHTML:NO];
        [picker setMailComposeDelegate:self];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}



//------------------------------------------------------------------------------
// Confirm user wants to purge save data.
//------------------------------------------------------------------------------
- (void)confirmPurgeSaveData
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Purge and Load Defaults?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Load", nil];
    
    [alertView show];
    self.confirmPurge = YES;
}



//------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}





















#pragma mark - Hints

//------------------------------------------------------------------------------
// Confirm user wants to reset all hints.
//------------------------------------------------------------------------------
- (void)confirmResetAllHints
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Reset All Hints?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Reset", nil];
    
    [alertView show];
    self.confirmPurge = NO;
}





















#pragma mark - UIAlertView

//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Manage data
    if( self.confirmPurge )
    {
        if( buttonIndex == 1 )
        {
            [self.archersEyeInfo clearData];
            [self.archersEyeInfo loadDataFromDevice];
        }
    }
    // Hints
    else
    {
        if( buttonIndex == 1 )
        {
        }
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
