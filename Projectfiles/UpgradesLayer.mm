//
//  UpgradesLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 7/2/13.
//
//

#import "UpgradesLayer.h"
#import "StartMenuLayer.h"

@implementation UpgradesLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(255, 255, 255, 255);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"UPGRADES" fontName:@"SpaceraLT-Regular" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 210);
        [self addChild:gameTitle];
        
        NSNumber *CoinNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        coins = [CoinNumber intValue];
        CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"Roboto-Light" fontSize:20];
        coinsLabel.position = ccp(screenSize.width/2, screenSize.height - 60);
        coinsLabel.color = ccc3(0, 0, 0);
        [self addChild:coinsLabel];
        
        CCMenuItemFont *powerup1 = [CCMenuItemFont itemFromString: @"Slow Motion Power - 100 Coins" target:self selector:@selector(powerup1)];
        [powerup1 setFontName:@"Roboto-Light"];
        [powerup1 setFontSize:25];
        powerup1.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *powerup2 = [CCMenuItemFont itemFromString: @"Slow Motion Power - 100 Coins" target:self selector:@selector(powerup2)];
        [powerup2 setFontName:@"Roboto-Light"];
        [powerup2 setFontSize:25];
        powerup2.color = ccc3(0, 0, 0);
        
        
        NSNumber *savedHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
        int highScore = [savedHighScore intValue];
        NSString *highScoreString = [[NSString alloc] initWithFormat:@"High Score: %i", highScore];
        CCLabelBMFont *highScoreLabel = [CCLabelTTF labelWithString:highScoreString fontName:@"Roboto-Light" fontSize:20];
        highScoreLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        highScoreLabel.color = ccc3(0, 0, 0);
        //        [self addChild:highScoreLabel];
        
        
        NSNumber *lastRoundScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedScore"];
        int lastRoundPlayedScore = [lastRoundScore intValue];
        NSString *lastRoundString = [[NSString alloc]initWithFormat:@"Last Round: %i", lastRoundPlayedScore];
        CCLabelBMFont *lastRoundPlayed = [CCLabelTTF labelWithString:lastRoundString fontName:@"Roboto-Light" fontSize:20];
        lastRoundPlayed.position = ccp(screenSize.width/2, screenSize.height/2 - 40);
        lastRoundPlayed.color = ccc3(0, 0, 0);
        //        [self addChild:lastRoundPlayed];
        
        //        [MGWU submitHighScore:highScore byPlayer:@"gmittal" forLeaderboard:@"defaultLeaderboard"];
        
//        NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//        [MGWU submitHighScore:highScore byPlayer:savedUser forLeaderboard:@"defaultLeaderboard"];
        
        //        [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:)
        //                                 onTarget:self];
        
        
        CCMenuItemFont *goBackToHome = [CCMenuItemFont itemFromString: @"Back to Menu" target:self selector:@selector(goHome)];
        [goBackToHome setFontName:@"Roboto-Light"];
        [goBackToHome setFontSize:25];
        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 40);
        [self addChild:goHomeMenu];
        
    }
    return self;
}

-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[StartMenuLayer node]]];
}

@end
