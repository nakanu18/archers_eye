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





















//------------------------------------------------------------------------------
- (IBAction)exportSaveData:(id)sender
{
    NSData *data = [self.archersEyeInfo jsonData];
    
    if( data != nil )
    {
        MFMailComposeViewController *picker = [MFMailComposeViewController new];
        
        [picker setSubject:@"Archer's Eye Data"];
        [picker addAttachmentData:data mimeType:@"application/archerseye" fileName:@"ArchersEye.json"];
        [picker setToRecipients:[NSArray array]];
        [picker setMessageBody:@"Body" isHTML:NO];
        [picker setMailComposeDelegate:self];
    }
}

@end
