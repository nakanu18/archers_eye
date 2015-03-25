//
//  RoundInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "RoundInfo.h"

@interface RoundInfo ()

- (NSInteger)getRealScoreFromArrowValue:(NSInteger)arrowValue;

@end



@implementation RoundInfo

//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eRoundType)type
{
    NSString *names[] = { @"NFAA", @"FITA" };
    
    return names[type];
}



//------------------------------------------------------------------------------
// Initialize the round.
- (id)initWithName:(NSString *)name
           andType:(eRoundType)type
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd
{
    if( (self = [super init]) )
    {
        self.name        = name;
        _type            = type;
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
                                        andType:self.type
                                     andNumEnds:self.numEnds
                                andArrowsPerEnd:self.numArrowsPerEnd];
    
    if( obj )
    {
        [obj setDate:self.date];
        
        for( NSInteger i = 0; i < _numEnds; ++i )
        {
            for( NSInteger j = 0; j < _numArrowsPerEnd; ++j )
            {
                NSInteger score = [self getScoreForEnd:i andArrow:j];
                
                [obj setScore:score forEnd:i andArrow:j];
            }
        }
    }    
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
    NSMutableArray *endScore    = [_endScores objectAtIndex:endID];
    NSInteger       arrowScore  = [endScore[arrowID] integerValue];
    
    return arrowScore;
}



//------------------------------------------------------------------------------
// Get the score for a specific arrow.
- (NSInteger)getRealScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    NSMutableArray *endScore    = [_endScores objectAtIndex:endID];
    NSInteger       arrowScore  = [endScore[arrowID] integerValue];

    return [self getRealScoreFromArrowValue:arrowScore];
}



//------------------------------------------------------------------------------
// Get the total score for a specific end.
- (NSInteger)getRealScoreForEnd:(NSInteger)endID
{
    NSInteger endTotal = 0;

    if( endID >= 0  &&  endID < _numEnds )
    {
        NSMutableArray *endScore = [_endScores objectAtIndex:endID];
        
        for( NSInteger i = 0; i < [endScore count]; ++i )
        {
            NSInteger arrowScore = [endScore[i] integerValue];
            
            endTotal += [self getRealScoreFromArrowValue:arrowScore];
        }
    }
    return endTotal;
}



//------------------------------------------------------------------------------
// Get the running total to this the specified end.
- (NSInteger)getRealTotalScoreUpToEnd:(NSInteger)endID
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
                
                currTotal += [self getRealScoreFromArrowValue:arrowScore];
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
- (NSInteger)getRealTotalScore
{
    NSInteger totalScore = 0;
    
    for( NSMutableArray *currEndScore in _endScores )
    {
        for( NSNumber *num in currEndScore )
        {
            NSInteger arrowScore = [num integerValue];
            
            totalScore += [self getRealScoreFromArrowValue:arrowScore];
        }
    }
    
    return totalScore;
}



//------------------------------------------------------------------------------
- (NSInteger)getMaxArrowScore
{
    NSInteger max = 0;
    
    switch( _type )
    {
        case eRoundType_NFAA: max = 5;  break;
        case eRoundType_FITA: max = 10; break;
        default:              max = 10; break;
    }    
    return max;
}



//------------------------------------------------------------------------------
- (BOOL)isInfoValid
{
    BOOL ans = NO;
    
    if( ![_name isEqualToString:@""]  &&  _numEnds > 0   &&  _numArrowsPerEnd > 0 )
        ans = YES;
    
    return ans;
}























#pragma mark - Private methods

//------------------------------------------------------------------------------
// Converts an arrow value which could be [-1, 11] and converts it to an actual
// archery score.
- (NSInteger)getRealScoreFromArrowValue:(NSInteger)arrowValue
{
    NSInteger realValue = 0;

    if( arrowValue >= 0 )
    {
        realValue = arrowValue;
        
        // Take care of the bullseyes
        if( _type == eRoundType_FITA  &&  realValue >= 11 )
            realValue = 10;
        else if( _type == eRoundType_NFAA  && realValue >= 6 )
            realValue = 5;
    }
    
    return realValue;
}

@end
