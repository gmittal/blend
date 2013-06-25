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
        glClearColor(0, 0, 0, 0);
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"Moon Landing" fontName:@"HelveticaNeue-UltraLight" fontSize:48];
        gameTitle.color = ccc3(255,255,255);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 60);
        [self addChild:gameTitle];
        
                                    
        CCMenuItemFont *playNow = [CCMenuItemFont itemFromString: @"Play Now" target:self selector:@selector(startGame)];
        CCMenu *startMenu = [CCMenu menuWithItems:playNow, nil];
        [startMenu alignItemsVertically];
        startMenu.position = ccp(screenSize.width/2, screenSize.height/2 + 10);
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


@end
