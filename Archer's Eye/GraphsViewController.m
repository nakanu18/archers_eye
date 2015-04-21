//
//  GraphsViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/16/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "GraphsViewController.h"

@interface GraphsViewController ()

@end



@implementation GraphsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.appDelegate    = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.archersEyeInfo =  self.appDelegate.archersEyeInfo;
    
    self.bannerView.delegate = self;
    
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}












- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog( @"GraphsVC: didFailToReceiveAdWithError %@", error );
}

@end
