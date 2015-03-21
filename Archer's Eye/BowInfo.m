//
//  BowInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowInfo.h"

@interface BowInfo ()

- (void)foo;

@end

@implementation BowInfo

- (void)foo
{
    
}

//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eBowType)type
{
    NSString *names[] = { @"Freestyle", @"Barebow", @"Compound", @"Traditional" };
    
    return names[type];
}



//------------------------------------------------------------------------------
- (id)init
{
    return [self initWithName:@"" andType:eBowType_Freestyle];
}



//------------------------------------------------------------------------------
// Copy
- (id)copyWithZone:(NSZone *)zone
{
    BowInfo *obj = [[[self class] alloc] init];
    
    if( obj )
    {
        obj.name        = self.name;
        obj.type        = self.type;
        obj.drawWeight  = self.drawWeight;
    }
    
    return obj;
}



//------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name andType:(eBowType)type
{
    if( self = [super init] )
    {
        self.name   = name;
        _type       = type;
        _drawWeight = 10;
    }
    return self;
}



//------------------------------------------------------------------------------
- (BOOL)isInfoValid
{
    BOOL ans = NO;
    
    if( ![_name isEqualToString:@""]  &&  _type != eBowType_None  &&  _drawWeight > 0 )
        ans = YES;
    
    return ans;
}

@end
