/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "kobold2d.h"
#import "GameOver.h"
#import "PauseLayer.h"

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
    
    float distance;
    float radii;
    int numCollisions;
    
    CCLabelBMFont *warningLabel;
    bool warning;
    
    NSMutableArray *powerUpType1;
    NSMutableArray *powerUpType2;
    NSMutableArray *powerUpType3;
    CCSprite *powerUp1;
    CCSprite *powerUp2;
    CCSprite *powerUp3;
    
    CCMenuItemImage *powerUpCreator1;
    CCMenuItemImage *powerUpCreator2;
    CCMenuItemImage *powerUpCreator3;
    
    bool gameOver;
    
    bool collisionDidHappen;
    
    int livesSubtract;
    int scoreAdd;
    
    CCSprite *pauseButton;
    float lastTouchAngle;
    
    int numPower1Left;
    int numPower2Left;
    int numPower3Left;
    NSString *power1Num;
    NSString *power2Num;
    NSString *power3Num;
    CCLabelBMFont *power1Left;
    CCLabelBMFont *power2Left;
    CCLabelBMFont *power3Left;
    
    CCMenu *powerUpCreatorsMenu;
    
    CCSprite *infiniteBorderPowerUp1;
    
    NSNumber *sharedScore;
    
    int startLives;
    
    CCMenuItemImage *powerUpBorder1;
    CCMenuItemImage *powerUpBorder2;
    CCMenuItemImage *powerUpBorder3;
    
    CCLabelBMFont *screenflashLabel;
    
    CCSprite *enemyShip1;
    CCSprite *enemyShip2;
    CCSprite *enemyShip3;
    
    int spriteTagNum;
    
    float rotation;
    float circle_rotation;// = 0.0f;
    
    
    int playerHighScore;
    
    NSNumber *sharedHighScore;
    
    int numSpritesCollided;
    
    int shipShape;
    
    int playerCoins;
    NSNumber *sharedCoins;
    
    CCSprite *lifeBarSprite;
    CCProgressTimer *lifeBar;
    CCProgressTo *lifeUpdater;
    
    CCSprite *lifeBarBorder;
    
    int topBottomVariable;
    
    int numSpritesPerArray;
    int numSpritesCollidedWithShield;
    
    int shipArray;
    
    int pointMultiplier;
    
    NSString *multiplierString;
    CCLabelBMFont *multiplierLabel;
    
    int numHitsUntilNextMultiplier;
    
    CCParticleSystem *burnGrass;
    CCParticleSystem *snuffedFire;
    CCParticleSystem *dryWater;
    
    CCSprite *multiplierWrapper;
    
    CCLayerColor* colorLayer;
    
    int generationInterval;
    
    bool playedTutorial;

    float previousShipDelay;
    float previousShipSpeed;
    
    int previousShipRandX;
    
    int previousShipColor;
    float randGeneratedAngle;
    float spawnDistance;
    
    float previousGeneratedAngle;
    
    int numFramesBetweenCollisions;
    
    bool updateMoveCounter;
    
    int moveDelayInFrames;
    
    NSUInteger previousCount;
    
    int numTimesIndexMoves;
    NSUInteger previousIndexMoves;
    
    int previousIndex;
    bool didRun;
    
    int kevinTest;
    
    int spriteMoveIndex;
    
    int frameCountForShipInit;
    
    int initDelayInFrames;
    
    int initCounter;
    
    bool p3Enabler;
    
    int numTimesP1Used;
    int numTimesP2Used;
    int numTimesP3Used;
    
    float timeShieldEnabled;
    
    CCParticleSystem *deathSystem;
    
    bool grassBeingKilled;
    bool fireBeingKilled;
    bool waterBeingKilled;
    
    float deviceFPS; // variable that stores the device frames/second
    
    CCSprite *rotateArrow;
    CCSprite *powerupArrow;
    
    int multiplierDecrease;
    
    bool p1Enabled;
    bool p2Enabled;
    
    NSMutableArray *spiralEffectPositions;
    
    bool createSpiralEffectWithCoords;
    int numLivesForSpiral;
    
    bool explodedAlready;
    
    int spiralIncrement;
    
    bool oniPad;
    
    int targetScore;
    
    int dbTapFrames;
    
    bool startDbTapCheck;
    
    bool userIsTapping;
    
    float playerVelocity;
    
    int startRotationAngleForLog;
    int endRotationAngleForLog;
    
    float playerMomentum;
    
    int velocityFrames;
    
    bool spriteIsColliding;
    
    CCLabelBMFont *furyLabel;
    
    bool p1Locked;
    bool p2Locked;
    bool p3Locked;
    
    bool p1Tutorial;
    bool p2Tutorial;
    bool p3Tutorial;
    
    int numRoundsPlayed;
    
    CCSprite *power1Display;
    CCSprite *power2Display;
    CCSprite *power3Display;
    
    bool p1TutorialRunning;
    bool p2TutorialRunning;
    bool p3TutorialRunning;
    
    int numFalseCollisions;
    CCSprite *multiplierPointer;
    
    int furyColor;
    
    float speedIncrement;
    
    bool matchColorsTutorial;
    
    bool invinciblePlayer;
    
    bool multiplierTutorialShown;
}

+(id)scene;
-(void) scoreCheck:(int) angle withSprite: (CCSprite *) spriteWithArray;
-(void) circleCollisionWithSprite:(CCSprite *) circle1 andThis:(CCSprite *) circle2;
-(void) createShipCoord:(CCSprite *)shipForCoord topBottomChoose:(int) decidingVariable withColor:(int) color;
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
-(void) transferToGameOverScene;
-(void) killGrass;
-(void) killFire;
-(void) killWater;
-(void) runEffect;
-(void) circleCollisionWith:(NSMutableArray *) circle2;
-(void) removeArraySprite:(id)sender;
-(void) removeSprite:(id)sender;
-(void) increaseMultiplier;
-(void) infiniteBorderCollisionWith:(CCSprite *) shipToCollideWith withObject:(int) index;
-(void) addInfiniteArrayPoints;
-(void) removeInfiniteArraySprite:(id) sender;
-(void) enablePowerUp1;
-(void) enablePowerUp2;
-(void) enablePowerUp3;
-(void) addInfiniteBorder;
-(void) removeInfiniteArrayBorder;
-(void) shipPauseAllActions;
-(void) shipResumeAllActions;
-(void) pickShape;
-(void) pickArray;
-(void) initializeShip1Sprite;
-(void) initializeShip2Sprite;
-(void) initializeShip3Sprite;
-(void) moveShip1;
-(void) moveShip2;
-(void) moveShip3;
-(void) moveShip:(CCSprite *) shipToMove;
-(void) updateHealth;
-(void) updateLabelPositions;
-(void) normalizeThisToStandards:(CGPoint) rot_pos1 andThis:(CGPoint) rot_pos2 withRotVariable:(float) rotationVar;
-(void) initMenuItems;
-(void) flashLabel:(NSString *) stringToFlashOnScreen actionWithDuration:(float) numSecondsToFlash color:(NSString *) colorString;
-(void) makeFlashLabelVisible;
-(void) makeFlashLabelInvisible;
-(void) goToGameOver;
-(void) resetVariables;
-(void) pauseGame;
-(void) startTutorial;
-(void) tutorial1;
-(void) tutorial2;
-(void) tutorial3;
-(void) hideAllTutorialSprites;
-(void) removeGrassEffect;
-(void) removeFireEffect;
-(void) removeWaterEffect;
-(void) runDeathSeqOn:(NSString *) effectName;
-(void) removeAllSpritesFromArray;
-(void) penalizePlayer;
-(void) enableShipMultiplierIncrease;
-(void) disableShipMultiplierIncrease;
-(void) delayShipMove;
-(void) setToFalse;
-(CGPoint) generatePointByAngle:(float) angle distance:(float) someDistance startPoint:(CGPoint) point;
-(void) enableSpiralEffect;
-(void) disableSpiralEffect;
-(void) updateEffectPositions;
-(void) flashWithRed:(int) red green:(int) green blue:(int) blue alpha:(int) alpha actionWithDuration:(float) duration;
-(void) removeFlashColor;
-(void) setDimensionsInPixelsOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height;
-(void) setDimensionsInPixelsGraduallyOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height;
-(void) updateCollisionCounter;
-(void) updateMoveDelayCounter:(ccTime) dt;
-(void) initializeTheShipArray:(ccTime) dt;








@end
