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

@property (nonatomic, strong)      NSString   *name;
@property (nonatomic, readwrite)   eBowType    type;
@property (nonatomic, readwrite)   NSInteger   drawWeight;
@property (nonatomic, readwrite)   BOOL        sight;
@property (nonatomic, readwrite)   BOOL        clicker;
@property (nonatomic, readwrite)   BOOL        stabilizers;






+ (NSString *)typeAsString:(eBowType)type;

- (id)init;
- (id)initWithName:(NSString *)name andType:(eBowType)type andDrawWeight:(NSInteger)drawWeight;
- (BOOL)isInfoValid;

@end
