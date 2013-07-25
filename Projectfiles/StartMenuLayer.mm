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
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"THE ELEMENTS" fontName:@"NexaBold" fontSize:36];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 140);
//        [self addChild:gameTitle];
        
        CCSprite *titleSprite = [CCSprite spriteWithFile:@"title_logo.png"];
        titleSprite.position = ccp(screenCenter.x, screenSize.height + 120);
        [self addChild:titleSprite z:1000];
        
        id dropdown = [CCMoveTo actionWithDuration:0.5f position:ccp(screenCenter.x, screenCenter.y + 110)];
        id jump = [CCJumpBy actionWithDuration:0.25f position:CGPointZero height:15 jumps:1];
        id repeatJump = [CCRepeat actionWithAction:jump times:1];
        [titleSprite runAction:[CCSequence actions:dropdown, repeatJump, nil]];
        
        
        CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"settings_gear.png" selectedImage:@"settings_gear.png" target:self selector:@selector(goToSettings)];
        CCMenu *settingsMenu = [CCMenu menuWithItems:settings, nil];
        [settingsMenu alignItemsHorizontally];
        settingsMenu.position = ccp(screenSize.width - 25, screenSize.height - 25);
        [self addChild:settingsMenu];
        
        
        
        CCMenuItemImage *playNow = [CCMenuItemImage itemWithNormalImage:@"playNowButton.png" selectedImage:@"playNowButtonSel.png" target:self selector:@selector(startGame)];
        playNow.scale = 1.5f;
//        [playNow setFontName:@"Roboto-Light"];
//        [playNow setFontSize:25];
//        playNow.color = ccc3(0, 0, 0);
        
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
        
        CCLabelTTF *aboutLabel = [CCLabelTTF labelWithString:@"About" fontName:@"NexaBold" fontSize:22];
//        [about setFontName:@"Roboto-Light"];
//        [about setFontSize:25];
//        about.color = ccc3(0, 0, 0);
        aboutLabel.position = ccp(screenCenter.x, screenCenter.y - 300);
        [self addChild:aboutLabel z:7];
        CCMenuItemFont *about = [CCMenuItemImage itemWithNormalImage:@"flatButton.png" selectedImage:@"flatButtonSel.png" target:self selector:@selector(about)];
        about.scale = 1.5f;
        
        
        CCLabelTTF *promoLabel = [CCLabelTTF labelWithString:@"More Games" fontName:@"NexaBold" fontSize:19];
        //        [about setFontName:@"Roboto-Light"];
        //        [about setFontSize:25];
        //        about.color = ccc3(0, 0, 0);
        promoLabel.position = ccp(screenCenter.x, screenCenter.y - 350);
        [self addChild:promoLabel z:7];
        
        
        CCMenuItemFont *crosspromo = [CCMenuItemImage itemWithNormalImage:@"flatButton.png" selectedImage:@"flatButtonSel.png" target:self selector:@selector(moreGames)];
        crosspromo.scale = 1.5f;
//        [crosspromo setFontName:@"Roboto-Light"];
//        [crosspromo setFontSize:25];
//        crosspromo.color = ccc3(0, 0, 0);
        
        CCMenu *startMenu = [CCMenu menuWithItems:playNow, about, crosspromo, nil];
        [startMenu alignItemsVertically];
        startMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 300);
        [self addChild:startMenu];
        
        
        id dropup = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width/2, screenSize.height/2 - 30)];
        id menujump = [CCJumpBy actionWithDuration:0.5f position:CGPointZero height:0 jumps:1];
        id repeatMenuJump = [CCRepeat actionWithAction:menujump times:1];
        [startMenu runAction:[CCSequence actions:dropup, repeatMenuJump, nil]];
        
        id dropup1 = [CCMoveTo actionWithDuration:0.5f position:ccp(screenCenter.x, 210)];
        [aboutLabel runAction:dropup1];
        
        id dropup2 = [CCMoveTo actionWithDuration:0.5f position:ccp(screenCenter.x, 160)];
        [promoLabel runAction:dropup2];

        
        CCSprite *background = [CCSprite spriteWithFile:@"skybgip5.png"];
        background.position = screenCenter;
        [self addChild:background z:-100];
        
        if ([MGWU isOpenGraphActive] == false) // toggle open graph on app startup
        {
            [MGWU toggleOpenGraph];
        }
        
    }
    return self;
}

-(void) goToSettings
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[SettingsLayer node]]];
}

-(void) startGame
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionZoomFlipAngular transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

-(void) gameStats
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) gameStore
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[StoreLayer node]]];
}

-(void) gameUpgrades
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[UpgradesLayer node]]];
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
