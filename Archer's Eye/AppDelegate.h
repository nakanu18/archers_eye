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
    NSMutableArray *_roundTemplates;
    
    RoundInfo      *_liveRound;
    NSMutableArray *_pastRounds;
}

@property (nonatomic, strong) UIWindow          *window;
@property (strong)            RoundInfo         *liveRound;
@property (strong)            NSMutableArray    *roundTemplates;
@property (strong)            NSMutableArray    *pastRounds;

- (void)startLiveRoundFromTemplate:(RoundInfo *)roundTemplate;
- (void)endLiveRoundAndDiscard;
- (void)endLiveRoundAndSave;

@end

