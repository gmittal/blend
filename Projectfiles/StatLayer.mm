//
//  StatLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/27/13.
//
//

#import "StatLayer.h"
#import "SimpleAudioEngine.h"

@implementation StatLayer

CGSize screenSize;

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0.0, 0.75, 1.0, 1.0);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle;
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            gameTitle = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:@"NexaBold" fontSize:70];
        } else {
            gameTitle = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:@"NexaBold" fontSize:36];
        }
        gameTitle.color = ccc3(0,0,0);
        
        gameTitle.position = ccp(screenCenter.x, screenSize.height-30);
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
//            gameTitle = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:@"NexaBold" fontSize:70];
            gameTitle.position = ccp(screenCenter.x, screenSize.height-40);
        }
        [self addChild:gameTitle];
        
        
        NSNumber *savedHighScore = [MGWU objectForKey:@"sharedHighScore"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
        int highScore = [savedHighScore intValue];
        NSString *highScoreString = [[NSString alloc] initWithFormat:@"High Score: %i", highScore];
        CCLabelBMFont *highScoreLabel = [CCLabelTTF labelWithString:highScoreString fontName:@"Roboto-Light" fontSize:20];
        highScoreLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        highScoreLabel.color = ccc3(0, 0, 0);
        //        [self addChild:highScoreLabel];
        
        
        NSNumber *lastRoundScore = [MGWU objectForKey:@"sharedScore"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedScore"];
        int lastRoundPlayedScore = [lastRoundScore intValue];
        NSString *lastRoundString = [[NSString alloc]initWithFormat:@"Last Round: %i", lastRoundPlayedScore];
        CCLabelBMFont *lastRoundPlayed = [CCLabelTTF labelWithString:lastRoundString fontName:@"Roboto-Light" fontSize:20];
        lastRoundPlayed.position = ccp(screenSize.width/2, screenSize.height/2 - 40);
        lastRoundPlayed.color = ccc3(0, 0, 0);
        //        [self addChild:lastRoundPlayed];
        
        //        [MGWU submitHighScore:highScore byPlayer:@"gmittal" forLeaderboard:@"defaultLeaderboard"];
        
        NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        
        //        [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:)
        //                                 onTarget:self];
        
        [self getScores];
        
        CCLabelTTF *goBackLabel = [CCLabelTTF labelWithString:@"Back" fontName:@"NexaBold" fontSize:22];
        goBackLabel.position = ccp(screenSize.width/2, 40);
        [self addChild:goBackLabel z:7];
        CCMenuItemImage *goBackToHome = [CCMenuItemImage itemWithNormalImage:@"flatButton.png" selectedImage:@"flatButtonSel.png" target:self selector:@selector(goHome)];
        goBackToHome.scale = 1.5f;
//        [goBackToHome setFontName:@"Roboto-Light"];
//        [goBackToHome setFontSize:25];
//        goBackToHome.color = ccc3(0, 0, 0);
        
        CCMenu *goHomeMenu = [CCMenu menuWithItems:goBackToHome, nil];
        [goHomeMenu alignItemsVertically];
        goHomeMenu.position = ccp(screenSize.width/2, 40);
        [self addChild:goHomeMenu];
        
        
        CCSprite *background;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024) {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        } else {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        }
        
        background.position = screenCenter;
        [self addChild:background z:-100];
        
        
        
        CCMenuItemImage *facebookSel = [CCMenuItemImage itemWithNormalImage:@"facebookHighscoreButton.png" selectedImage:@"facebookHighscoreButtonSel.png" target:self selector:@selector(displayFacebookStats)];
        //        facebookSel.position = ccp(screenSize.width/2 + ([facebookSel boundingBox].size.width/2), screenSize.height - 85);
        //        [self addChild:facebookSel];
        
        CCMenuItemImage *globalSel = [CCMenuItemImage itemWithNormalImage:@"globalHighscoreButton.png" selectedImage:@"globalHighscoreButtonSel.png" target:self selector:@selector(displayGlobalStats)];
        //        globalSel.position = ccp(screenSize.width/2 - ([globalSel boundingBox].size.width/2), screenSize.height - 85);
        //        [self addChild:globalSel];
        
        CCMenu *boardChoice = [CCMenu menuWithItems:globalSel, facebookSel, nil];
        [boardChoice alignItemsHorizontallyWithPadding:0.0f];
        boardChoice.position = ccp(screenSize.width/2, screenSize.height - 85);
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            //            gameTitle = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:@"NexaBold" fontSize:70];
            boardChoice.position = ccp(screenSize.width/2, screenSize.height - 100);
        }
        
        [self addChild:boardChoice];
        
        global1 = false;
        fb1 = true;
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
//            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"dpgl_bg.mp3" loop:YES];
        }
        
        
    }
    return self;
}

-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[GameOver node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

-(void) getScores
{
    [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:)
                             onTarget:self];
}

-(void)receivedScores:(NSDictionary*)scores
{
    //Do stuff with scores in here! Display them!
    //    NSString *leaderBoardString = [[NSString alloc] initWithFormat:@"%@", scores];
    //    CCLabelBMFont *leaderBoard = [CCLabelTTF labelWithString:leaderBoardString fontName:@"Roboto-Light" fontSize:15];
    //    leaderBoard.position = ccp(screenSize.width/2, screenSize.height/2);
    //    [self addChild:leaderBoard];
    //    NSLog(@"%@", scores);
    
    //    NSString *object = [[NSString alloc]initWithFormat:
    
    //    for(NSString *key in [scores allKeys]) {
    //        NSLog(@"%@",[scores objectForKey:key]);
    //        NSString *rankStr = [scores objectForKey:@"score"];
    //        NSString *rank = [NSString stringWithFormat: @"%@", [scores objectForKey:@"all"]];
    //        CCLabelBMFont *rankLabel = [CCLabelTTF labelWithString:rank fontName:@"Roboto-Light" fontSize:20];
    //        rankLabel.position = ccp(screenSize.width/2, screenSize.height/2);
    //        rankLabel.color = ccc3(0,0,0);
    //        [self addChild:rankLabel];
    
    //    }
    
    //    NSDictionary *userDict = [scores objectForKey:@"user"];
    //    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //	if (!userName)
    //		userName = @"player";
    //    NSNumber *userHighScore = [userDict objectForKey:@"score"];
    //    NSNumber *userRank = [userDict objectForKey:@"rank"];
    //
    //    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your name: %@, Most Kills: %@, Rank: %@", userName, userHighScore, userRank]
    //                                           fontName:@"Marker Felt"
    //                                           fontSize:16];
    
    //    label.position = ccp(screenSize.width / 2, screenSize.height-15);
    //    [self addChild:label z: 2];
    
    scoreDict = scores;
    
    facebookInfo = [scores objectForKey:@"friends"];
    
    userInfo = [scores objectForKey:@"user"];
    playerName = [userInfo objectForKey:@"name"];
    if (!playerName) {
        playerName = @"Player";
    }
    
    if (playerName.length > 12) {
        playerName = [[playerName substringToIndex:13] stringByAppendingString:@"..."];
    }
    
    playerHighScore = [userInfo objectForKey:@"score"];
    playerRank = [userInfo objectForKey:@"rank"];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    NSString* commaPlayerScore = [numberFormatter stringForObjectValue:playerHighScore];
    
    if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
        //            gameTitle = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:@"NexaBold" fontSize:70];
        userStatus = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Rank: %@) %@", playerRank, playerName]
                                        fontName:@"Roboto-Light"
                                        fontSize:30];
        
        userscoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:30];
        
        userStatus.anchorPoint = ccp(0.0f,0.5f);
        userStatus.position = ccp(screenSize.width/2 - 270, screenSize.height - 145);
        [self addChild:userStatus z:2];
        
        userscoreLabel.anchorPoint = ccp(1.0f,0.5f);
        userscoreLabel.position = ccp(screenSize.width/2 + 270, screenSize.height - 147);
        [self addChild:userscoreLabel z:2];
    } else {

    userStatus = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Rank: %@) %@", playerRank, playerName]
                                    fontName:@"Roboto-Light"
                                    fontSize:16];
    
    userscoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:16];
    
    userStatus.anchorPoint = ccp(0.0f,0.5f);
    userStatus.position = ccp(screenSize.width/2 - 130, screenSize.height - 125);
    [self addChild:userStatus z:2];
    
    userscoreLabel.anchorPoint = ccp(1.0f,0.5f);
    userscoreLabel.position = ccp(screenSize.width/2 + 130, screenSize.height - 127);
    [self addChild:userscoreLabel z:2];
    }
    
    otherPlayers = [scoreDict objectForKey:@"all"];
    int count = [otherPlayers count];
    
    if (count > 15) {
        count = 15;
    }
    
    for (int i = 0; i < count; i ++)
    {
        //        otherPlayers = [scoreDict objectForKey:@"friends"];
        NSMutableDictionary *playerDict = [otherPlayers objectAtIndex:i];
        NSNumber * score = [playerDict objectForKey:@"score"];
        NSString *name = [playerDict objectForKey:@"name"];
        if (!name) {
            name = @"player";
        }
        //        NSNumber *rank = [playerDict objectForKey:@"rank"];
        NSNumber *rank = [NSNumber numberWithInt:i + 1];
        
        LeaderBoardPlayer *p = [[LeaderBoardPlayer alloc] init];
        p.name = name;
        p.score = score;
        p.rank = rank;
        
        if (name.length > 16) { // add ellipsis
            name = [[name substringToIndex:17] stringByAppendingString:@"..."];
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* commaScore = [numberFormatter stringForObjectValue:score];
        
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                       fontName:@"Roboto-Light"
                                       fontSize:26];
            
            //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
            scoreLabel = [CCLabelTTF labelWithString:commaScore fontName:@"NexaBold" fontSize:26];
        } else {
            label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                       fontName:@"Roboto-Light"
                                       fontSize:16];
            
            //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
            scoreLabel = [CCLabelTTF labelWithString:commaScore fontName:@"NexaBold" fontSize:16];
        }

        
        
        
        label.anchorPoint = ccp(0.0f,0.5f);
        label.position = ccp(screenSize.width / 2 - 130, screenSize.height - 145 - i * 20);
        
        if ((i % 2) != 0) {
            label.color = ccc3(0, 0, 0);
        } else {
            label.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
        }
        
        [self addChild:label z: 2 tag:i];
        
        scoreLabel.anchorPoint = ccp(1.0f,0.5f);
        scoreLabel.position = ccp(screenSize.width / 2 + 130, screenSize.height - 147 - i * 20);
        
        if ((i % 2) != 0) {
            scoreLabel.color = ccc3(0, 0, 0);
        } else {
            scoreLabel.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
        }
        
        [self addChild:scoreLabel z: 2 tag:i + 10000];
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            label.position = ccp(screenSize.width / 2 - 270, screenSize.height - 175 - i * 32);
            scoreLabel.position = ccp(screenSize.width / 2 + 270, screenSize.height - 177 - i * 32);
        }
        
        [allPlayers addObject:p];
    }
    
    
    
    //    if([otherPlayers count] > 250)
    //    {
    //        count = 250;
    //    }
    
}



-(void) getFacebook
{
    if ([MGWU isFacebookActive] == true) {
        
        otherPlayers = [scoreDict objectForKey:@"friends"];
        count = [otherPlayers count];
        
        if (count > 15) {
            count = 15;
        }
        
        for (int i = 0; i < count; i ++)
        {
            NSMutableDictionary *playerDict = [otherPlayers objectAtIndex:i];
            NSNumber * score = [playerDict objectForKey:@"score"];
            NSString *name = [playerDict objectForKey:@"username"];
            if (!name) {
                name = @"player";
            }
            //        NSNumber *rank = [playerDict objectForKey:@"rank"];
            NSNumber *rank = [NSNumber numberWithInt:i + 1];
            
            LeaderBoardPlayer *p = [[LeaderBoardPlayer alloc] init];
            p.name = name;
            p.score = score;
            p.rank = rank;
            
            if (name.length > 16) { // add ellipsis
                name = [[name substringToIndex:17] stringByAppendingString:@"..."];
            }
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
            NSString* commaPlayerScore = [numberFormatter stringForObjectValue:score];
            
            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
                label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                           fontName:@"Roboto-Light"
                                           fontSize:26];
                
                //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
                scoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:26];
            } else {
                label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                           fontName:@"Roboto-Light"
                                           fontSize:16];
                
                //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
                scoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:16];
            }
            
            
            label.anchorPoint = ccp(0.0f,0.5f);
            label.position = ccp(screenSize.width / 2 - 130, screenSize.height - 145 - i * 20);
            if ((i % 2) != 0) {
                label.color = ccc3(0, 0, 0);
            } else {
                label.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
            }
            [self addChild:label z: 2 tag:i];
            
            scoreLabel.anchorPoint = ccp(1.0f,0.5f);
            scoreLabel.position = ccp(screenSize.width / 2 + 130, screenSize.height - 147 - i * 20);
            if ((i % 2) != 0) {
                scoreLabel.color = ccc3(0, 0, 0);
            } else {
                scoreLabel.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
            }
            [self addChild:scoreLabel z: 2 tag:i + 10000];
            
            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
                label.position = ccp(screenSize.width / 2 - 270, screenSize.height - 175 - i * 32);
                scoreLabel.position = ccp(screenSize.width / 2 + 270, screenSize.height - 177 - i * 32);
            }
            
            [allPlayers addObject:p];
        }
    } else {
        [self loginToFB];
//        [self loginToFB];
//        [self getScores];
    }
}

-(void) getGlobal
{
    otherPlayers = [scoreDict objectForKey:@"all"];
    count = [otherPlayers count];
    
    if (count > 15) {
        count = 15;
    }
    
    for (int i = 0; i < count; i ++)
    {
        NSMutableDictionary *playerDict = [otherPlayers objectAtIndex:i];
        NSNumber * score = [playerDict objectForKey:@"score"];
        NSString *name = [playerDict objectForKey:@"name"];
        if (!name) {
            name = @"player";
        }
        
        //        NSNumber *rank = [playerDict objectForKey:@"rank"];
        NSNumber *rank = [NSNumber numberWithInt:i + 1];
        
        LeaderBoardPlayer *p = [[LeaderBoardPlayer alloc] init];
        p.name = name;
        p.score = score;
        p.rank = rank;
        
        if (name.length > 16) { // add ellipsis
            name = [[name substringToIndex:17] stringByAppendingString:@"..."];
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* commaPlayerScore = [numberFormatter stringForObjectValue:score];
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                       fontName:@"Roboto-Light"
                                       fontSize:26];
            
            //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
            scoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:26];
        } else {
            label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@", rank, name]
                                       fontName:@"Roboto-Light"
                                       fontSize:16];
            
            //        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"NexaBold" fontSize:16];
            scoreLabel = [CCLabelTTF labelWithString:commaPlayerScore fontName:@"NexaBold" fontSize:16];
        }
        
        
        label.anchorPoint = ccp(0.0f,0.5f);
        label.position = ccp(screenSize.width / 2 - 130, screenSize.height - 145 - i * 20);
        if ((i % 2) != 0) {
            label.color = ccc3(0, 0, 0);
        } else {
            label.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
        }
        [self addChild:label z: 2 tag:i];
        
        scoreLabel.anchorPoint = ccp(1.0f,0.5f);
        scoreLabel.position = ccp(screenSize.width / 2 + 130, screenSize.height - 147 - i * 20);
        if ((i % 2) != 0) {
            scoreLabel.color = ccc3(0, 0, 0);
        } else {
            scoreLabel.color = ccc3(128, 0, 0); //ccc3(142, 68, 173);
        }
        [self addChild:scoreLabel z: 2 tag:i + 10000];
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            label.position = ccp(screenSize.width / 2 - 270, screenSize.height - 175 - i * 32);
            scoreLabel.position = ccp(screenSize.width / 2 + 270, screenSize.height - 177 - i * 32);
        }
        
        [allPlayers addObject:p];
    }
}


-(void) displayFacebookStats
{
    displayFacebook = true;
    displayGlobal = false;
    global1 = true;
    facebookSel = [CCSprite spriteWithFile:@"facebookHighscoreButtonSel.png"];
    globalSel = [CCSprite spriteWithFile:@"globalHighscoreButton.png"];
    
    [self selectBoard];
}

-(void) displayGlobalStats
{
    displayFacebook = false;
    displayGlobal = true;
    fb1 = true;
    facebookSel = [CCSprite spriteWithFile:@"facebookHighscoreButton.png"];
    globalSel = [CCSprite spriteWithFile:@"globalHighscoreButtonSel.png"];
    
    [self selectBoard];
    
}

-(void) selectBoard
{
    if (displayFacebook == true && fb1 == true) {
        // display Facebook leaderboards
        
        fb1 = false;
        NSMutableArray *global = [scoreDict objectForKey:@"all"];
        int numglobal = [global count];
        
        for (int j = 0; j < numglobal; j++) {
            [self removeChildByTag:j cleanup:YES];
            [self removeChildByTag:j + 10000 cleanup:YES];
        }
        
        playerRank = [userInfo objectForKey:@"friendrank"];
        playerName = [userInfo objectForKey:@"username"];
        
        if (playerName.length > 12) {
            playerName = [[playerName substringToIndex:13] stringByAppendingString:@"..."];
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* commaPlayerScore = [numberFormatter stringForObjectValue:playerHighScore];
        
        [userStatus setString:[NSString stringWithFormat:@"Rank: %@) %@", playerRank, playerName]];
        [userscoreLabel setString:commaPlayerScore];
        
        [self getFacebook];
        
    }
    
    if (displayGlobal == true && global1 == true) {
        // display global
        global1 = false;
        NSMutableArray *global = [scoreDict objectForKey:@"friends"];
        int numglobal = [global count];
        
        for (int j = 0; j < numglobal; j++) {
            [self removeChildByTag:j cleanup:YES];
            [self removeChildByTag:j + 10000 cleanup:YES];
        }
        
        playerRank = [userInfo objectForKey:@"rank"];
        playerName = [userInfo objectForKey:@"name"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* commaPlayerScore = [numberFormatter stringForObjectValue:playerHighScore];
        
        if (playerName.length > 12) {
            playerName = [[playerName substringToIndex:13] stringByAppendingString:@"..."];
        }
        
        [userStatus setString:[NSString stringWithFormat:@"Rank: %@) %@", playerRank, playerName]];
        [userscoreLabel setString:commaPlayerScore];
        
        [self getGlobal];
        
    }
    
}

- (void)loginToFB
{
    [userStatus setString:@"Not logged in to Facebook"];
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Login to Facebook"];
    [alert setMessage:@"You must be logged into Facebook for this leaderboard to be displayed. Log into Facebook?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Login"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
    //    [alert removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [MGWU loginToFacebook];
        [[CCDirector sharedDirector] replaceScene:[StatLayer node]];
//        [self getScores];
//        [self selfDestruct];
    }
    else if (buttonIndex == 1)
    {
//        [MGWU showMessage:@"Game data reset was cancelled." withImage:nil];
        [userStatus setString:@"Not logged in to Facebook"];
        
    }
}


@end
