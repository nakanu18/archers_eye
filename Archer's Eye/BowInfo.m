//
//  BowInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "BowInfo.h"

@interface BowInfo ()

@end



@implementation BowInfo

//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eBowType)type
{
    NSString *names[] = { @"Freestyle Recurve", @"Barebow", @"Compound", @"Traditional" };
    
    return names[type];
}



//------------------------------------------------------------------------------
- (id)init
{
    return [self initWithName:@"" andType:(eBowType)0 andDrawWeight:10];
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
- (id)initWithName:(NSString *)name andType:(eBowType)type andDrawWeight:(NSInteger)drawWeight
{
    if( self = [super init] )
    {
        self.name   = name;
        _type       = type;
        _drawWeight = drawWeight;
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
