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
        coinsLabel.anchorPoint = ccp(0.0f,0.5f);
        coinsLabel.color = ccc3(0, 0, 0);
        [self addChild:coinsLabel];
        
        
        CCLabelTTF *goBackToHomeLabel = [CCLabelTTF labelWithString:@"Back" fontName:@"NexaBold" fontSize:22];
//        [goBackToHome setFontName:@"Roboto-Light"];
//        [goBackToHome setFontSize:25];
//        goBackToHome.color = ccc3(0, 0, 0);
        goBackToHomeLabel.position = ccp(screenSize.width/2, 40);
//        [self addChild:goBackToHomeLabel z:7];
        
        CCMenuItemImage *goBackToHome = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"backSel.png" target:self selector:@selector(goHome)];
        goBackToHome.scale = 1.25f;
        
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
        
        CCMenuItemImage *BuyCash1Label = [CCMenuItemImage itemWithNormalImage:@"storebtn1.png" selectedImage:@"storebtn1-pressed.png" target:self selector:@selector(buyCash1)];
//        BuyCash1Label.scale = 0.5f;
        
        CCMenuItemImage *BuyCash2Label = [CCMenuItemImage itemWithNormalImage:@"storebtn2.png" selectedImage:@"storebtn2-pressed.png" target:self selector:@selector(buyCash2)];
//        BuyCash2Label.scale = 0.5f;
        
        
        CCMenuItemImage *BuyCash3Label = [CCMenuItemImage itemWithNormalImage:@"storebtn3.png" selectedImage:@"storebtn3-pressed.png" target:self selector:@selector(buyCash3)];
//        BuyCash3Label.scale = 0.5f;
        
        CCMenu *cashStoreMenu = [CCMenu menuWithItems:BuyCash1Label, BuyCash2Label, BuyCash3Label, nil];
        [cashStoreMenu alignItemsVerticallyWithPadding:10.f];
        cashStoreMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 20);
        [self addChild:cashStoreMenu];
        
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
        
        
        
//        [self scheduleUpdate];
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"LLS - Fang.wav" loop:YES];
        }
        
    }
    
    return self;
}


-(void) restore
{
    [MGWU testRestoreProducts:@[@"com.mgwu.blend.1000C", @"com.mgwu.blend.3000C", @"com.mgwu.blend.10000C"] withCallback:@selector(restoredProducts:) onTarget:self];
}

-(void) restoredProducts:(NSArray *) products
{
    if (products == nil) {
        [MGWU showMessage:@"There were no products to restore." withImage:nil]; // tell use why nothing interesting happened
    }
    
    if ([products isEqual: @[@"com.mgwu.blend.1000C", @"com.mgwu.blend.3000C", @"com.mgwu.blend.10000C"]])
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
    [MGWU buyProduct:@"com.mgwu.blend.1000c" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyCash2
{
    [MGWU buyProduct:@"com.mgwu.blend.3000c" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyCash3
{
    [MGWU buyProduct:@"com.mgwu.blend.10000c" withCallback:@selector(boughtProduct:) onTarget:self];
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
        [MGWU showMessage:@"10,000 Coins added! Consider this purchase successful." withImage:nil];
        [self updateString];
    }
}

-(void) boughtProduct:(NSString*) powerupToBuy
{
    NSLog(@"Something was Bought!");
//    [MGWU showMessage:@"Purchase Successful" withImage:nil];
    if ([powerupToBuy isEqualToString:@"com.mgwu.blend.1000c"] == true)
    {
        NSLog(@"1000 Coins added!");
        [self boughtCashMessage:1];
        coins += 1000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
        [self updateString];
    }
    
    if ([powerupToBuy isEqualToString:@"com.mgwu.blend.3000c"] == true)
    {
        NSLog(@"3000 Coins added!");
        [self boughtCashMessage:2];
        coins += 3000;
        NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
//        [[NSUserDefaults standardUserDefaults] setObject:boughtCoinVal forKey:@"sharedCoins"];
        [MGWU setObject:boughtCoinVal forKey:@"sharedCoins"];
        [self updateString];
        
    }
    
    if ([powerupToBuy isEqualToString:@"com.mgwu.blend.10000c"] == true)
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