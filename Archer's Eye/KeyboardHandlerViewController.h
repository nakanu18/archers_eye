//
//  KeyboardHandlerViewController.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/25/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardHandlerViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *_activeTextField;
}

@property (weak) IBOutlet UIScrollView *scrollView;






- (void)registerForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)addToolbarToNumberPad:(UITextField *)field;
- (void)doneWithNumberPad;

@end
