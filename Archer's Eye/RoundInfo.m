//
//  RoundInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundInfo.h"

@implementation RoundInfo

//------------------------------------------------------------------------------
- (id)initWithDate:(NSDate *)date
        andNumEnds:(int)numEnds
   andArrowsPerEnd:(int)numArrowsPerEnd
{
    if( (self = [super init]) )
    {
        [self setDate:date];
        _numEnds         = numEnds;
        _numArrowsPerEnd = numArrowsPerEnd;
        [self setEndScores:[[NSMutableArray alloc] init]];
    }
    return self;
}



//------------------------------------------------------------------------------
- (void)addEnd:(NSMutableArray *)newEndScore
{
    // Safety check: don't add too many ends or arrows
    if( [_endScores count] < _numEnds   &&  [newEndScore count] == _numArrowsPerEnd )
    {
        [_endScores addObject:newEndScore];
        
        NSLog( @"New end score: " );
        for( int i = 0; i < [newEndScore count]; ++i )
        {
            NSLog( @"%d ", (int)[newEndScore objectAtIndex:i] );
        }
        NSLog( @"\n" );
    }
}



//------------------------------------------------------------------------------
- (int)getTotalArrows
{
    int totalArrows = 0;
    
    totalArrows = _numEnds * _numArrowsPerEnd;
    
    return totalArrows;
}



//------------------------------------------------------------------------------
- (int)getTotalScore
{
    int totalScore = 0;
    
    for( int i = 0; i < [_endScores count]; ++i )
    {
        NSMutableArray *currEndScore = [_endScores objectAtIndex:i];
        
        for( int j = 0; j < [currEndScore count]; ++j )
        {
            totalScore += (int)[currEndScore objectAtIndex:j];
        }
    }
    
    return totalScore;
}

@end
