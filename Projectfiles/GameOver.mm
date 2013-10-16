//
//  GameOver.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/20/13.
//
//

#import "GameOver.h"
#import "SimpleAudioEngine.h"

@implementation GameOver


-(id) init
{
	if ((self = [super init]))
	{
        glClearColor(0, 0, 0, 0);
        [self unscheduleAllSelectors];
        
        // have everything stop
        CCNode* node;
        CCARRAY_FOREACH([self children], node)
        {
            [node pauseSchedulerAndActions];
        }
        
        
        // add the labels shown during game over
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = ccp(screenSize.width/2, screenSize.height/2);
        
        CCLabelTTF* gameOver;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            gameOver = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"NexaBold" fontSize:80];
            gameOver.position = CGPointMake(screenSize.width / 2, screenSize.height - 230);
        
        } else {
            gameOver = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"NexaBold" fontSize:40];
            gameOver.position = CGPointMake(screenSize.width / 2, screenSize.height - 130);
        }
        
        [self addChild:gameOver z:100 tag:100];
        
        // game over label runs 3 different actions at the same time to create the combined effect
        // 1) color tinting
        /*  CCTintTo* tint1 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:0];
         CCTintTo* tint2 = [CCTintTo actionWithDuration:2 red:255 green:255 blue:0];
         CCTintTo* tint3 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:0];
         CCTintTo* tint4 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:255];
         CCTintTo* tint5 = [CCTintTo actionWithDuration:2 red:0 green:0 blue:255];
         CCTintTo* tint6 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:255];
         CCSequence* tintSequence = [CCSequence actions:tint1, tint2, tint3, tint4, tint5, tint6, nil];
         CCRepeatForever* repeatTint = [CCRepeatForever actionWithAction:tintSequence];
         [gameOver runAction:repeatTint];
         
         // 2) rotation with ease
         CCRotateTo* rotate1 = [CCRotateTo actionWithDuration:2 angle:3];
         CCEaseBounceInOut* bounce1 = [CCEaseBounceInOut actionWithAction:rotate1];
         CCRotateTo* rotate2 = [CCRotateTo actionWithDuration:2 angle:-3];
         CCEaseBounceInOut* bounce2 = [CCEaseBounceInOut actionWithAction:rotate2];
         CCSequence* rotateSequence = [CCSequence actions:bounce1, bounce2, nil];
         CCRepeatForever* repeatBounce = [CCRepeatForever actionWithAction:rotateSequence];
         [gameOver runAction:repeatBounce];
         
         // 3) jumping
         CCJumpBy* jump = [CCJumpBy actionWithDuration:3 position:CGPointZero height:screenSize.height / 3 jumps:1];
         CCRepeatForever* repeatJump = [CCRepeatForever actionWithAction:jump];
         [gameOver runAction:repeatJump]; */
        
        
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
        
        
        
        NSNumber *endingScoreNumber = [MGWU objectForKey:@"sharedScore"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedScore"];
        endingScore = [endingScoreNumber intValue];
        NSString *endScoreString = [[NSString alloc] initWithFormat:@"SCORE %i", endingScore];
        
        CCLabelBMFont *endScore;
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            endScore = [CCLabelTTF labelWithString:endScoreString fontName:@"NexaBold" fontSize:30];
            endScore.position = ccp(gameOver.position.x - [gameOver boundingBox].size.width/2, gameOver.position.y - 39);
            
        } else {
            endScore = [CCLabelTTF labelWithString:endScoreString fontName:@"NexaBold" fontSize:20];
            endScore.position = ccp(gameOver.position.x - [gameOver boundingBox].size.width/2, gameOver.position.y - 24);
        }
        

        endScore.color = ccc3(255, 255, 255);
        endScore.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:endScore];
        
        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        endingHighScore = [endingHighScoreNumber intValue];
        NSString *endHighScoreString = [[NSString alloc] initWithFormat:@"High Score: %i", endingHighScore];
        CCLabelBMFont *endHighScore = [CCLabelTTF labelWithString:endHighScoreString fontName:@"Roboto-Light" fontSize:20];
        endHighScore.position = ccp(screenSize.width/2, 60);
        endHighScore.color = ccc3(0, 0, 0);
//        [self addChild:endHighScore];
        
        CCSprite *coinIcon = [CCSprite spriteWithFile:@"coin1.png"];
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
           coinIcon.position = ccp(40, screenSize.height - 40);
        } else {
        coinIcon.position = ccp(20, screenSize.height - 20);
        }
//        coinIcon.scale = 1.25f;
        [self addChild:coinIcon z:1000];
        
        NSNumber *endingCoinNumber = [MGWU objectForKey:@"sharedCoins"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* coinStr = [numberFormatter stringForObjectValue:endingCoinNumber];
        
        int endingCoins = [endingCoinNumber intValue];
        NSString *endCoinString = coinStr; //[[NSString alloc] initWithFormat:@"%i", endingCoins];
        CCLabelBMFont *endCoins;
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            endCoins = [CCLabelTTF labelWithString:endCoinString fontName:@"NexaBold" fontSize:44];
            endCoins.position = ccp(coinIcon.position.x + 43, coinIcon.position.y);

        } else {
            endCoins = [CCLabelTTF labelWithString:endCoinString fontName:@"NexaBold" fontSize:22];
            endCoins.position = ccp(coinIcon.position.x + 23, screenSize.height - 22);
        }
        endCoins.color = ccc3(0, 0, 0);
        endCoins.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:endCoins];
        
        
        CCMenuItemImage *tweet = [CCMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:@"twitterSel.png" target:self selector:@selector(shareTweet)];
        CCMenuItemImage *postFB = [CCMenuItemImage itemWithNormalImage:@"facebook.png" selectedImage:@"facebookSel.png" target:self selector:@selector(shareFB)];
        CCMenu *shareMenu = [CCMenu menuWithItems:postFB, tweet, nil];
        [shareMenu alignItemsHorizontallyWithPadding:0.0f];
        shareMenu.position = ccp(screenSize.width - 60, screenSize.height - 30);
        
        //        if ([MGWU isTwitterActive] == true) {
        [self addChild:shareMenu z:1000];
        //        }
        
        
        
        CCLabelTTF *playAgainLabel = [CCLabelTTF labelWithString:@"Play Again" fontName:@"NexaBold" fontSize:22];
        CCLabelTTF *leaderLabel = [CCLabelTTF labelWithString:@"Leaderboards" fontName:@"NexaBold" fontSize:22];
        CCLabelTTF *upgradesLabel = [CCLabelTTF labelWithString:@"Upgrades" fontName:@"NexaBold" fontSize:22];
        
        playAgainLabel.position = ccp(screenSize.width/2, screenSize.height/2 - 10);
        leaderLabel.position = ccp(screenSize.width/2, screenSize.height/2 - 60);
        upgradesLabel.position = ccp(screenSize.width/2, screenSize.height/2 - 110);

//        [self addChild:playAgainLabel z:7];
//        [self addChild:leaderLabel z:7];
//        [self addChild:upgradesLabel z:7];
        
        CCMenuItemImage *playAgain = [CCMenuItemImage itemWithNormalImage:@"playAgain.png" selectedImage:@"playAgainSel.png" target:self selector:@selector(playAgain)];
        playAgain.scale = 1.25f;
//        playAgain.scaleX = 1.8f;
        CCMenuItemImage *leaderboards = [CCMenuItemImage itemWithNormalImage:@"leaderboards.png" selectedImage:@"leaderboardsSel.png" target:self selector:@selector(statsGame)];
        leaderboards.scale = 1.25f;
//        leaderboards.scaleX = 1.8f;
        CCMenuItemImage *upgrades = [CCMenuItemImage itemWithNormalImage:@"upgrades.png" selectedImage:@"upgradesSel.png" target:self selector:@selector(gameUpgrades)];
        upgrades.scale = 1.25f;
//        upgrades.scaleX = 1.8f;

        CCMenu *gameOverMenu = [CCMenu menuWithItems:playAgain, leaderboards, upgrades, nil];
        [gameOverMenu alignItemsVertically];
        gameOverMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 60);
        [self addChild:gameOverMenu];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"newHighScore"] == true) {
            [self showNewHighScoreAlert];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"newHighScore"];
        }
        
        
//        nameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 180, 250, 25)];
//        [[[CCDirector sharedDirector] view] addSubview:nameField];
//        nameField.delegate = self;
//        nameField.placeholder = @"Tap to Enter Username";
//        nameField.borderStyle = UITextBorderStyleRoundedRect;
//        [nameField setReturnKeyType:UIReturnKeyDone];
//        [nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
//        [nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        
        // text field that uses an image as background (aka "skinning")
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(screenCenter.x - 125, screenCenter.y - 170, 250, 30)];
            
        } else {
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 180, 250, 30)];
        }
        
        [[[CCDirector sharedDirector] view] addSubview:nameField];
//        textFieldSkinned.text = @"  With background image";
        nameField.delegate = self;
        nameField.placeholder = @"Tap to Enter Username";
        // load and assign the UIImage as background of the text field
        NSString* imageFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"flatText.png"];
//        CCLOG(@"imageFile with path = %@", imageFile);
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:imageFile];
        nameField.background = image;
        [nameField setFont:[UIFont systemFontOfSize:22]];
        [nameField setTextAlignment:UITextAlignmentCenter];
        [nameField setReturnKeyType:UIReturnKeyDone];
        [nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"LLS - Fang.wav" loop:YES];
        }
    
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == nameField && ![nameField.text isEqualToString:@""])
    {
		
        [nameField endEditing:YES];
        [nameField removeFromSuperview];
        // here is where you should do something with the data they entered
        NSString *result = nameField.text;
        NSLog(result);
        //        username = result;
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"username"];
        if (endingHighScore != 0 || endingHighScore != nil) {
            [MGWU submitHighScore:endingHighScore byPlayer:result forLeaderboard:@"defaultLeaderboard"];
            [self confirmHighScore];
        }
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (![nameField.text isEqualToString:@""])
	{
		//Hide keyboard when "done" clicked
		[textField resignFirstResponder];
		[nameField removeFromSuperview];
		return YES;
	}
}

-(void) gameUpgrades
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[UpgradesLayer node]]];
    //Hide keyboard when "done" clicked
    //  [textField resignFirstResponder];
    [nameField removeFromSuperview];
}

-(void) showNewHighScoreAlert
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"New High Score"];
    [alert setMessage:[[NSString alloc] initWithFormat:@"You have a new high score of %i", endingScore]];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

-(void) confirmHighScore
{
    UIAlertView *highscore = [[UIAlertView alloc] init];
    [highscore setTitle:@"Success!"];
    [highscore setMessage:@"Your username was submitted along with this round's score."];
    [highscore setDelegate:self];
    [highscore addButtonWithTitle:@"OK"];
    [highscore show];
}



-(void) shareTweet
{
    NSString *messageToShare = [[NSString alloc] initWithFormat:@"Just got a score of %i in an awesome game of Blend! @makegameswithus", endingScore];
    if ([MGWU isTwitterActive] == true) {
        [MGWU postToTwitter:messageToShare];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Twitter Sign-in"];
        [alert setMessage:@"You must be logged into Twitter in order to use this feature."];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
}

-(void) shareFB
{
    NSString *caption = @"Try and beat this awesome score!";
    NSString *messageToPost = [[NSString alloc] initWithFormat:@"Just got a score of %i in an awesome game of Blend! #makegameswithus", endingScore];
    if ([MGWU isFacebookActive] == true) {
        [MGWU shareWithTitle:@"Blend" caption:caption andDescription:messageToPost];
    } else {
        [MGWU loginToFacebook];
        [MGWU shareWithTitle:@"Blend" caption:caption andDescription:messageToPost];
    }
}


-(void) statsGame
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[StatLayer node]]];
    //Hide keyboard when "done" clicked
    //  [textField resignFirstResponder];
    [nameField removeFromSuperview];
    //return YES;
}

-(void) playAgain
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
    [nameField removeFromSuperview];
}

+(BOOL) returnBool
{
    return true;
}

@end
