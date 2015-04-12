//
//  RoundInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Defines.h"
#import "BowInfo.h"
#import "NSDate+Info.h"

// NOTE: values stored in _endScores correspond to the values above in
// eRoundType.
// NFAA is [0, 5].
// FITA is [0, 10].
// -1 means no arrow scored.
// 11 means bullseye.
//
// Use any method with Real in it to get the actual real life score.  For
// example, bullseyes aren't worth more points than the max.  A bullseye should
// return a 5 or 10 for a Real score.

typedef enum
{
    eRoundType_NFAA,    // [-1, 5]  -> [no score, max] - 11 is bullseye
    eRoundType_FITA,    // [-1, 10] -> [no score, max] - 11 is bullseye
    eRoundType_Count,
} eRoundType;

@interface RoundInfo : NSObject <NSCopying>
{
}

@property (nonatomic, strong)      NSString       *name;
@property (nonatomic, readwrite)   eRoundType      type;
@property (nonatomic, readwrite)   NSInteger       distance;
@property (nonatomic, readwrite)   NSInteger       numEnds;
@property (nonatomic, readwrite)   NSInteger       numArrowsPerEnd;
@property (nonatomic, strong)      NSMutableArray *endScores;
@property (nonatomic, strong)      NSDate         *date;

@property (nonatomic, copy)        BowInfo         *bow;






+ (NSString *)typeAsString:(eRoundType)type;
+ (NSRange)rangeForSection:(NSInteger)section forType:(eRoundType)roundType;
+ (NSString *)stringForSection:(NSInteger)section forType:(eRoundType)roundType;



- (id)initWithName:(NSString *)name
           andType:(eRoundType)type
           andDist:(NSInteger)dist
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd;

- (id)initFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

- (NSString *)firstName;
- (NSString *)lastName;
- (BOOL)isInfoValid;
- (BOOL)isTypeOfRound:(RoundInfo *)rhs;
- (void)clearScorecard;
- (CGPoint)getCurrEndAndArrow;  // y = end, x = arrow

- (void)setScore:(NSInteger)score forEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getRealScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID;
- (NSInteger)getRealScoreForEnd:(NSInteger)endID;
- (NSInteger)getRealTotalScoreUpToEnd:(NSInteger)endID;
- (NSInteger)getTotalArrows;
- (NSInteger)getRealTotalScore;
- (NSInteger)getMaxArrowRealScore;

- (NSInteger)getNumberOfArrowsWithScore:(NSInteger)arrowScore;
- (NSInteger)getNumberOfArrowsWithMinScore:(NSInteger)minArrowScore andMaxScore:(NSInteger)maxArrowScore;
- (NSInteger)getNumberOfArrowsWithScore:(NSInteger)arrowScore forEnd:(NSInteger)endID;

@end
