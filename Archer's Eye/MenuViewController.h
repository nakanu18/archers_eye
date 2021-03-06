//
//  MenuViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/6/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface MenuViewController : UIViewController <ADBannerViewDelegate>
{
    
}

@property (nonatomic, weak)          AppDelegate     *appDelegate;
@property (nonatomic, weak)          ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, weak) IBOutlet ADBannerView    *bannerView;

@end
