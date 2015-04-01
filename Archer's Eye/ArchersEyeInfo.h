//
//  ArchersEyeInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/31/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoundInfo.h"
#import "BowInfo.h"

typedef enum
{
    eRoundCategory_None,
    eRoundCategory_Custom,
    eRoundCategory_Common,
    eRoundCategory_Past,
} eRoundCategory;

typedef enum
{
    eBowCategory_None,
    eBowCategory_Live,
    eBowCategory_Past,
    eBowCategory_Inventory,
} eBowCategory;

@interface ArchersEyeInfo : NSObject
{
    eBowCategory    _currBowCategory;
    NSInteger       _currBowID;

    eRoundCategory  _currRoundCategory;
    NSInteger       _currRoundID;
}

@property (nonatomic, copy)     RoundInfo       *liveRound;
@property (nonatomic, strong)   NSMutableArray  *customRounds;
@property (nonatomic, strong)   NSMutableArray  *commonRounds;
@property (nonatomic, copy)     RoundInfo       *currRound;
@property (nonatomic, strong)   NSMutableArray  *pastRounds;
@property (nonatomic, copy)     BowInfo         *currBow;
@property (nonatomic, strong)   NSMutableArray  *allBows;





- (void)loadDefaults;
- (void)loadData;
- (void)saveData;
- (void)clearData;

- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

// Generic
- (void)createNewCustomRound:(RoundInfo *)newRound;
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category;
- (void)endCurrRoundAndDiscard;
- (void)endCurrRoundAndSave;

- (void)createNewCurrBow:(BowInfo *)newBow;
- (void)selectBow:(NSInteger)bowID;
- (void)selectBowFromLiveRound;
- (void)selectBowFromPastRound;
- (void)saveCurrBow;
- (void)discardCurrBow;

@end

