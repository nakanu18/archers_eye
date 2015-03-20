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
    eBowType_Freestyle,
    eBowType_Barebow,
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






+ (NSString *)typeAsString:(eBowType)type;
- (id)initWithName:(NSString *)name andType:(eBowType)type;

@end
