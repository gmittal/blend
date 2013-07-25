//
//  GameOver.h
//  Moon Landing
//
//  Created by Gautam Mittal on 6/20/13.
//
//

#import "CCScene.h"
#import "GameOver.h"
#import "HelloWorldLayer.h"
#import "StartMenuLayer.h"
#import "StatLayer.h"

@interface GameOver : CCScene
{
    UITextField *nameField;
    int endingScore;
    int endingHighScore;
}
@end
