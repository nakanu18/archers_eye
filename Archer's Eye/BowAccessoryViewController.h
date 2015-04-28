//
//  BowAccessoryViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/27/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LabelCell.h"

@protocol BowAccessoryViewControllerDelegate <NSObject>

- (void)setAccessoryForCurrentBow:(NSInteger)accessoryID forID:(NSInteger)ID;

@end



@interface BowAccessoryViewController : UITableViewController
{
    
}

@property (nonatomic, weak) id <BowAccessoryViewControllerDelegate> delegate;

@property (nonatomic, weak)      AppDelegate     *appDelegate;
@property (nonatomic, weak)      ArchersEyeInfo  *archersEyeInfo;

@property (nonatomic, strong)    NSMutableArray  *arrayNames;
@property (nonatomic, readwrite) NSInteger        ID;

@end
