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
        andNumEnds:(int)numEnds
   andArrowsPerEnd:(int)numArrowsPerEnd
{
    if( (self = [super init]) )
    {
        [self setDate:date];
        _numEnds         = numEnds;
        _numArrowsPerEnd = numArrowsPerEnd;
        
        // Create the array that will hold the array of scores for each end
        [self setEndScores:[[NSMutableArray alloc] init]];
        
        for( int i = 0; i < _numEnds; ++i )
        {
            NSMutableArray *newEndScore = [[NSMutableArray alloc] init];
            
            for( int j = 0; j < _numArrowsPerEnd; ++j )
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
- (void)setScore:(int)score forEnd:(int)endID andArrow:(int)arrowID
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
- (int)getScoreForEnd:(int)endID andArrow:(int)arrowID
{
    NSMutableArray *endScore = [_endScores objectAtIndex:endID];

    return [endScore[arrowID] intValue];
}



//------------------------------------------------------------------------------
// Get the total score for a specific end.
- (int)getScoreForEnd:(int)endID
{
    int endTotal = 0;

    if( endID >= 0  &&  endID < _numEnds )
    {
        NSMutableArray *endScore = [_endScores objectAtIndex:endID];
        
        for( int i = 0; i < [endScore count]; ++i )
        {
            int arrowScore = [endScore[i] intValue];
            
            endTotal += (arrowScore > 0) ? arrowScore : 0;
        }
    }
    return endTotal;
}



//------------------------------------------------------------------------------
// Get the running total to this the specified end.
- (int)getTotalScoreUpToEnd:(int)endID
{
    int currTotal = 0;
    
    if( endID >= 0  &&  endID < _numEnds )
    {
        for( int i = 0; i <= endID; ++i )
        {
            NSMutableArray *endScore = [_endScores objectAtIndex:i];
            
            for( NSNumber *num in endScore )
            {
                int arrowScore = [num intValue];
                
                currTotal += (arrowScore > 0) ? arrowScore : 0;
            }
        }
    }
    return currTotal;
}



//------------------------------------------------------------------------------
// Get the total number of arrows in a round.
- (int)getTotalArrows
{
    return _numEnds * _numArrowsPerEnd;
}



//------------------------------------------------------------------------------
// Get the total score for the round.
- (int)getTotalScore
{
    int totalScore = 0;
    
    for( NSMutableArray *currEndScore in _endScores )
    {
        for( NSNumber *num in currEndScore )
        {
            int arrowScore = [num intValue];
            
            if( arrowScore >= 0 )
                totalScore += arrowScore;
        }
    }
    
    return totalScore;
}

@end
