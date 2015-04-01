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
- (void)loadData
{
    NSData *saveData = [[NSUserDefaults standardUserDefaults] dataForKey:@"archersEyeInfo"];

    // No save data file; load the defaults
    if( saveData == nil )
    {
        NSLog( @"No save file found: loading defaults" );
        
        [self loadDefaults];
    }
    // Found save data file; load it
    else
    {
        NSLog( @"Found save file: loading" );

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
- (void)saveData
{
    NSLog( @"Saving data" );

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
- (void)clearData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"archersEyeInfo"];
}



















#pragma mark - Live Rounds

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
- (void)endLiveRoundAndDiscard
{
    // Release the old live round
    self.liveRound = nil;
}



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
- (void)createNewCustomRound:(RoundInfo *)newRound
{
    self.currRound      = newRound;
    _currRoundCategory  = eRoundCategory_Custom;
    _currRoundID        = -1;
}



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
- (void)endCurrRoundAndDiscard
{
    _currRoundCategory  = eRoundCategory_None;
    self.currRound      = nil;
    _currRoundID        = -1;
}



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
- (void)createNewCurrBow:(BowInfo *)newBow
{
    self.currBow     = newBow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Inventory;
}



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
- (void)selectBowFromLiveRound
{
    self.currBow     = _liveRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Live;
}



//------------------------------------------------------------------------------
- (void)selectBowFromPastRound
{
    self.currBow     = _currRound.bow;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_Past;
}



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
- (void)discardCurrBow
{
    self.currBow     = nil;
    _currBowID       = -1;
    _currBowCategory = eBowCategory_None;
}

@end
