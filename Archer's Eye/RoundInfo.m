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
// Initialize the round.
- (id)initWithDate:(NSDate *)date
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd
{
    if( (self = [super init]) )
    {
        [self setDate:date];
        _numEnds         = numEnds;
        _numArrowsPerEnd = numArrowsPerEnd;
        
        // Create the array that will hold the array of scores for each end
        [self setEndScores:[[NSMutableArray alloc] init]];
        
        for( NSInteger i = 0; i < _numEnds; ++i )
        {
            NSMutableArray *newEndScore = [[NSMutableArray alloc] init];
            
            for( NSInteger j = 0; j < _numArrowsPerEnd; ++j )
            {
                [newEndScore addObject:@(-1)];
            }
            [_endScores addObject:newEndScore];
        }
    }
    return self;
}



//------------------------------------------------------------------------------
// Set the score for a specific arrow.
- (void)setScore:(NSInteger)score forEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    if( endID   >= 0  &&  endID   < _numEnds            &&
        arrowID >= 0  &&  arrowID < _numArrowsPerEnd )
    {
        NSMutableArray *endScore = [_endScores objectAtIndex:endID];
        
        [endScore replaceObjectAtIndex:arrowID withObject:@(score)];
    }
}



//------------------------------------------------------------------------------
// Get the score for a specific arrow.
- (NSInteger)getScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    NSMutableArray *endScore = [_endScores objectAtIndex:endID];

    return [endScore[arrowID] integerValue];
}



//------------------------------------------------------------------------------
// Get the total score for a specific end.
- (NSInteger)getScoreForEnd:(NSInteger)endID
{
    NSInteger endTotal = 0;

    if( endID >= 0  &&  endID < _numEnds )
    {
        NSMutableArray *endScore = [_endScores objectAtIndex:endID];
        
        for( NSInteger i = 0; i < [endScore count]; ++i )
        {
            NSInteger arrowScore = [endScore[i] integerValue];
            
            endTotal += (arrowScore > 0) ? arrowScore : 0;
        }
    }
    return endTotal;
}



//------------------------------------------------------------------------------
// Get the running total to this the specified end.
- (NSInteger)getTotalScoreUpToEnd:(NSInteger)endID
{
    NSInteger currTotal = 0;
    
    if( endID >= 0  &&  endID < _numEnds )
    {
        for( NSInteger i = 0; i <= endID; ++i )
        {
            NSMutableArray *endScore = [_endScores objectAtIndex:i];
            
            for( NSNumber *num in endScore )
            {
                NSInteger arrowScore = [num integerValue];
                
                currTotal += (arrowScore > 0) ? arrowScore : 0;
            }
        }
    }
    return currTotal;
}



//------------------------------------------------------------------------------
// Get the total number of arrows in a round.
- (NSInteger)getTotalArrows
{
    return _numEnds * _numArrowsPerEnd;
}



//------------------------------------------------------------------------------
// Get the total score for the round.
- (NSInteger)getTotalScore
{
    NSInteger totalScore = 0;
    
    for( NSMutableArray *currEndScore in _endScores )
    {
        for( NSNumber *num in currEndScore )
        {
            NSInteger arrowScore = [num integerValue];
            
            if( arrowScore >= 0 )
                totalScore += arrowScore;
        }
    }
    
    return totalScore;
}

@end
