//
//  NSDate+Info.m
//  Archer's Eye
//
//  Created by Alex de Vera on 4/8/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "NSDate+Info.h"

@implementation NSDate (Info)

//------------------------------------------------------------------------------
- (NSInteger)year
{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
}



//------------------------------------------------------------------------------
- (NSInteger)month
{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self];
}

@end
