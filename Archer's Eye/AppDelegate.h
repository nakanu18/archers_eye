//
//  AppDelegate.h
//  Archer's Eye
//
//  Created by Alex de Vera on 3/7/15.
//  Copyright (c) 2015 Alex de Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    RoundInfo      *_liveRound;
    NSMutableArray *_roundScores;
}

@property (nonatomic, strong) UIWindow          *window;
@property (strong)            RoundInfo         *liveRound;
@property (strong)            NSMutableArray    *roundScores;

- (void)startLiveRound;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

@end

