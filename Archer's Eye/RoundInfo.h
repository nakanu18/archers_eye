//
//  RoundInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BowInfo.h"

typedef enum
{
    eRoundType_NFAA,    // [-1, 6]  -> [no score, bullseye]
    eRoundType_FITA,    // [-1, 11] -> [no score, bullseye]
    eRoundType_Count,
} eRoundType;

@interface RoundInfo : NSObject <NSCopying>
{
}

@property (strong)      NSString       *name;
@property (readwrite)   eRoundType      type;
@property (readwrite)   NSInteger       distance;
@property (readwrite)   NSInteger       numEnds;
@property (readwrite)   NSInteger       numArrowsPerEnd;
@property (strong)      NSMutableArray *endScores;
@property (strong)      NSDate         *date;

@property (copy)        BowInfo         *bow;






+ (NSString *)typeAsString:(eRoundType)type;

- (id)initWithName:(NSString *)name
           andType:(eRoundType)type
           andDist:(NSInteger)dist
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd;

- (void)clearScorecard;
- (CGPoint)getCurrEndAndArrow;  // y = end, x = arrow

- (void)setScore:(NSInteger)score forEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getRealScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getRealScoreForEnd:(NSInteger)endID;
- (NSInteger)getRealTotalScoreUpToEnd:(NSInteger)endID;
- (NSInteger)getTotalArrows;
- (NSInteger)getRealTotalScore;
- (NSInteger)getMaxArrowScore;

- (BOOL)isInfoValid;

@end
