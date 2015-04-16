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
// Convert eRoundType to a NSString.
//------------------------------------------------------------------------------
+ (NSString *)typeAsString:(eRoundType)type
{
    NSString *names[] = { @"NFAA", @"FITA" };
    
    return names[type];
}



//------------------------------------------------------------------------------
// Get the range of a current section.
//------------------------------------------------------------------------------
+ (NSRange)rangeForSection:(NSInteger)section forType:(eRoundType)roundType
{
    NSInteger   fita[][2]   = { {0,0}, {1,2}, {3,4},    {5,6}, {7,8}, {9,10}, {11,11}, };
    NSInteger   nfaa[][2]   = { {0,0}, {1,1}, {2,2},    {3,3}, {4,4}, {5,5},  {11,11}, };
    NSInteger (*index)[2]   = (roundType == eRoundType_NFAA) ? nfaa : fita;
    NSInteger   min         = index[section][0];
    NSInteger   length      = index[section][1] - index[section][0];
    NSRange     range       = NSMakeRange( min, length );
    
    return range;
}



//------------------------------------------------------------------------------
// Convert a target section to a NSString.
//------------------------------------------------------------------------------
+ (NSString *)stringForSection:(NSInteger)section forType:(eRoundType)roundType
{
    NSString *string;
    NSRange   range = [RoundInfo rangeForSection:section forType:roundType];

    // Special case: for max range (bulleyes)
    if( section == 6 )
        string = @"X";
    else
    {
        // Special case: for single values
        if( range.length == 0 )
        {
            if( range.location == 0 )
                string = @"M";
            else
                string = [NSString stringWithFormat:@"%ld", (unsigned long)range.location];
        }
        // Case: for double values
        else
            string = [NSString stringWithFormat:@"%ld-%ld", (unsigned long)range.location, (unsigned long)(range.location + range.length)];
    }
    
    return string;
}



//------------------------------------------------------------------------------
// Initialize the round.
//------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name
           andType:(eRoundType)type
           andDist:(NSInteger)dist
        andNumEnds:(NSInteger)numEnds
   andArrowsPerEnd:(NSInteger)numArrowsPerEnd
  andXPlusOnePoint:(BOOL)xPlusOnePoint
{
    if( (self = [super init]) )
    {
        self.name        = name;
        _type            = type;
        _distance        = dist;
        _numEnds         = numEnds;
        _numArrowsPerEnd = numArrowsPerEnd;
        _xPlusOnePoint   = xPlusOnePoint;
        
        // Create the array that will hold the array of scores for each end
        [self clearScorecard];
    }
    return self;
}



//------------------------------------------------------------------------------
// Copy
//------------------------------------------------------------------------------
- (id)copyWithZone:(NSZone *)zone
{
    // Initialize the variables.
    id obj = [[[self class] alloc] initWithName:self.name
                                        andType:self.type
                                        andDist:self.distance
                                     andNumEnds:self.numEnds
                                andArrowsPerEnd:self.numArrowsPerEnd
                               andXPlusOnePoint:self.xPlusOnePoint];
    
    if( obj )
    {
        [obj setDate:self.date];
        
        // Copy the arrow values
        for( NSInteger i = 0; i < _numEnds; ++i )
        {
            for( NSInteger j = 0; j < _numArrowsPerEnd; ++j )
            {
                NSInteger score = [self getScoreForEnd:i andArrow:j];
                
                [obj setScore:score forEnd:i andArrow:j];
            }
        }
        [obj setBow:self.bow];
    }    
    return obj;
}



//------------------------------------------------------------------------------
// Decode.
//------------------------------------------------------------------------------
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( self = [super init] )
    {
        DLog( @"RoundInfo: decoding %@", [aDecoder decodeObjectForKey:@"name"] );

        self.name               =              [aDecoder decodeObjectForKey:@"name"];
        self.type               = (eRoundType)[[aDecoder decodeObjectForKey:@"type"]            integerValue];
        self.distance           =             [[aDecoder decodeObjectForKey:@"distance"]        integerValue];
        self.numEnds            =             [[aDecoder decodeObjectForKey:@"numEnds"]         integerValue];
        self.numArrowsPerEnd    =             [[aDecoder decodeObjectForKey:@"numArrowsPerEnd"] integerValue];
        self.xPlusOnePoint      =             [[aDecoder decodeObjectForKey:@"xPlusOnePoint"]   boolValue];
        self.endScores          =              [aDecoder decodeObjectForKey:@"endScores"];
        self.date               =              [aDecoder decodeObjectForKey:@"date"];
        self.bow                =              [aDecoder decodeObjectForKey:@"bow"];
    }
    return self;
}



//------------------------------------------------------------------------------
// Encode.
//------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    DLog( @"RoundInfo: encoding %@", self.name );

    [aCoder encodeObject:_name                                          forKey:@"name"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_type]             forKey:@"type"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_distance]         forKey:@"distance"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_numEnds]          forKey:@"numEnds"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_numArrowsPerEnd]  forKey:@"numArrowsPerEnd"];
    [aCoder encodeObject:[NSNumber numberWithBool:_xPlusOnePoint]       forKey:@"xPlusOnePoint"];
    [aCoder encodeObject:_endScores                                     forKey:@"endScores"];
    [aCoder encodeObject:_date                                          forKey:@"date"];
    [aCoder encodeObject:_bow                                           forKey:@"bow"];
}



//------------------------------------------------------------------------------
// Reads in a dictionary.
//------------------------------------------------------------------------------
- (id)initFromDictionary:(NSDictionary *)dictionary
{
    if( self = [super init] )
    {
        DLog( @"RoundInfo: decoding from json %@", dictionary[@"name"] );

        NSDateFormatter *format = [NSDateFormatter new];
        [format setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        
        self.name               =              dictionary[@"name"];
        self.type               = (eRoundType)[dictionary[@"type"]            integerValue];
        self.distance           =             [dictionary[@"distance"]        integerValue];
        self.numEnds            =             [dictionary[@"numEnds"]         integerValue];
        self.numArrowsPerEnd    =             [dictionary[@"numArrowsPerEnd"] integerValue];
        self.xPlusOnePoint      =             [dictionary[@"xPlusOnePoint"]   boolValue];
        self.date               = [format dateFromString:dictionary[@"date"]];
        
        if( dictionary[@"bow"] != nil )
            self.bow            = [[BowInfo alloc] initFromDictionary:dictionary[@"bow"]];

        // Copy the scores
        self.endScores = [NSMutableArray new];
        for( NSInteger e = 0; e < self.numEnds; ++e )
        {
            NSMutableArray *newEnd = [NSMutableArray new];
            
            for( int a = 0; a < self.numArrowsPerEnd; ++a )
            {
                NSInteger value = [dictionary[@"endScores"][e][a] integerValue];
                
                [newEnd addObject:[NSNumber numberWithInteger:value]];
            }
            [self.endScores addObject:newEnd];
        }
    }
    return self;
}



//------------------------------------------------------------------------------
// Fill all properties into a dictionary.
//------------------------------------------------------------------------------
- (NSDictionary *)dictionary
{
    DLog( @"RoundInfo: encoding to json %@", self.name );

    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    NSMutableDictionary *dm = [NSMutableDictionary new];
    
    [dm setObject:self.name                                         forKey:@"name"];
    [dm setObject:[NSNumber numberWithInteger:self.type]            forKey:@"type"];
    [dm setObject:[NSNumber numberWithInteger:self.distance]        forKey:@"distance"];
    [dm setObject:[NSNumber numberWithInteger:self.numEnds]         forKey:@"numEnds"];
    [dm setObject:[NSNumber numberWithInteger:self.numArrowsPerEnd] forKey:@"numArrowsPerEnd"];
    [dm setObject:[NSNumber numberWithBool:self.xPlusOnePoint]      forKey:@"xPlusOnePoint"];
    [dm setObject:self.endScores                                    forKey:@"endScores"];

    if( self.date != nil )
        [dm setObject:[format stringFromDate:self.date]             forKey:@"date"];
    
    if( self.bow != nil )
        [dm setObject:[self.bow dictionary]                         forKey:@"bow"];
    
    return [NSDictionary dictionaryWithDictionary:dm];
}



//------------------------------------------------------------------------------
// Returns a substring of name ending at the first space.
//------------------------------------------------------------------------------
- (NSString *)firstName
{
    NSArray *array = [self.name componentsSeparatedByString:@" "];
    
    return array[0];
}



//------------------------------------------------------------------------------
// Returns a substring of name ending at the first space.
//------------------------------------------------------------------------------
- (NSString *)lastName
{
    NSString *s = [self.name stringByReplacingOccurrencesOfString:[self firstName] withString:@""];
    
    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return s;
}



//------------------------------------------------------------------------------
// Validate round properties.
//------------------------------------------------------------------------------
- (BOOL)isInfoValid
{
    BOOL ans = NO;
    
    if( ![_name isEqualToString:@""]  &&  _numEnds > 0   &&  _numArrowsPerEnd > 0 )
        ans = YES;
    
    return ans;
}



//------------------------------------------------------------------------------
// Determines if two rounds are of the same type.
//------------------------------------------------------------------------------
- (BOOL)isTypeOfRound:(RoundInfo *)rhs
{
    BOOL ans = NO;
    
    if( [_name isEqualToString:rhs.name]    &&
        _type            == rhs.type        &&
        _distance        == rhs.distance    &&
        _numEnds         == rhs.numEnds     &&
        _numArrowsPerEnd == rhs.numArrowsPerEnd )
        ans = YES;
    
    return ans;
}



//------------------------------------------------------------------------------
// Rebuilds the entire scorecard and clears it
//------------------------------------------------------------------------------
- (void)clearScorecard
{
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



//------------------------------------------------------------------------------
// Find the first empty slot and return it
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
- (void)setScore:(NSInteger)score forEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    if( endID   >= 0  &&  endID   < [_endScores    count]  &&
        arrowID >= 0  &&  arrowID < [_endScores[0] count] )
    {
        [_endScores[endID] replaceObjectAtIndex:arrowID withObject:@(score)];
    }
}



//------------------------------------------------------------------------------
// Get the score for a specific arrow.
//------------------------------------------------------------------------------
- (NSInteger)getScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    NSInteger arrowScore = -1;
    
    if( endID   >= 0  &&  endID   < [_endScores    count]  &&
        arrowID >= 0  &&  arrowID < [_endScores[0] count] )
    {
        arrowScore = [_endScores[endID][arrowID] integerValue];
    }
    
    return arrowScore;
}



//------------------------------------------------------------------------------
// Get the score for a specific arrow.
//------------------------------------------------------------------------------
- (NSInteger)getRealScoreForEnd:(NSInteger)endID andArrow:(NSInteger)arrowID
{
    NSInteger realArrowScore = 0;
    
    if( endID   >= 0  &&  endID   < [_endScores    count]  &&
        arrowID >= 0  &&  arrowID < [_endScores[0] count] )
    {
        NSInteger arrowScore = [_endScores[endID][arrowID] integerValue];
        
        realArrowScore = [self getRealScoreFromArrowValue:arrowScore];
    }
    return realArrowScore;
}



//------------------------------------------------------------------------------
// Get the total score for a specific end.
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
- (NSInteger)getTotalArrows
{
    return _numEnds * _numArrowsPerEnd;
}



//------------------------------------------------------------------------------
// Get the total score for the round.
//------------------------------------------------------------------------------
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
// Get the real max value of an arrow.
//------------------------------------------------------------------------------
- (NSInteger)getMaxArrowRealScore
{
    NSInteger max = 0;
    
    switch( _type )
    {
        case eRoundType_NFAA: max = self.xPlusOnePoint ? 6  : 5;  break;
        case eRoundType_FITA: max = self.xPlusOnePoint ? 11 : 10; break;
        default:              max = 10; break;
    }    
    return max;
}























#pragma mark - Number of arrows with score

//------------------------------------------------------------------------------
// Get number of arrows with a given score.
//------------------------------------------------------------------------------
- (NSInteger)getNumberOfArrowsWithScore:(NSInteger)arrowScore
{
    return [self getNumberOfArrowsWithMinScore:arrowScore andMaxScore:arrowScore];
}



//------------------------------------------------------------------------------
// Get number of arrows within a given score range.
//------------------------------------------------------------------------------
- (NSInteger)getNumberOfArrowsWithMinScore:(NSInteger)minArrowScore
                               andMaxScore:(NSInteger)maxArrowScore
{
    NSInteger numArrows = 0;
    
    for( NSMutableArray *currEndScore in _endScores )
    {
        for( NSNumber *num in currEndScore )
        {
            if( [num integerValue] >= minArrowScore  &&
                [num integerValue] <= maxArrowScore )
                ++numArrows;
        }
    }
    return numArrows;
}



//------------------------------------------------------------------------------
// Get number of arrows with a given score in a given end.
//------------------------------------------------------------------------------
- (NSInteger)getNumberOfArrowsWithScore:(NSInteger)arrowScore forEnd:(NSInteger)endID
{
    NSInteger numArrows = 0;

    for( NSNumber *num in _endScores[endID] )
    {
        if( [num integerValue] == arrowScore )
            ++numArrows;
    }
    return numArrows;
}





















#pragma mark - Private methods

//------------------------------------------------------------------------------
// Converts an arrow value which could be [-1, 11] and converts it to an actual
// archery score.
//------------------------------------------------------------------------------
- (NSInteger)getRealScoreFromArrowValue:(NSInteger)arrowValue
{
    NSInteger realValue = 0;

    if( arrowValue >= 0 )
    {
        realValue = arrowValue;
        
        // Take care of the bullseyes
        if( _type == eRoundType_FITA  &&  realValue >= 11 )
            realValue = self.xPlusOnePoint ? 11 : 10;
        else if( _type == eRoundType_NFAA  && realValue >= 6 )
            realValue = self.xPlusOnePoint ? 6 : 5;
    }
    
    return realValue;
}

@end
