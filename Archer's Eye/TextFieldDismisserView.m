//
//  TextFieldDismisserView.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/21/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "TextFieldDismisserView.h"

@implementation TextFieldDismisserView

//------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if( ![touch.view isMemberOfClass:[UITextField class]] )
         [touch.view endEditing:YES];
    
}

@end
