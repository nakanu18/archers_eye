//
//  ChooseDistanceViewController.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/18/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundDetailsViewController.h"

@interface RoundDetailsViewController ()

@end

@implementation RoundDetailsViewController

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------------------------------------------------------
- (NSInteger)getCurrDistance
{
    return 10 * (_leftID + 1) + _rightID;
}



//------------------------------------------------------------------------------
- (IBAction)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToNewLiveRound" sender:self];
}



//------------------------------------------------------------------------------
- (IBAction)done:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToNewLiveRound" sender:self];
}
























#pragma mark - UIPickerDataSource

//------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}



//------------------------------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return (component == 0) ? 7 : 10;
}





















#pragma mark - UIPickerViewDelegate

//------------------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *strings = nil;
    
    if( component == 0 )
        strings = [NSString stringWithFormat:@"%ld", row + 1];
    else
        strings = [NSString stringWithFormat:@"%ld", row];
    
    return strings;
}




//------------------------------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if( component == 0 )
        _leftID = row;
    else
        _rightID = row;
}

@end
