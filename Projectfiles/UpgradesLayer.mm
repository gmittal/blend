//
//  UpgradesLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 7/2/13.
//
//

#import "UpgradesLayer.h"
#import "StartMenuLayer.h"
#import "StoreLayer.h"

@implementation UpgradesLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"UPGRADES" fontName:@"NexaBold" fontSize:36];
        gameTitle.color = ccc3(0,0,0);
//        gameTitle.anchorPoint = ccp(0.0f,0.5f);
        gameTitle.position = ccp(screenSize.width/2, screenSize.height - 60);
        [self addChild:gameTitle];
        
        
        CCSprite *coinIcon = [CCSprite spriteWithFile:@"coin.png"];
        coinIcon.position = ccp(15, screenSize.height - 20);
        [self addChild:coinIcon z:1000];
        
        NSNumber *CoinNumber = [MGWU objectForKey:@"sharedCoins"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        coins = [CoinNumber intValue];
        CoinString = [[NSString alloc] initWithFormat:@"%i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"NexaBold" fontSize:18];
        coinsLabel.position = ccp(coinIcon.position.x + 17, screenSize.height - 22);
        coinsLabel.color = ccc3(0, 0, 0);
        coinsLabel.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:coinsLabel];
        
        
        numPower1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power1Status"];
        p1String = [[NSString alloc] initWithFormat:@"%i", numPower1];
        p1Label = [CCLabelTTF labelWithString:p1String fontName:@"Roboto-Light" fontSize:20];
        p1Label.position = ccp(screenSize.width/2 - 100, screenCenter.y + 70);
        p1Label.color = ccc3(0, 0, 0);
        [self addChild:p1Label];
        
        numPower2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power2Status"];
        p2String = [[NSString alloc] initWithFormat:@"%i", numPower2];
        p2Label = [CCLabelTTF labelWithString:p2String fontName:@"Roboto-Light" fontSize:20];
        p2Label.position = ccp(screenSize.width/2 - 100, screenCenter.y);
        p2Label.color = ccc3(0, 0, 0);
        [self addChild:p2Label];
        
        numPower3 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power3Status"];
        p3String = [[NSString alloc] initWithFormat:@"%i", numPower3];
        p3Label = [CCLabelTTF labelWithString:p3String fontName:@"Roboto-Light" fontSize:20];
        p3Label.position = ccp(screenSize.width/2 - 100, screenCenter.y - 70);
        p3Label.color = ccc3(0, 0, 0);
        [self addChild:p3Label];
        
        
        CCLabelTTF *buyCashLabel = [CCLabelTTF labelWithString:@"Buy Cash" fontName:@"NexaBold" fontSize:20];
        buyCashLabel.position = ccp(screenCenter.x, 85);
        [self addChild:buyCashLabel z:7];
        
        CCMenuItemImage *buyMoreCash = [CCMenuItemImage itemWithNormalImage:@"flatButton.png" selectedImage:@"flatButtonSel.png" target:self selector:@selector(buyMoreCash)];
        buyMoreCash.scale = 1.5f;
//        [buyMoreCash setFontName:@"Roboto-Light"];
//        [buyMoreCash setFontSize:25];
//        buyMoreCash.color = ccc3(0, 0, 0);
        
        CCMenuItemImage *goBackToHome = [CCMenuItemImage itemWithNormalImage:@"playNowButton.png" selectedImage:@"playNowButtonSel.png" target:self selector:@selector(playAgain)];
        goBackToHome.scale = 1.5f;
//        [goBackToHome setFontName:@"Roboto-Light"];
//        [goBackToHome setFontSize:25];
//        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:buyMoreCash, goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 60);
        [self addChild:goHomeMenu];
        
        
        CCMenuItemImage *BuyCash1Label = [CCMenuItemImage itemWithNormalImage:@"shield.png" selectedImage:@"shield.png" target:self selector:@selector(buyCash1)];
        BuyCash1Label.scale = 0.5f;
        
        CCMenuItemImage *BuyCash2Label = [CCMenuItemImage itemWithNormalImage:@"stop.png" selectedImage:@"stop.png" target:self selector:@selector(buyCash2)];
        BuyCash2Label.scale = 0.5f;
        
        
        CCMenuItemFont *BuyCash3Label = [CCMenuItemImage itemWithNormalImage:@"shock.png" selectedImage:@"shock.png" target:self selector:@selector(buyCash3)];
        BuyCash3Label.scale = 0.5f;
        
        CCLabelTTF *price1 = [CCLabelTTF labelWithString:@"1000 Coins" fontName:@"Roboto-Light" fontSize:18];
        price1.position = ccp(screenSize.width/2 + 50, screenSize.height/2 + 70);
        price1.color = ccc3(0, 0, 0);
        [self addChild:price1];
        
        CCLabelTTF *price2 = [CCLabelTTF labelWithString:@"500 Coins" fontName:@"Roboto-Light" fontSize:18];
        price2.position = ccp(screenSize.width/2 + 50, screenSize.height/2);
        price2.color = ccc3(0, 0, 0);
        [self addChild:price2];
        
        CCLabelTTF *price3 = [CCLabelTTF labelWithString:@"800 Coins" fontName:@"Roboto-Light" fontSize:18];
        price3.position = ccp(screenSize.width/2 + 50, screenSize.height/2 - 70);
        price3.color = ccc3(0, 0, 0);
        [self addChild:price3];
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVerticallyWithPadding:10.f];
        cashStoreMenu.position = ccp(screenSize.width/2 - 40, screenSize.height/2);
        [self addChild:cashStoreMenu];
        
        CCSprite *background = [CCSprite spriteWithFile:@"skybgip5.png"];
        background.position = screenCenter;
        [self addChild:background z:-100];
        
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(void) buyCash1
{
    if (coins > 0) {
        if (coins >= 1000) {
            coins -= 1000;
            NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
            //        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
            [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
            
            numPower1 += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:numPower1 forKey:@"power1Status"];
            
            [MGWU showMessage:@"1 Energy Shield Bought" withImage:nil];
        }
    }
}

-(void) buyCash2
{
    if (coins > 0) {
        if (coins >= 500) {
            coins -= 500;
            NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
            //        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
            [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
            
            
            numPower2 += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:numPower2 forKey:@"power2Status"];
            
            [MGWU showMessage:@"1 Delay Drone Bought" withImage:nil];
        }
    }
}

-(void) buyCash3
{
    if (coins > 0) {
        
        if (coins >= 800) {
            
            coins -= 800;
            NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
            //        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
            [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
            
            
            numPower3 += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:numPower3 forKey:@"power3Status"];
            
            [MGWU showMessage:@"1 Multiplier Boost Bought" withImage:nil];
        }
    }
}



-(void) playAgain
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

-(void) buyMoreCash
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[StoreLayer node]]];
}


-(void) update:(ccTime)delta
{
    CoinString = [[NSString alloc] initWithFormat:@"%i", coins];
    [coinsLabel setString:CoinString];
    
    p1String = [[NSString alloc] initWithFormat:@"%i", numPower1];
    [p1Label setString:p1String];
    
    p2String = [[NSString alloc] initWithFormat:@"%i", numPower2];
    [p2Label setString:p2String];
    
    p3String = [[NSString alloc] initWithFormat:@"%i", numPower3];
    [p3Label setString:p3String];
}


@end
