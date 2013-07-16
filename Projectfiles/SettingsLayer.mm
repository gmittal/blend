//
//  SettingsLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 7/8/13.
//
//

#import "SettingsLayer.h"

@implementation SettingsLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"SETTINGS" fontName:@"SpaceraLT-Regular" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenSize.height-30);
        [self addChild:gameTitle];
        
        
        
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
	 [CCTransitionSlideInL transitionWithDuration:0.5f scene:[StartMenuLayer node]]];
}

@end
