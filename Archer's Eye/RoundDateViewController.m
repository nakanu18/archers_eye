//
//  RoundDateViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundDateViewController.h"

@interface RoundDateViewController ()

@end

@implementation RoundDateViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make a temp copy we can adjust freely
    [self.datePicker setDate:self.currDate animated:YES];
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}












//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (IBAction)dateChanged:(id)sender
{
    self.currDate = [self.datePicker date];
}



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
- (IBAction)save:(id)sender
{
    // Send our editted date to the delegate
    if( self.delegate != nil )
    {
        if( [self.delegate respondsToSelector:@selector(setDateForCurrentRound:)] )
            [self.delegate setDateForCurrentRound:self.currDate];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
