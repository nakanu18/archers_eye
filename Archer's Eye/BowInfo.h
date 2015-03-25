//
//  BowInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/20/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    eBowType_None = -1,
    eBowType_Recurve,
    eBowType_Compound,
    eBowType_Traditional,
    eBowType_Count,
} eBowType;

@interface BowInfo : NSObject
{
    
}

@property (strong)      NSString   *name;
@property (readwrite)   eBowType    type;
@property (readwrite)   NSInteger   drawWeight;
@property (readwrite)   BOOL        sight;
@property (readwrite)   BOOL        clicker;
@property (readwrite)   BOOL        stabilizers;






- (id)init;

+ (NSString *)typeAsString:(eBowType)type;
- (id)initWithName:(NSString *)name andType:(eBowType)type andDrawWeight:(NSInteger)drawWeight;
- (BOOL)isInfoValid;

@end
