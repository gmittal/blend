//
//  UpgradesLayer.h
//  Moon Landing
//
//  Created by Gautam Mittal on 7/2/13.
//
//

#import "CCScene.h"

@interface UpgradesLayer : CCScene
{
    CGSize screenSize;
    int coins;
    NSString *CoinString;
    CCLabelBMFont *coinsLabel;
    
    int numPower1;
    int numPower2;
    int numPower3;
    
    NSString *p1String;
    CCLabelBMFont *p1Label;
    
    NSString *p2String;
    CCLabelBMFont *p2Label;
    
    NSString *p3String;
    CCLabelBMFont *p3Label;
}

@end
