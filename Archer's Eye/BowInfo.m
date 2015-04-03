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
// Convert bow type to NSString.
//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eBowType)type
{
    NSString *names[] = { @"Recurve", @"Compound", @"Traditional" };
    
    return names[type];
}



//------------------------------------------------------------------------------
// Convert aim type to NSString.
//------------------------------------------------------------------------------
+ (NSString *)aimAsString:(eBowAim)type
{
    NSString *names[] = { @"Sight", @"Instinctive", @"Gap Shooting", @"String Walking" };
    
    return names[type];
}



//------------------------------------------------------------------------------
// Basic init.
//------------------------------------------------------------------------------
- (id)init
{
    return [self initWithName:@"" andType:(eBowType)0 andDrawWeight:10];
}



//------------------------------------------------------------------------------
// Basic init.
//------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name andType:(eBowType)type andDrawWeight:(NSInteger)drawWeight
{
    if( self = [super init] )
    {
        self.name   = name;
        _type       = type;
        _drawWeight = drawWeight;
        _aim        = eBowAim_Instinctive;
    }
    return self;
}



//------------------------------------------------------------------------------
// Copy
//------------------------------------------------------------------------------
- (id)copyWithZone:(NSZone *)zone
{
    BowInfo *obj = [[[self class] alloc] init];
    
    if( obj )
    {
        obj.name        = self.name;
        obj.type        = self.type;
        obj.drawWeight  = self.drawWeight;
        obj.aim         = self.aim;
        obj.clicker     = self.clicker;
        obj.stabilizers = self.stabilizers;
    }
    
    return obj;
}



//------------------------------------------------------------------------------
// Decode.
//------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( self = [super init] )
    {
        self.name           =            [aDecoder decodeObjectForKey:@"name"];
        self.type           = (eBowType)[[aDecoder decodeObjectForKey:@"type"]        integerValue];
        self.drawWeight     =           [[aDecoder decodeObjectForKey:@"drawWeight"]  integerValue];
        self.aim            =  (eBowAim)[[aDecoder decodeObjectForKey:@"aim"]         integerValue];
        self.clicker        =           [[aDecoder decodeObjectForKey:@"clicker"]     boolValue];
        self.stabilizers    =           [[aDecoder decodeObjectForKey:@"stabilizers"] boolValue];
    }
    return self;
}



//------------------------------------------------------------------------------
// Encode.
//------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name                                      forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_type]         forKey:@"type"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_drawWeight]   forKey:@"drawWeight"];
    [aCoder encodeObject:[NSNumber numberWithInt:_aim]              forKey:@"aim"];
    [aCoder encodeObject:[NSNumber numberWithBool:_clicker]         forKey:@"clicker"];
    [aCoder encodeObject:[NSNumber numberWithBool:_stabilizers]     forKey:@"stabilizers"];
}



//------------------------------------------------------------------------------
// Validate bow values.
//------------------------------------------------------------------------------
- (BOOL)isInfoValid
{
    BOOL ans = NO;
    
    if( ![_name isEqualToString:@""]  &&  _type != eBowType_None  &&  _drawWeight > 0 )
        ans = YES;
    
    return ans;
}

@end
