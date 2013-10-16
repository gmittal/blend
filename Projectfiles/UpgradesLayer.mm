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
#import "SimpleAudioEngine.h"

@implementation UpgradesLayer

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            oniPad = true;
        }

        CCLabelBMFont *gameTitle;
        
        if (oniPad == true) {
            gameTitle = [CCLabelTTF labelWithString:@"UPGRADES" fontName:@"NexaBold" fontSize:72];
        } else {
            gameTitle = [CCLabelTTF labelWithString:@"UPGRADES" fontName:@"NexaBold" fontSize:36];
        }
        gameTitle.color = ccc3(0,0,0);
//        gameTitle.anchorPoint = ccp(0.0f,0.5f);
        gameTitle.position = ccp(screenSize.width/2, screenSize.height - 60);
        [self addChild:gameTitle];
        
        
        CCSprite *coinIcon = [CCSprite spriteWithFile:@"coin1.png"];
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
			coinIcon.position = ccp(40, screenSize.height - 40);
        } else {
			coinIcon.position = ccp(20, screenSize.height - 20);
        }
		//        coinIcon.scale = 1.25f;
        [self addChild:coinIcon z:1000];
        
        NSNumber *CoinNumber = [MGWU objectForKey:@"sharedCoins"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* startcoinStr = [numberFormatter stringForObjectValue:CoinNumber];
        
        coins = [CoinNumber intValue];
        CoinString = startcoinStr; //[[NSString alloc] initWithFormat:@"%i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"NexaBold" fontSize:18];
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"NexaBold" fontSize:44];
            coinsLabel.position = ccp(coinIcon.position.x + 43, coinIcon.position.y);
			
        } else {
            coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"NexaBold" fontSize:22];
            coinsLabel.position = ccp(coinIcon.position.x + 23, screenSize.height - 22);
        }
        coinsLabel.color = ccc3(0, 0, 0);
        coinsLabel.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:coinsLabel];
        
        
        numPower1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power1Status"];
        p1String = [[NSString alloc] initWithFormat:@"%i", numPower1];
        
        if (oniPad == true) {
            p1Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:40];
        } else {
            p1Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:20];
        }
        p1Label.position = ccp(screenSize.width/2 + 112, screenCenter.y + 80);
        p1Label.color = ccc3(0, 0, 0);
        [self addChild:p1Label];
        
        numPower2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power2Status"];
        p2String = [[NSString alloc] initWithFormat:@"%i", numPower2];
        if (oniPad == true) {
            p2Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:40];
        } else {
            p2Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:20];
        }
        p2Label.position = ccp(screenSize.width/2 + 112, screenCenter.y - 7);
        p2Label.color = ccc3(0, 0, 0);
        [self addChild:p2Label];
        
        numPower3 = [[NSUserDefaults standardUserDefaults] integerForKey:@"power3Status"];
        p3String = [[NSString alloc] initWithFormat:@"%i", numPower3];
        if (oniPad == true) {
            p3Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:40];
        } else {
            p3Label = [CCLabelTTF labelWithString:p1String fontName:@"NexaBold" fontSize:20];
        }
        p3Label.position = ccp(screenSize.width/2 + 112, screenCenter.y - 95);
        p3Label.color = ccc3(0, 0, 0);
        [self addChild:p3Label];
        
        if (oniPad == true) {
            p1Label.position = ccp(screenSize.width/2 + 222, screenCenter.y + 135);
            p2Label.position = ccp(screenSize.width/2 + 222, screenCenter.y - 30);
            p3Label.position = ccp(screenSize.width/2 + 222, screenCenter.y - 195);
        }
        
        CCLabelTTF *buyCashLabel = [CCLabelTTF labelWithString:@"Buy Cash" fontName:@"NexaBold" fontSize:20];
        buyCashLabel.position = ccp(screenCenter.x, 85);
//        [self addChild:buyCashLabel z:7];
        
        CCMenuItemImage *buyMoreCash = [CCMenuItemImage itemWithNormalImage:@"buyCash.png" selectedImage:@"buyCashSel.png" target:self selector:@selector(buyMoreCash)];
        buyMoreCash.scale = 1.25f;
//        [buyMoreCash setFontName:@"Roboto-Light"];
//        [buyMoreCash setFontSize:25];
//        buyMoreCash.color = ccc3(0, 0, 0);
        
        CCMenuItemImage *goBackToHome = [CCMenuItemImage itemWithNormalImage:@"playNow.png" selectedImage:@"playNowSel.png" target:self selector:@selector(playAgain)];
        goBackToHome.scale = 1.25f;
//        [goBackToHome setFontName:@"Roboto-Light"];
//        [goBackToHome setFontSize:25];
//        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:buyMoreCash, goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 70);
        
        if (oniPad == true) {
            goHomeMenu.position = ccp(screenSize.width/2, 120);
        }
        [self addChild:goHomeMenu];
        
        
        CCMenuItemImage *BuyC1 = [CCMenuItemImage itemWithNormalImage:@"upgradee.png" selectedImage:@"upgradeeSel.png" target:self selector:@selector(buyCash1)];
//        BuyC1.scaleX = 2.0f;
//        BuyC1.scaleY = 1.9f;
        
        CCMenuItemImage *BuyC2 = [CCMenuItemImage itemWithNormalImage:@"upgradep.png" selectedImage:@"upgradepSel.png" target:self selector:@selector(buyCash2)];
//        BuyC2.scaleX = 2.0f;
//        BuyC2.scaleY = 1.9f;
        
        
        CCMenuItemFont *BuyC3 = [CCMenuItemImage itemWithNormalImage:@"upgradem.png" selectedImage:@"upgrademSel.png" target:self selector:@selector(buyCash3)];
//        BuyC3.scaleX = 2.0f;
//        BuyC3.scaleY = 1.9f;
        
        CCMenu *bgcashStoreMenu = [CCMenu menuWithItems:BuyC1, BuyC2, BuyC3, nil];
        [bgcashStoreMenu alignItemsVerticallyWithPadding:10.f];
        bgcashStoreMenu.position = ccp(screenSize.width/2, screenSize.height/2 + 15);
        [self addChild:bgcashStoreMenu z:-1];
        
        CCMenuItemImage *BuyCash1Label = [CCMenuItemImage itemWithNormalImage:@"shield.png" selectedImage:@"shield.png" target:self selector:@selector(buyCash1)];
        BuyCash1Label.scale = 0.5f;
        
        CCMenuItemImage *BuyCash2Label = [CCMenuItemImage itemWithNormalImage:@"stop.png" selectedImage:@"stop.png" target:self selector:@selector(buyCash2)];
        BuyCash2Label.scale = 0.5f;
        
        
        CCMenuItemFont *BuyCash3Label = [CCMenuItemImage itemWithNormalImage:@"shock.png" selectedImage:@"shock.png" target:self selector:@selector(buyCash3)];
        BuyCash3Label.scale = 0.5f;
        
        CCLabelTTF *price1 = [CCLabelTTF labelWithString:@"1000 COINS" fontName:@"NexaBold" fontSize:18];
        price1.position = ccp(screenSize.width/2 + 50, screenSize.height/2 + 62);
        price1.color = ccc3(255, 255, 255);
//        [self addChild:price1];
        
        CCLabelTTF *price2 = [CCLabelTTF labelWithString:@"500 COINS" fontName:@"NexaBold" fontSize:18];
        price2.position = ccp(screenSize.width/2 + 50, screenSize.height/2);
        price2.color = ccc3(255, 255, 255);
//        [self addChild:price2];
        
        CCLabelTTF *price3 = [CCLabelTTF labelWithString:@"800 COINS" fontName:@"NexaBold" fontSize:18];
        price3.position = ccp(screenSize.width/2 + 50, screenSize.height/2 - 65);
        price3.color = ccc3(255, 255, 255);
//        [self addChild:price3];
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVerticallyWithPadding:10.f];
        cashStoreMenu.position = ccp(screenSize.width/2 - 40, screenSize.height/2);
//        [self addChild:cashStoreMenu];
        
        CCSprite *background;
        CCSprite *leaves;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024) {
            background = [CCSprite spriteWithFile:@"bg.png"];
            leaves = [CCSprite spriteWithFile:@"bg_leaves.png"];
        } else if ([[CCDirector sharedDirector] winSizeInPixels].height == 1136) {
            background = [CCSprite spriteWithFile:@"bg-568h.png"];
            leaves = [CCSprite spriteWithFile:@"bg_leaves-568h.png"];
        } else {
            background = [CCSprite spriteWithFile:@"bg.png"];
            leaves = [CCSprite spriteWithFile:@"bg_leaves.png"];
        }
        
        background.position = screenCenter;
        leaves.position = screenCenter;
        [self addChild:background z:-100];
        [self addChild:leaves z:-99];
        
        
        [self scheduleUpdate];
        
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"LLS - Fang.wav" loop:YES];
        }
        
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
            
//            [MGWU showMessage:@"1 Energy Shield Bought" withImage:nil];
            [self updateString];
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
            
//            [MGWU showMessage:@"1 Delay Drone Bought" withImage:nil];
            [self updateString];
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
            
//            [MGWU showMessage:@"1 Multiplier Boost Bought" withImage:nil];
            [self updateString];
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



-(void) updateString
{
    NSNumber *formattedCoins = [NSNumber numberWithInt:coins];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    NSString* coinStr = [numberFormatter stringForObjectValue:formattedCoins];
    CoinString = coinStr; //[[NSString alloc] initWithFormat:@"%i", coins];
    [coinsLabel setString:CoinString];
}


-(void) update:(ccTime)delta
{
//    CoinString = [[NSString alloc] initWithFormat:@"%i", coins];
//    [coinsLabel setString:CoinString];
    
    p1String = [[NSString alloc] initWithFormat:@"%i", numPower1];
    [p1Label setString:p1String];
    
    p2String = [[NSString alloc] initWithFormat:@"%i", numPower2];
    [p2Label setString:p2String];
    
    p3String = [[NSString alloc] initWithFormat:@"%i", numPower3];
    [p3Label setString:p3String];
}


@end
