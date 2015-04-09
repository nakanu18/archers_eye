//
//  ArchersEyeInfo.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/31/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"
#import "RoundInfo.h"
#import "BowInfo.h"

#define SAVE_DATA_VERSION 0.8

typedef enum
{
    eRoundCategory_None,
    eRoundCategory_Custom,
    eRoundCategory_Past,
} eRoundCategory;

typedef enum
{
    eBowCategory_None,
    eBowCategory_Live,
    eBowCategory_Past,
    eBowCategory_Inventory,
} eBowCategory;

typedef enum
{
    eHint_BnA_NewLiveRound,
    eHint_BnA_PastRounds,
    eHint_BnA_Bows,
    eHint_Graphs_PointsBreakdown,
    eHint_Graphs_Progress,
    eHint_Count,
} eHint;

@interface ArchersEyeInfo : NSObject
{
    eBowCategory    _currBowCategory;
    NSInteger       _currBowID;

    eRoundCategory  _currRoundCategory;
    NSInteger       _currRoundID;
}

@property (nonatomic, readwrite) float            version;
@property (nonatomic, copy)      RoundInfo       *liveRound;
@property (nonatomic, strong)    NSMutableArray  *customRounds;
@property (nonatomic, copy)      RoundInfo       *currRound;
@property (nonatomic, strong)    NSMutableArray  *pastRounds;
@property (nonatomic, copy)      BowInfo         *currBow;
@property (nonatomic, strong)    NSMutableArray  *allBows;
@property (nonatomic, strong)    NSMutableArray  *showHints;





- (void)loadDefaults;
- (void)loadDataFromDevice;
- (void)loadDataFromJSONData:(NSData *)jsonData;
- (NSData *)jsonData;
- (NSMutableArray *)infosToDictionary:(NSMutableArray *)infos;
- (void)saveDataToDevice;
- (void)clearData;

- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

// Generic
- (void)createNewCustomRound:(RoundInfo *)newRound;
- (void)selectRound:(NSInteger)ID andCategory:(eRoundCategory)category;
- (void)selectRoundInfo:(RoundInfo *)info andCategory:(eRoundCategory)category;
- (void)endCurrRoundAndDiscard;
- (void)endCurrRoundAndSave;

- (void)createNewCurrBow:(BowInfo *)newBow;
- (void)selectBow:(NSInteger)bowID;
- (void)selectBowFromLiveRound;
- (void)selectBowFromPastRound;
- (void)saveCurrBow;
- (void)discardCurrBow;

- (void)sortRoundInfos:(NSMutableArray *)roundInfos byKey:(NSString *)key ascending:(BOOL)ascending;
- (NSMutableArray *)arrayOfFavoritePastRounds;
- (NSMutableArray *)arrayOfUsedRounds;
- (NSMutableArray *)arrayOfUsedBows;
- (NSMutableArray *)arrayOfCustomRoundsByFirstName;
- (NSMutableArray *)arrayOfPastRoundsByMonth;

- (void)resetAllHints;
- (void)setShowHint:(eHint)hint toBool:(BOOL)show;
- (BOOL)showHint:(eHint)hint;
- (void)showHintPopupIfNecessary:(eHint)hint;
- (NSString *)hintAsString:(eHint)hint;

@end

