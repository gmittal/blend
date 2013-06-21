/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "kobold2d.h"
#import "GameOver.h"

@interface HelloWorldLayer : CCLayer
{
    CCDirector *director;
    CCSprite *player;
    CGPoint screenCenter;
    CGSize size;
    int playerWidth;
    int shipRandX;
    int shipRandY;
    id shipMove;
    int shipSpeed;
    
    NSMutableArray *section1Ships;
    NSMutableArray *section2Ships;
    NSMutableArray *section3Ships;
    
    CCSprite *ship1;
    CCSprite *ship2;
    CCSprite *ship3;
    
    CCSprite *section1;
    CCSprite *section2;
    CCSprite *section3;
    CCProgressTimer* progressBar1;
    CCProgressTimer* progressBar2;
    CCProgressTimer* progressBar3;
    CCProgressTo *progressTo1;
    CCProgressTo *progressTo2;
    CCProgressTo *progressTo3;
    
    float section1StartAngle;
    float section1EndAngle;
    float section2StartAngle;
    float section2EndAngle;
    float section3StartAngle;
    float section3EndAngle;
    
    int playerScore;
    CCLabelBMFont *scoreLabel;
    NSString* score;
    CCLabelBMFont *liveLabel;
    NSString* lives;
    int playerLives;
    
    int shipColor; // 1 = red, 2 = blue, 3 = yellow
    
    int framesPassed;
    float secondsPassed;
    
    CCAction *explode;
    NSMutableArray *explodingFrames;
    CCAnimation *explosion;
}

-(void) scoreCheck:(int) angle withColor: (int) color;
-(void) circleCollisionWithSprite:(CCSprite *) circle1 andThis:(CCSprite *) circle2;
-(void) createShipCoord:(CCSprite *)shipForCoord;
-(void) moveShip:(CCSprite *) shipToMove;
-(void) initShips;
-(void) handleUserInput;
-(void) divideAngularSections;
-(void) pickColor;
-(void) initSect1Ships;
-(void) initSect2Ships;
-(void) initSect3Ships;
-(void) updateScore;
-(void)update:(ccTime)dt;
-(void) normalizeAngle:(float) angleInput;
-(void) initChallenges;
-(void) gameOver;
-(void) addPowerup1;
-(void) addPowerup2;
-(void) addPowerup3;

@end
