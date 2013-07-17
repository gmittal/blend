//
//  StoreLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/28/13.
//
//

#import "StoreLayer.h"

@implementation StoreLayer

int numPowerUp1;
int numPowerUp2;

int coins;
NSString *CoinString;
CCLabelBMFont *coinsLabel;

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"STORE" fontName:@"SpaceraLT-Regular" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenSize.height-30);
        [self addChild:gameTitle];

        NSNumber *CoinNumber = [MGWU objectForKey:@"sharedCoins"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        coins = [CoinNumber intValue];
        CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"Roboto-Light" fontSize:20];
        coinsLabel.position = ccp(screenSize.width/2, screenSize.height - 60);
        coinsLabel.color = ccc3(0, 0, 0);
        [self addChild:coinsLabel];
        
        
        CCMenuItemFont *goBackToHome = [CCMenuItemFont itemFromString: @"Back to Menu" target:self selector:@selector(goHome)];
        [goBackToHome setFontName:@"Roboto-Light"];
        [goBackToHome setFontSize:25];
        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 40);
        [self addChild:goHomeMenu];
        
        
        CCMenuItemImage *BuyCash1Label = [CCMenuItemImage itemWithNormalImage:@"buy1.png" selectedImage:@"buy1.png" target:self selector:@selector(buyCash1)];
        BuyCash1Label.scale = 0.5f;
        
        CCMenuItemImage *BuyCash2Label = [CCMenuItemImage itemWithNormalImage:@"buy2.png" selectedImage:@"buy2.png" target:self selector:@selector(buyCash2)];
        BuyCash2Label.scale = 0.5f;
        
        
        CCMenuItemFont *BuyCash3Label = [CCMenuItemImage itemWithNormalImage:@"buy3.png" selectedImage:@"buy3.png" target:self selector:@selector(buyCash3)];
        BuyCash3Label.scale = 0.5f;
        
        CCLabelTTF *price1 = [CCLabelTTF labelWithString:@"0.99" fontName:@"Roboto-Light" fontSize:18];
        price1.position = ccp(screenSize.width/2 + 50, screenSize.height/2 + 100);
        price1.color = ccc3(0, 0, 0);
        [self addChild:price1];

        CCLabelTTF *price2 = [CCLabelTTF labelWithString:@"1.99" fontName:@"Roboto-Light" fontSize:18];
        price2.position = ccp(screenSize.width/2 + 50, screenSize.height/2);
        price2.color = ccc3(0, 0, 0);
        [self addChild:price2];
        
        CCLabelTTF *price3 = [CCLabelTTF labelWithString:@"4.99" fontName:@"Roboto-Light" fontSize:18];
        price3.position = ccp(screenSize.width/2 + 50, screenSize.height/2 - 100);
        price3.color = ccc3(0, 0, 0);
        [self addChild:price3];
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVerticallyWithPadding:10.f];
        cashStoreMenu.position = ccp(screenSize.width/2 - 50, screenSize.height/2);
        [self addChild:cashStoreMenu];
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(void) buyCash1
{
    [MGWU testBuyProduct:@"com.gbm.mlg.1000C" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyCash2
{
    [MGWU testBuyProduct:@"com.gbm.mlg.3000C" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyCash3
{
    [MGWU testBuyProduct:@"com.gbm.mlg.10000C" withCallback:@selector(boughtProduct:) onTarget:self];
}


-(void) boughtCashMessage:(int) numProduct
{
    if (numProduct == 1) {
        [MGWU showMessage:@"1000 Coins added! Consider this purchase successful." withImage:nil];
    }
    
    if (numProduct == 2) {
        [MGWU showMessage:@"3000 Coins added! Consider this purchase successful." withImage:nil];
    }
    
    if (numProduct == 3) {
        [MGWU showMessage:@"5000 Coins added! Consider this purchase successful." withImage:nil];
    }
}

-(void) boughtProduct:(NSString*) powerupToBuy
{
    NSLog(@"Something was Bought!");
//    [MGWU showMessage:@"Purchase Successful" withImage:nil];
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.1000C"] == true)
    {
        NSLog(@"1000 Coins added!");
        [self boughtCashMessage:1];
        coins += 1000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.3000C"] == true)
    {
        NSLog(@"3000 Coins added!");
        [self boughtCashMessage:2];
        coins += 3000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
        
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.10000C"] == true)
    {
        NSLog(@"10000 Coins added!");
        [self boughtCashMessage:3];
        coins += 10000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
    }
    
}


-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[StartMenuLayer node]]];
}


-(void) update:(ccTime)delta
{
    CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
    [coinsLabel setString:CoinString];
}


@end