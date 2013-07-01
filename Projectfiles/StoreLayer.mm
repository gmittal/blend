//
//  StoreLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/28/13.
//
//

#import "StoreLayer.h"

@implementation StoreLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(255, 255, 255, 255);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"STORE" fontName:@"SpaceraLT-Regular" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 210);
        [self addChild:gameTitle];

        
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
