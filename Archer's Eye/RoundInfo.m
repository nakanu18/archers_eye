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
- (id)initWithName:(NSString *)name
           andDate:(NSDate *)date
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd
{
    if( (self = [super init]) )
    {
        self.name        = name;
        self.date        = date;
        _numEnds         = numEnds;
        _numArrowsPerEnd = numArrowsPerEnd;
        
        // Create the array that will hold the array of scores for each end
        [self setEndScores:[NSMutableArray new]];
        
        for( NSInteger i = 0; i < _numEnds; ++i )
        {
            NSMutableArray *newEndScore = [NSMutableArray new];
            
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
// Copy
- (id)copyWithZone:(NSZone *)zone
{
    id obj = [[[self class] alloc] initWithName:self.name
                                        andDate:self.date
                                     andNumEnds:self.numEnds
                                andArrowsPerEnd:self.numArrowsPerEnd];
    
    return obj;
}



//------------------------------------------------------------------------------
// Clear all the scores stored
- (void)clearAllScores
{
    for( NSArray *endScore in _endScores )
    {
        for( __strong NSNumber *arrow in endScore )
        {
            arrow = @(-1);
        }
    }
}



//------------------------------------------------------------------------------
// Find the first empty slot and return it
- (CGPoint)getCurrEndAndArrow
{
    CGPoint position    = CGPointMake( 0, 0 );
    BOOL    foundEmpty  = NO;
    
    for( NSArray *endScore in _endScores )
    {
        for( NSNumber *arrow in endScore )
        {
            if( [arrow integerValue] == -1 )
            {
                foundEmpty = YES;
                break;
            }
            
            position.x += 1;
        }
        
        if( foundEmpty )
            break;
        
        position.y += 1;    // row
        position.x  = 0;    // column
    }
    
    return position;
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
