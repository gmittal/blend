//
//  StatLayer.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/27/13.
//
//

#import "StatLayer.h"

@implementation StatLayer

CGSize screenSize;

-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(255, 255, 255, 255);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"USER STATS" fontName:@"SpaceraLT-Regular" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 210);
        [self addChild:gameTitle];
        
        
        NSNumber *savedHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
        int highScore = [savedHighScore intValue];
        NSString *highScoreString = [[NSString alloc] initWithFormat:@"High Score: %i", highScore];
        CCLabelBMFont *highScoreLabel = [CCLabelTTF labelWithString:highScoreString fontName:@"Roboto-Light" fontSize:20];
        highScoreLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        highScoreLabel.color = ccc3(0, 0, 0);
//        [self addChild:highScoreLabel];
        
        
        NSNumber *lastRoundScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedScore"];
        int lastRoundPlayedScore = [lastRoundScore intValue];
        NSString *lastRoundString = [[NSString alloc]initWithFormat:@"Last Round: %i", lastRoundPlayedScore];
        CCLabelBMFont *lastRoundPlayed = [CCLabelTTF labelWithString:lastRoundString fontName:@"Roboto-Light" fontSize:20];
        lastRoundPlayed.position = ccp(screenSize.width/2, screenSize.height/2 - 40);
        lastRoundPlayed.color = ccc3(0, 0, 0);
//        [self addChild:lastRoundPlayed];
        
//        [MGWU submitHighScore:highScore byPlayer:@"gmittal" forLeaderboard:@"defaultLeaderboard"];
        
        NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        [MGWU submitHighScore:highScore byPlayer:savedUser forLeaderboard:@"defaultLeaderboard"];
    
//        [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:)
//                                 onTarget:self];

        [self getScores];
        
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
    
    
    NSMutableArray *otherPlayers = [scores objectForKey:@"all"];
    int count = [otherPlayers count];
    
//    if([otherPlayers count] > 250)
//    {
//        count = 250;
//    }
    
    for (int i = 0; i < count; i ++)
    {
        NSMutableDictionary *playerDict = [otherPlayers objectAtIndex:i];
        NSNumber * score = [playerDict objectForKey:@"score"];
        NSString *name = [playerDict objectForKey:@"name"];
//        NSNumber *rank = [playerDict objectForKey:@"rank"];
        NSNumber *rank = [NSNumber numberWithInt:i + 1];
    
        LeaderBoardPlayer *p = [[LeaderBoardPlayer alloc] init];
        p.name = name;
        p.score = score;
        p.rank = rank;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@ : %@", rank, name, score]
                                               fontName:@"Roboto-Light"
                                               fontSize:16];
        
        label.position = ccp(screenSize.width / 2, screenSize.height - 55 - i * 20);
        label.color = ccc3(0, 0, 0);
        [self addChild:label z: 2];
        
        [allPlayers addObject:p];
    }

}

@end
