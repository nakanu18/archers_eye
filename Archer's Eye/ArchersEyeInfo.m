//
//  ArchersEyeInfo.m
//  Archer's Eye
//
//  Created by Alex de Vera on 3/31/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import "ArchersEyeInfo.h"

@implementation ArchersEyeInfo

#pragma mark - Load/Save

//------------------------------------------------------------------------------
// Load some default values.
//------------------------------------------------------------------------------
- (void)loadDefaults
{
    self.customRounds   = [NSMutableArray new];
    self.commonRounds   = [NSMutableArray new];
    self.pastRounds     = [NSMutableArray new];
    self.allBows        = [NSMutableArray new];
    _currBowID          = -1;
    _currRoundID        = -1;
    
    RoundInfo *fita600Round = [[RoundInfo alloc] initWithName:@"FITA 600" andType:eRoundType_FITA andDist:20 andNumEnds:20 andArrowsPerEnd:3];
    RoundInfo *nfaa300Round = [[RoundInfo alloc] initWithName:@"NFAA 300" andType:eRoundType_NFAA andDist:20 andNumEnds:12 andArrowsPerEnd:5];
    RoundInfo *shortRound   = [[RoundInfo alloc] initWithName:@"TEST 25"  andType:eRoundType_FITA andDist:20 andNumEnds:1  andArrowsPerEnd:5];
    [_commonRounds addObject:fita600Round];
    [_commonRounds addObject:nfaa300Round];
    [_commonRounds addObject:shortRound];
    
    
    BowInfo *whiteFlute = [[BowInfo alloc] initWithName:@"White Flute" andType:eBowType_Recurve  andDrawWeight:28];
    BowInfo *blackPSE   = [[BowInfo alloc] initWithName:@"Black PSE"   andType:eBowType_Compound andDrawWeight:60];
    [_allBows addObject:whiteFlute];
    [_allBows addObject:blackPSE];
}



//------------------------------------------------------------------------------
// Load the save data if it can be found.
//------------------------------------------------------------------------------
- (void)loadData
{
    NSData *saveData = [[NSUserDefaults standardUserDefaults] dataForKey:@"archersEyeInfo"];

    // No save data file; load the defaults
    if( saveData == nil )
    {
#ifdef NSLOGS_ON
        NSLog( @"No save file found: loading defaults" );
#endif
        
        [self loadDefaults];
    }
    // Found save data file; load it
    else
    {
#ifdef NSLOGS_ON
        NSLog( @"Found save file: loading" );
#endif
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
        
        self.liveRound      = [unarchiver decodeObjectForKey:@"liveRound"];
        self.customRounds   = [unarchiver decodeObjectForKey:@"customRounds"];
        self.commonRounds   = [unarchiver decodeObjectForKey:@"commonRounds"];
        self.currRound      = [unarchiver decodeObjectForKey:@"currRound"];
        self.pastRounds     = [unarchiver decodeObjectForKey:@"pastRounds"];
        self.currBow        = [unarchiver decodeObjectForKey:@"currBow"];
        self.allBows        = [unarchiver decodeObjectForKey:@"allBows"];
        [unarchiver finishDecoding];
    }
}



//------------------------------------------------------------------------------
// Save the current user data.
//------------------------------------------------------------------------------
- (void)saveData
{
#ifdef NSLOGS_ON
    NSLog( @"Saving data" );
#endif
    
    NSMutableData   *saveData      = [[NSMutableData    alloc] init];
    NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver  alloc] initForWritingWithMutableData:saveData];
    
    [keyedArchiver encodeObject:_liveRound      forKey:@"liveRound"];
    [keyedArchiver encodeObject:_customRounds   forKey:@"customRounds"];
    [keyedArchiver encodeObject:_commonRounds   forKey:@"commonRounds"];
    [keyedArchiver encodeObject:_currRound      forKey:@"currRound"];
    [keyedArchiver encodeObject:_pastRounds     forKey:@"pastRounds"];
    [keyedArchiver encodeObject:_currBow        forKey:@"currBow"];
    [keyedArchiver encodeObject:_allBows        forKey:@"allBows"];
    [keyedArchiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"archersEyeInfo"];
}



//------------------------------------------------------------------------------
// Clear the user data.
//------------------------------------------------------------------------------
- (void)clearData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"archersEyeInfo"];
}



//------------------------------------------------------------------------------
// Returns data in json format.
//------------------------------------------------------------------------------
- (NSData *)jsonData
{
    NSData          *json;
    NSMutableArray  *array = [NSMutableArray new];
    
    for( RoundInfo *pastRound in self.pastRounds )
    {
        [array addObject:[pastRound dictionary]];
    }
    
    json = [NSJSONSerialization dataWithJSONObject:array
                                           options:NSJSONWritingPrettyPrinted
                                             error:nil];

    
//    NSLog( @"%@", [[NSString alloc] initWithData:json encoding:NSASCIIStringEncoding] );
    
    return json;
}



















#pragma mark - Live Rounds

//------------------------------------------------------------------------------
// Create a live round from the given template.
//------------------------------------------------------------------------------
- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate
{
    if( _liveRound == nil )
    {
        [roundTemplate clearScorecard];
        self.liveRound      = roundTemplate;
        self.liveRound.date = [NSDate date];
    }
}



//------------------------------------------------------------------------------
// End the live round and discard.
//------------------------------------------------------------------------------
- (void)endLiveRoundAndDiscard
{
    // Release the old live round
    self.liveRound = nil;
}



//------------------------------------------------------------------------------
// End the live round and save.
//------------------------------------------------------------------------------
- (void)endLiveRoundAndSave
{
    if( _liveRound != nil )
    {
        // Add the current live round to the log of past scores
        [_pastRounds insertObject:_liveRound atIndex:0];
        
        // Release the old live round
        self.liveRound = nil;
    }
}





















#pragma mark - Generic Round Selection

//------------------------------------------------------------------------------
// Create a new custom round.
//------------------------------------------------------------------------------
- (void)createNewCustomRound:(RoundInfo *)newRound
{
    self.currRound      = newRound;
    _currRoundCategory  = eRoundCategory_Custom;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
// Select an already created round from the given category.
//------------------------------------------------------------------------------
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category
{
    NSMutableArray *roundArray;
    
    _currRoundCategory  = category;
    _currRoundID        = -1;
    
    // Select the array to use
    switch( _currRoundCategory )
    {
        case eRoundCategory_Custom: roundArray = _customRounds;     break;
        case eRoundCategory_Common: roundArray = _commonRounds;     break;
        case eRoundCategory_Past:   roundArray = _pastRounds;       break;
        default:                    roundArray = nil;               break;
    }
    
    if( ID >= 0  &&  ID < [roundArray count] )
    {
        self.currRound  = roundArray[ID];
        _currRoundID    = ID;      // Save the ID so we can replace it later
    }
}



//------------------------------------------------------------------------------
// End the current round and discard.
//------------------------------------------------------------------------------
- (void)endCurrRoundAndDiscard
{
    _currRoundCategory  = eRoundCategory_None;
    self.currRound      = nil;
    _currRoundID        = -1;
}



//------------------------------------------------------------------------------
// End the current round and save.
//------------------------------------------------------------------------------
- (void)endCurrRoundAndSave
{
    if( _currRoundCategory != eRoundCategory_None )
    {
        NSMutableArray *roundArray;
        
        // Select the array to use
        switch( _currRoundCategory )
        {
            case eRoundCategory_Custom: roundArray = _customRounds;     break;
            case eRoundCategory_Common: roundArray = _commonRounds;     break;
            case eRoundCategory_Past:   roundArray = _pastRounds;       break;
            default:                    roundArray = nil;               break;
        }
        
        if( _currRoundID >= 0  &&  _currRoundID < [roundArray count] )
            [roundArray replaceObjectAtIndex:_currRoundID withObject:_currRound];
        else
            [roundArray insertObject:_currRound atIndex:0];
    }
    [self endCurrRoundAndDiscard];
}




















#pragma mark - Bows

//------------------------------------------------------------------------------
// Create a new current bow.
//------------------------------------------------------------------------------
- (void)createNewCurrBow:(BowInfo *)newBow
{
    self.currBow     = newBow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Inventory;
}



//------------------------------------------------------------------------------
// Select an already created bow.
//------------------------------------------------------------------------------
- (void)selectBow:(NSInteger)bowID
{
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Inventory;
    
    if( bowID >= 0  &&  bowID < [_allBows count] )
    {
        // Make a copy so that we can discard the values easily if needed
        self.currBow = _allBows[bowID];
        _currBowID   = bowID;
    }
}



//------------------------------------------------------------------------------
// Select the bow from the live round.
//------------------------------------------------------------------------------
- (void)selectBowFromLiveRound
{
    self.currBow     = _liveRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Live;
}



//------------------------------------------------------------------------------
// Select the bow from the past round.
//------------------------------------------------------------------------------
- (void)selectBowFromPastRound
{
    self.currBow     = _currRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Past;
}



//------------------------------------------------------------------------------
// Save the current bow.
//------------------------------------------------------------------------------
- (void)saveCurrBow
{
    // Bow is from the live round
    if( _currBowCategory == eBowCategory_Live )
    {
        _liveRound.bow = _currBow;
    }
    // Bow is from a past round
    else if( _currBowCategory == eBowCategory_Past )
    {
        _currRound.bow = _currBow;
    }
    else if( _currBowCategory == eBowCategory_Inventory )
    {
        // Bow is brand new
        if( _currBowID == -1 )
        {
            [_allBows insertObject:_currBow atIndex:0];
        }
        // Bow is a copy of another one
        else
        {
            [_allBows replaceObjectAtIndex:_currBowID withObject:_currBow];
        }
    }
    [self discardCurrBow];
}



//------------------------------------------------------------------------------
// Discard the current bow.
//------------------------------------------------------------------------------
- (void)discardCurrBow
{
    self.currBow     = nil;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_None;
}




















#pragma mark - Arrays for graphs

//------------------------------------------------------------------------------
// Creates a 2D array of commonly used rounds.
//------------------------------------------------------------------------------
- (NSMutableArray *)arrayOfFavoritePastRounds
{
    NSMutableArray *favRounds       = [NSMutableArray new];
    NSMutableArray *templateRounds  = [NSMutableArray new];
    NSMutableArray *usedBows        = [self arrayOfUsedBows];
    
    // Build a mega array of common and custom rounds.  For each round, make one
    // for each bow used.
    for( RoundInfo *round in _customRounds )
    {
        for( BowInfo *bow in usedBows )
        {
            RoundInfo *newRound = [round copy];
            
            newRound.bow = bow;
            [templateRounds addObject:newRound];
        }
    }
    
    for( RoundInfo *round in _commonRounds )
    {
        for( BowInfo *bow in usedBows )
        {
            RoundInfo *newRound = [round copy];
            
            newRound.bow = bow;
            [templateRounds addObject:newRound];
        }
    }
    
    
    
    // Sort the past rounds into favRounds based on the type and bow type
    for( RoundInfo *templateRound in templateRounds )
    {
        NSMutableArray *newFav = [NSMutableArray new];
        
        for( RoundInfo *pastRound in _pastRounds )
        {
            if( [templateRound     isTypeOfRound:pastRound]  &&
                [templateRound.bow isTypeOfBow:pastRound.bow] )
                [newFav addObject:pastRound];
        }
        [favRounds addObject:newFav];
    }
    
    
    
    // Remove any rounds that are played less than x amount
    for( NSInteger i = 0; i < [favRounds count]; ++i )
    {
        NSMutableArray *favRound = favRounds[i];
        
//        if( [favRound count] > 0 )
//            NSLog( @"%@ / %@ - %ld", [favRound[0] name], [[favRound[0] bow] name], [favRound count] );
        
        if( [favRound count] < 2 )
        {
            [favRounds removeObject:favRound];
            --i;
        }
    }
    
    return favRounds;
}



//------------------------------------------------------------------------------
// Creates an array of bows used in a given set of rounds.
//------------------------------------------------------------------------------
- (NSMutableArray *)arrayOfUsedBows
{
    NSMutableArray *usedBows = [NSMutableArray new];
    
    // Parse through all past rounds and record each unique bow used.
    for( RoundInfo *pastRound in _pastRounds )
    {
        BOOL uniqueBow = YES;
        
        for( BowInfo *usedBow in usedBows )
        {
            if( [usedBow isTypeOfBow:pastRound.bow] )
            {
                uniqueBow = NO;
                break;
            }
        }
        
        if( uniqueBow )
            [usedBows addObject:pastRound.bow];
    }
    
    if( [usedBows count] == 0 )
        usedBows = nil;
    
    return usedBows;
}

@end
