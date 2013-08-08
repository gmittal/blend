//
//  StartMenuLayer.h
//  Moon Landing
//
//  Created by Gautam Mittal on 6/25/13.
//
//

#import "CCScene.h"
#import "HelloWorldLayer.h"
#import "StatLayer.h"
#import "StoreLayer.h"
#import "UpgradesLayer.h"
#import "SettingsLayer.h"

@interface StartMenuLayer : CCScene
{
    CCSprite *titleSprite;
    CGSize screenSize;
    CGPoint screenCenter;
    CCMenu *startMenu;
    CCLabelTTF *promoLabel;
    CCLabelTTF *aboutLabel;
    
}
@end
