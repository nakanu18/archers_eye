//
//  RoundDateViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 4/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RoundDateViewControllerDelegate <NSObject>

- (void)setDateForCurrentRound:(NSDate *)date;

@end






@interface RoundDateViewController : UIViewController
{
    
}

@property (nonatomic, weak)     IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong)            NSDate       *currDate;

@property (nonatomic, weak) UIViewController <RoundDateViewControllerDelegate> *delegate;






- (IBAction)dateChanged:(id)sender;
- (IBAction)save:(id)sender;

@end
