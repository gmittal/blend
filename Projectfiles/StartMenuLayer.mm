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
        glClearColor(255, 255, 255, 255);
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"dOck SHIPS" fontName:@"SpaceraLT-Regular" fontSize:30];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 50);
        [self addChild:gameTitle];
        
                                    
        CCMenuItemFont *playNow = [CCMenuItemFont itemFromString: @"Play Now" target:self selector:@selector(startGame)];
        [playNow setFontName:@"Roboto-Light"];
        [playNow setFontSize:25];
        playNow.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *statsNow = [CCMenuItemFont itemFromString: @"Stats" target:self selector:@selector(gameStats)];
        [statsNow setFontName:@"Roboto-Light"];
        [statsNow setFontSize:25];
        statsNow.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *store = [CCMenuItemFont itemFromString: @"Store" target:self selector:@selector(gameStore)];
        [store setFontName:@"Roboto-Light"];
        [store setFontSize:25];
        store.color = ccc3(0, 0, 0);
        
        CCMenu *startMenu = [CCMenu menuWithItems:playNow, statsNow, store, nil];
        [startMenu alignItemsVertically];
        startMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 20);
        [self addChild:startMenu];
    }
    return self;
}

-(void) startGame
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

-(void) gameStats
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) gameStore
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[StoreLayer node]]];
}

@end
