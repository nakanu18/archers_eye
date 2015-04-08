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
        DLog( @"BowInfo: decoding %@", [aDecoder decodeObjectForKey:@"name"] );

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
    DLog( @"BowInfo: encoding %@", self.name );

    [aCoder encodeObject:_name                                      forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_type]         forKey:@"type"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_drawWeight]   forKey:@"drawWeight"];
    [aCoder encodeObject:[NSNumber numberWithInt:_aim]              forKey:@"aim"];
    [aCoder encodeObject:[NSNumber numberWithBool:_clicker]         forKey:@"clicker"];
    [aCoder encodeObject:[NSNumber numberWithBool:_stabilizers]     forKey:@"stabilizers"];
}



//------------------------------------------------------------------------------
// Reads in a dictionary.
//------------------------------------------------------------------------------
- (id)initFromDictionary:(NSDictionary *)dictionary
{
    if( self = [super init] )
    {
        DLog( @"BowInfo: decoding from json %@", dictionary[@"name"] );

        self.name           =            dictionary[@"name"];
        self.type           = (eBowType)[dictionary[@"type"]        integerValue];
        self.drawWeight     =           [dictionary[@"drawWeight"]  integerValue];
        self.aim            =  (eBowAim)[dictionary[@"aim"]         integerValue];
        self.clicker        =           [dictionary[@"clicker"]     boolValue];
        self.stabilizers    =           [dictionary[@"stabilizers"] boolValue];
    }
    return self;
}



//------------------------------------------------------------------------------
// Fill all properties into a dictionary.
//------------------------------------------------------------------------------
- (NSDictionary *)dictionary
{
    DLog( @"BowInfo: encoding to json %@", self.name );

    NSDictionary *dict = @{
                           @"name"              : self.name,
                           @"type"              : [NSNumber numberWithInteger:self.type],
                           @"drawWeight"        : [NSNumber numberWithInteger:self.drawWeight],
                           @"aim"               : [NSNumber numberWithInteger:self.aim],
                           @"clicker"           : [NSNumber numberWithBool:self.clicker],
                           @"stabilizers"       : [NSNumber numberWithBool:self.stabilizers],
                           };
    
    return dict;
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



//------------------------------------------------------------------------------
// Determines if two rounds are of the same type.
//------------------------------------------------------------------------------
- (BOOL)isTypeOfBow:(BowInfo *)rhs
{
    BOOL ans = NO;
    
    if( [_name isEqualToString:rhs.name]    &&
        _type       == rhs.type             &&
        _drawWeight == rhs.drawWeight )
        ans = YES;
    
    return ans;
}

@end
