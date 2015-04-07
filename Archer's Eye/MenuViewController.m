//
//  MenuViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/6/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end



@implementation MenuViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





















#pragma mark - Mail

//------------------------------------------------------------------------------
- (IBAction)exportSaveData:(id)sender
{
    NSData *data = [self.archersEyeInfo jsonData];
    
    if( data != nil )
    {
        MFMailComposeViewController *picker = [MFMailComposeViewController new];
        NSString                     *body;
        NSString                     *saveFile;
        
        body     = @"The attached .aed file is save data for Archer's Eye.\n\nMail this to yourself for safe keeping.\n\nTo load, open this mail on your iOS device.  Press and hold on the .aed file.  From the list of apps that appears, pick Archer's Eye.";
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
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
