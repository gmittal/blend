//
//  SettingsLayer.h
//  Moon Landing
//
//  Created by Gautam Mittal on 7/8/13.
//
//

#import "CCScene.h"
#import "StartMenuLayer.h"

@interface SettingsLayer : CCScene
{
    CGSize screenSize;
    UIAlertView *alert;
    UIAlertView *FBalert;
}

-(void) goHome;
@end
