//
//  StatLayer.h
//  Moon Landing
//
//  Created by Gautam Mittal on 6/27/13.
//
//

#import "CCScene.h"
#import "StartMenuLayer.h"
#import "LeaderBoardPlayer.h"
#import "GameOver.h"

@interface StatLayer : CCScene
{
    NSMutableArray *allPlayers;
    CCSprite *facebookSel;
    CCSprite *globalSel;
    bool displayGlobal;
    bool displayFacebook;
    CCLabelTTF *userStatus;
    CCLabelTTF *userscoreLabel;
    NSDictionary *userInfo;
    NSString *playerName;
    NSNumber *playerHighScore;
    NSNumber *playerRank;
    NSDictionary *facebookInfo;
    CCLabelTTF *label;
    CCLabelTTF *scoreLabel;
    NSMutableArray *otherPlayers;
    
    int count;
    
    NSDictionary *scoreDict;
    
    bool global1;
    bool fb1;
    
}

@end
