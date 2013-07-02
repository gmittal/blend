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
        glClearColor(255, 255, 255, 255);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"STORE" fontName:@"SpaceraLT-Regular" fontSize:28];
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
        
        
        CCMenuItemFont *goBackToHome = [CCMenuItemFont itemFromString: @"Back to Menu" target:self selector:@selector(goHome)];
        [goBackToHome setFontName:@"Roboto-Light"];
        [goBackToHome setFontSize:25];
        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 40);
        [self addChild:goHomeMenu];
        
        
        CCMenuItemFont *BuyCash1Label = [CCMenuItemFont itemFromString: @"1000 COINS - $0.99" target:self selector:@selector(buyCash1)];
        [BuyCash1Label setFontName:@"Roboto-Light"];
        [BuyCash1Label setFontSize:20];
        BuyCash1Label.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *BuyCash2Label = [CCMenuItemFont itemFromString: @"3000 COINS - $1.99" target:self selector:@selector(buyCash2)];
        [BuyCash2Label setFontName:@"Roboto-Light"];
        [BuyCash2Label setFontSize:20];
        BuyCash2Label.color = ccc3(0, 0, 0);
        
        CCMenuItemFont *BuyCash3Label = [CCMenuItemFont itemFromString: @"10000 COINS - $4.99" target:self selector:@selector(buyCash3)];
        [BuyCash3Label setFontName:@"Roboto-Light"];
        [BuyCash3Label setFontSize:20];
        BuyCash3Label.color = ccc3(0, 0, 0);
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVertically];
        cashStoreMenu.position = ccp(screenSize.width/2, screenSize.height - 150);
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


-(void) boughtProduct:(NSString*) powerupToBuy
{
    NSLog(@"Something was Bought!");
    [MGWU showMessage:@"Purchase Successful" withImage:nil];
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.1000C"] == true)
    {
        NSLog(@"1000 Coins added!");
        coins += 1000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.3000C"] == true)
    {
        NSLog(@"3000 Coins added!");
        coins += 3000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.10000C"] == true)
    {
        NSLog(@"10000 Coins added!");
        coins += 10000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
    }
    
}


-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFlipX transitionWithDuration:0.5f scene:[StartMenuLayer node]]];
}


-(void) update:(ccTime)delta
{
    CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
    [coinsLabel setString:CoinString];
}


@end