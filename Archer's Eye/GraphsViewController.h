//
//  GraphsViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/16/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface GraphsViewController : UIViewController <ADBannerViewDelegate>
{
    
}

@property (nonatomic, weak)          AppDelegate     *appDelegate;
@property (nonatomic, weak)          ArchersEyeInfo  *archersEyeInfo;
@property (nonatomic, weak) IBOutlet ADBannerView    *bannerView;

@end
