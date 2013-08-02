//
//  StoreLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/28/13.
//
//

#import "StoreLayer.h"
#import "SimpleAudioEngine.h"

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
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"STORE" fontName:@"NexaBold" fontSize:36];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenSize.height-60);
        [self addChild:gameTitle];

        
        CCSprite *coinIcon = [CCSprite spriteWithFile:@"coin.png"];
        coinIcon.position = ccp(15, screenSize.height - 20);
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
        coinsLabel.position = ccp(coinIcon.position.x + 17, screenSize.height - 22);
        coinsLabel.anchorPoint = ccp(0.0f,0.5f);
        coinsLabel.color = ccc3(0, 0, 0);
        [self addChild:coinsLabel];
        
        
        CCLabelTTF *goBackToHomeLabel = [CCLabelTTF labelWithString:@"Back" fontName:@"NexaBold" fontSize:22];
//        [goBackToHome setFontName:@"Roboto-Light"];
//        [goBackToHome setFontSize:25];
//        goBackToHome.color = ccc3(0, 0, 0);
        goBackToHomeLabel.position = ccp(screenSize.width/2, 40);
        [self addChild:goBackToHomeLabel z:7];
        
        CCMenuItemImage *goBackToHome = [CCMenuItemImage itemWithNormalImage:@"flatButton.png" selectedImage:@"flatButtonSel.png" target:self selector:@selector(goHome)];
        goBackToHome.scale = 1.5f;
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 40);
        [self addChild:goHomeMenu];
        
        
        
//        CCMenuItemFont *restore = [CCMenuItemFont itemWithString:@"Restore Products" target:self selector:@selector(restore)];
//        [restore setFontName:@"Roboto-Light"];
//        [restore setFontSize:20];
//        restore.color = ccc3(255, 0, 0);
//
//        CCMenu *restoreMenu = [CCMenu menuWithItems:restore, nil];
//        [restoreMenu alignItemsVertically];
//        restoreMenu.position = ccp(screenCenter.x, screenSize.height - 85);
//        [self addChild:restoreMenu z:1000];
        
        CCMenuItemImage *BuyCash1Label = [CCMenuItemImage itemWithNormalImage:@"buy1.png" selectedImage:@"buy1.png" target:self selector:@selector(buyCash1)];
        BuyCash1Label.scale = 0.5f;
        
        CCMenuItemImage *BuyCash2Label = [CCMenuItemImage itemWithNormalImage:@"buy2.png" selectedImage:@"buy2.png" target:self selector:@selector(buyCash2)];
        BuyCash2Label.scale = 0.5f;
        
        
        CCMenuItemImage *BuyCash3Label = [CCMenuItemImage itemWithNormalImage:@"buy3.png" selectedImage:@"buy3.png" target:self selector:@selector(buyCash3)];
        BuyCash3Label.scale = 0.5f;
        
        CCLabelTTF *price1 = [CCLabelTTF labelWithString:@"0.99" fontName:@"Roboto-Light" fontSize:18];
        price1.position = ccp(screenSize.width/2 + 50, screenSize.height/2 + 80);
        price1.color = ccc3(0, 0, 0);
        [self addChild:price1];

        CCLabelTTF *price2 = [CCLabelTTF labelWithString:@"1.99" fontName:@"Roboto-Light" fontSize:18];
        price2.position = ccp(screenSize.width/2 + 50, screenSize.height/2 - 20);
        price2.color = ccc3(0, 0, 0);
        [self addChild:price2];
        
        CCLabelTTF *price3 = [CCLabelTTF labelWithString:@"4.99" fontName:@"Roboto-Light" fontSize:18];
        price3.position = ccp(screenSize.width/2 + 50, screenSize.height/2 - 120);
        price3.color = ccc3(0, 0, 0);
        [self addChild:price3];
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVerticallyWithPadding:10.f];
        cashStoreMenu.position = ccp(screenSize.width/2 - 50, screenSize.height/2 - 20);
        [self addChild:cashStoreMenu];
        
        CCSprite *background;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024) {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        } else {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        }
        
        background.position = screenCenter;
        [self addChild:background z:-100];
        
        
        
//        [self scheduleUpdate];
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"dpgl_bg.mp3" loop:YES];
        }
        
    }
    
    return self;
}


-(void) restore
{
    [MGWU testRestoreProducts:@[@"com.gbm.mlg.1000C", @"com.gbm.mlg.3000C", @"com.gbm.mlg.10000C"] withCallback:@selector(restoredProducts:) onTarget:self];
}

-(void) restoredProducts:(NSArray *) products
{
    if (products == nil) {
        [MGWU showMessage:@"There were no products to restore." withImage:nil]; // tell use why nothing interesting happened
    }
    
    if ([products isEqual: @[@"com.gbm.mlg.1000C", @"com.gbm.mlg.3000C", @"com.gbm.mlg.10000C"]])
    {
        coins += 20000; // arbitrary at the moment
        NSNumber *restoredCoinValue = [NSNumber numberWithInt:coins];
        [MGWU setObject:restoredCoinValue forKey:@"sharedCoins"];
        [MGWU showMessage:@"Products restored." withImage:nil];
        [self updateString];
    }
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
        [self updateString];
    }
    
    if (numProduct == 2) {
        [MGWU showMessage:@"3000 Coins added! Consider this purchase successful." withImage:nil];
        [self updateString];
    }
    
    if (numProduct == 3) {
        [MGWU showMessage:@"5000 Coins added! Consider this purchase successful." withImage:nil];
        [self updateString];
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
        [self updateString];
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.3000C"] == true)
    {
        NSLog(@"3000 Coins added!");
        [self boughtCashMessage:2];
        coins += 3000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
        [self updateString];
        
    }
    
    if ([powerupToBuy isEqualToString:@"com.gbm.mlg.10000C"] == true)
    {
        NSLog(@"10000 Coins added!");
        [self boughtCashMessage:3];
        coins += 10000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
        [self updateString];
    }
    
}


-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[UpgradesLayer node]]];
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




@end