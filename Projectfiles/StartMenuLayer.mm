//
//  StartMenuLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/25/13.
//
//

#import "StartMenuLayer.h"

@implementation StartMenuLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"ELEMENTS" fontName:@"SpaceraLT-Regular" fontSize:30];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 130);
        [self addChild:gameTitle];
        
        
        CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"settings_gear.png" selectedImage:@"settings_gear.png" target:self selector:@selector(goToSettings)];
        CCMenu *settingsMenu = [CCMenu menuWithItems:settings, nil];
        [settingsMenu alignItemsHorizontally];
        settingsMenu.position = ccp(screenSize.width - 25, screenSize.height - 25);
        [self addChild:settingsMenu];
        
        CCMenuItemFont *playNow = [CCMenuItemFont itemFromString: @"Play Now" target:self selector:@selector(startGame)];
        [playNow setFontName:@"Roboto-Light"];
        [playNow setFontSize:25];
        playNow.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *statsNow = [CCMenuItemFont itemFromString: @"Leaderboards" target:self selector:@selector(gameStats)];
        [statsNow setFontName:@"Roboto-Light"];
        [statsNow setFontSize:25];
        statsNow.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *upgrades = [CCMenuItemFont itemFromString: @"Upgrades" target:self selector:@selector(gameUpgrades)];
        [upgrades setFontName:@"Roboto-Light"];
        [upgrades setFontSize:25];
        upgrades.color = ccc3(0, 0, 0);
        
        
        CCMenuItemFont *store = [CCMenuItemFont itemFromString: @"Store" target:self selector:@selector(gameStore)];
        [store setFontName:@"Roboto-Light"];
        [store setFontSize:25];
        store.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *about = [CCMenuItemFont itemFromString: @"About" target:self selector:@selector(about)];
        [about setFontName:@"Roboto-Light"];
        [about setFontSize:25];
        about.color = ccc3(0, 0, 0);

        
        CCMenuItemFont *crosspromo = [CCMenuItemFont itemFromString: @"More Games" target:self selector:@selector(moreGames)];
        [crosspromo setFontName:@"Roboto-Light"];
        [crosspromo setFontSize:25];
        crosspromo.color = ccc3(0, 0, 0);
        
        CCMenu *startMenu = [CCMenu menuWithItems:playNow, statsNow, upgrades, store, about, crosspromo, nil];
        [startMenu alignItemsVertically];
        startMenu.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:startMenu];
    }
    return self;
}

-(void) goToSettings
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[SettingsLayer node]]];
}

-(void) startGame
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

-(void) gameStats
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) gameStore
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[StoreLayer node]]];
}

-(void) gameUpgrades
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[UpgradesLayer node]]];
}

-(void) about
{
    [MGWU displayAboutPage];
}

-(void) moreGames
{
//    [[CCDirector sharedDirector] replaceScene:
//	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[StoreLayer node]]];
    [MGWU displayCrossPromo];
}

@end
