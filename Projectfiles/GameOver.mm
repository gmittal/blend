//
//  GameOver.m
//  Moon Landing
//
//  Created by Gautam Mittal on 6/20/13.
//
//

#import "GameOver.h"

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
        
        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"YOU DIED!" fontName:@"Marker Felt" fontSize:60];
        gameOver.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:gameOver z:100 tag:100];
        
        // game over label runs 3 different actions at the same time to create the combined effect
        // 1) color tinting
        CCTintTo* tint1 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:0];
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
        [gameOver runAction:repeatJump];
        
        CCMenuItemFont *playAgain = [CCMenuItemFont itemFromString: @"Play Again" target:self selector:@selector(playAgain)];
        CCMenu *gameOverMenu = [CCMenu menuWithItems:playAgain, nil];
        [gameOverMenu alignItemsVertically];
        gameOverMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 40);
        [self addChild:gameOverMenu];
        
    }
    return self;
}

-(void) playAgain
{
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

@end
