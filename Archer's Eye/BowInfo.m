//
//  BowInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowInfo.h"

@implementation BowInfo

//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eBowType)type
{
    NSString *names[] = { @"Freestyle", @"Barebow", @"Compound", @"Traditional" };
    
    return names[type];
}



//------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name andType:(eBowType)type
{
    if( self = [super init] )
    {
        self.name = name;
        _type     = type;
    }
    return self;
}

@end
