//
//  RoundInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundInfo : NSObject
{
    NSDate         *_date;
    int             _numEnds;
    int             _numArrowsPerEnd;
    NSMutableArray *_endScores;
}

- (id)initWithDate:(NSDate *)date
        andNumEnds:(int)numEnds
   andArrowsPerEnd:(int)numArrowsPerEnd;

- (void)addEnd:(NSMutableArray *)endScore;

- (int)getTotalArrows;
- (int)getTotalScore;

@property (nonatomic, strong) NSDate         *date;
@property (nonatomic, strong) NSMutableArray *endScores;

@end
