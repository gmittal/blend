/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

// NOT OPTIMIZED FOR 4-Inch RETINA SCREENS YET
/*
 
 CURRENT BUGS:
 - LIVES DO NOT SUBTRACT FOR ALL INCORRECT COLLISIONS (BUT WORKS WELL ENOUGH WHEN LIVES ARE NOT DISPLAYED)
 */

/* SUGGESTIONS:
 - PHYSICS FOR USER INPUT (MAKE THE PLANET HAVE A MORE FLUID SPIN, MUCH LIKE A WHEEL)
 - LEADERBOARDS (IMPLEMENTED)
 - HAVE A 'SWEET-SPOT' WHICH GETS ENABLED EVERY ONCE IN A WHILE WHERE IF THE USER LANDS THE SHIP THERE, THEY GET BONUS POINTS
 - (NEW POSSIBLE GAMEPLAY FEATURE): HAVE THE USER COAT THE OUTSIDE OF THE BALL WITH SHIPS TO PROCEED TO THE NEXT ROUND
 */


/*
    POWERUP IDEAS:
    - ENERGY SHEILD (IMPLEMENTED, POWERUP1)
    - PAUSE POWER (IMPLEMENTED, POWERUP2)
    - DESTROY SHIP POWER (IMPLEMENTED, POWERUP3)
 
    (3) - SLOW MOTION POWER
    (2) - WORLD SPlITS INTO 2 COLORS FOR A CERTAIN AMOUNT OF TIME
    - COLORS BECOME INVERSE (RED GOES TO BLUE, BLUE TO YELLOW, YELLOW TO RED)
    (2) - SUICIDE POWERUP (BLOW EVERYTHING UP)
    - ATMOSPHERE POWERUP (certain section can be broken by each ship collision, but the rest of the section will remain intact)
    - MORE SECTIONS POWERUP (creates more colored sections on the middle wheel)
    (2) - UNLEASH MONSTER POWERUP (releases monster that shoots ships, redirecting to a minigame where you shoot ships)
    (2) - STORE POWER (buy anything midway through a game, but with limited time)
    (2) - MUSIC MODE (play music to increase focus and coordination)
    (1) - NEGATIVE COLOR MODE (inverts the colors on screen)
    (2) - GOLF MODE (try and get the most ships into the wrong sectors as possible)
    (2) - POINT BOOST (any ship that collides with the player will grant some extra number of points)
    (1) - RED SHIP BOOST (only creates red ships for some amount of time)
    (1) - BLUE SHIP BOOST (only creates blue ships for some amount of time)
    (1) - YELLOW SHIP BOOST (only creates yellow ships for some amount of time)
    (1) - LIVES BOOST (gain lives every time a ship correctly lands into a sector)
    (2) - CHANGE THE DEATH OF THE PLANET (change the death of the planet randomly, will it explode? will it melt? will it burn?)
    (2) - ZOMBIE PLANET (right before death, activate powerup to ressurect the planet and give you an additional life)
    (1) - KATAMARI PLANET (enable this powerup to allow any ship that collides with the planet to add on to the ships mass for a certain amount of time)
    - INVERSE STEERING (does what its name claims)
    (1) - BOUNCE OFF POWERUP (all ships that collide with the planet bounce off)
*/

/*
    PROJECTILE IDEAS:
    - MAGENTA SHIP (IMPLEMENTED, SHPIP1)
    - BLUE SHIP (IMPLEMENTED, SHIP2)
    - YELLOW SHIP (IMPLEMENTED, SHIP3)
    - BAG OF COINS: GIVES USER 10 COINS IF PLACED IN CORRECT SECTOR
*/



#import "HelloWorldLayer.h"

@interface HelloWorldLayer (PrivateMethods)
@end

@implementation HelloWorldLayer


CCMenuItemImage *powerUpBorder1;
CCMenuItemImage *powerUpBorder2;
CCMenuItemImage *powerUpBorder3;

CCLabelBMFont *screenflashLabel;

CCSprite *enemyShip1;
CCSprite *enemyShip2;
CCSprite *enemyShip3;

int spriteTagNum = 0;

float rotation = 0.0f;
float circle_rotation;// = 0.0f;


int playerHighScore;

NSNumber *sharedHighScore;


-(id) init
{
	if ((self = [super init]))
	{
        // initialize game variables
		glClearColor(255, 255, 255, 255); // default background color
        director = [CCDirector sharedDirector];
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = CGPointMake(size.width/2, size.height/2);
        /*    shipSpeed = 5.0f; // default speed
         playerScore = 0;
         playerLives = 5;
         framesPassed = 0;
         secondsPassed = 0;
         numCollisions = 0; */
        [self resetVariables]; // does pretty much everything the previous 6 lines do.
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"expldata.plist"];
        
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"expldata.png"];
        
        
        
        [self addChild:spriteSheet];
        
        
        
        explodingFrames = [[NSMutableArray alloc] init];
        
        
        
        for (int i = 0; i <= 11; i ++)
            
        {
            
            [explodingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%d.png", i]]];
            
        }
        
        
        
        explosion = [CCAnimation animationWithSpriteFrames:explodingFrames delay:0.3f];
        
        
        
        explode = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:explosion] times:1];
        
        //tell the bear to run the taunting action
        
        player = [[CCSprite alloc] init];
        player = [CCSprite spriteWithFile:@"border.png"];
        player.position = ccp(size.width/2, size.height/2);
        playerWidth = [player boundingBox].size.width; // get player width
        [self addChild:player z:1];
        //        [player runAction:explode];
        
        section1 = [CCSprite spriteWithFile:@"section1.png"];
        progressBar1 = [CCProgressTimer progressWithSprite:section1];
        progressBar1.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar1 z:1];
        progressBar1.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //        [progressBar1 setAnchorPoint:zero];
        progressTo1 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        section2 = [CCSprite spriteWithFile:@"section2.png"];
        progressBar2 = [CCProgressTimer progressWithSprite:section2];
        progressBar2.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar2 z:2];
        progressBar2.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar2.rotation = 120.0f;
        progressTo2 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        section3 = [CCSprite spriteWithFile:@"section3.png"];
        progressBar3 = [CCProgressTimer progressWithSprite:section3];
        progressBar3.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar3 z:2];
        progressBar3.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar3.rotation = 240.0f;
        progressTo3 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        
        
        [progressBar1 runAction:progressTo1];
        [progressBar2 runAction:progressTo2];
        [progressBar3 runAction:progressTo3];
        
        // score label
        score = [[NSString alloc]initWithFormat:@"Score: %i", playerScore];
        scoreLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:25];
        scoreLabel.position = ccp(size.width/2, 465);
        scoreLabel.color = ccc3(0,0,0);
        [self addChild:scoreLabel z:100];
        
        // lives label
        lives = [[NSString alloc]initWithFormat:@"Lives: %i", playerLives];
        liveLabel = [CCLabelTTF labelWithString:lives fontName:@"HelveticaNeue-Light" fontSize:25];
        liveLabel.position = ccp(size.width/2, 435);
        liveLabel.color = ccc3(0,0,0);
//        [self addChild:liveLabel z:100];
        
        // warning label
        warningLabel = [CCLabelTTF labelWithString:@"STATUS CRITICAL" fontName:@"Courier" fontSize:25];
        warningLabel.position = ccp(size.width/2, 435);
        warningLabel.color = ccc3(255,0,0);
//        [self addChild:warningLabel z:100];
        
        // initialize arrays
        powerUpType1 = [[NSMutableArray alloc] init];
        powerUpType2 = [[NSMutableArray alloc] init];
        powerUpType3 = [[NSMutableArray alloc] init];
        
        ship1 = [[CCSprite alloc] init];
        ship1 = [CCSprite spriteWithFile:@"ship1.png"];
        ship1.scale = 0.15f;
//        ship1.tag = spriteTagNum;
        
        powerUpCreator1 = [[CCMenuItemImage alloc] init];
        powerUpCreator1 = [CCMenuItemImage itemWithNormalImage:@"section1.png"
                                                            selectedImage: @"section1.png"
                                                                   target:self
                                                                 selector:@selector(enablePowerUp1)];
        powerUpCreator1.scale = 0.15f;
        powerUpCreator1.position = ccp(size.width/3 - 70, 20);
//        [self addChild:powerUpCreator1 z:5];
        
        powerUpCreator2 = [[CCMenuItemImage alloc] init];
        powerUpCreator2 = [CCMenuItemImage itemWithNormalImage:@"section2.png"
                                                 selectedImage: @"section2.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp2)];
        powerUpCreator2.scale = 0.15f;
        powerUpCreator2.position = ccp(size.width/2 - 20, 20);
//        [self addChild:powerUpCreator2 z:5];
        
        powerUpCreator3 = [[CCMenuItemImage alloc] init];
        powerUpCreator3 = [CCMenuItemImage itemWithNormalImage:@"section3.png"
                                                 selectedImage: @"section3.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp3)];
        powerUpCreator3.scale = 0.15f;
        powerUpCreator3.position = ccp(size.width/1.5 + 30, 20);
//        [self addChild:powerUpCreator3 z:5];
        
        powerUpCreatorsMenu = [CCMenu menuWithItems:powerUpCreator1, powerUpCreator2, powerUpCreator3, nil];
        powerUpCreatorsMenu.position = ccp(size.width/2-160, 0);
        [self addChild:powerUpCreatorsMenu z:5 tag:10];
        
        // init pausebutton
        pauseButton = [[CCSprite alloc] init];
        pauseButton = [CCSprite spriteWithFile:@"pause.png"];
        pauseButton.position = ccp(size.width - 20, size.height - 20);
        pauseButton.scale = 0.25f;
        [self addChild:pauseButton z:100];
        
        // init powerup labels
        power1Left = [[CCLabelBMFont alloc] init];
        power1Num = [[NSString alloc]initWithFormat:@"%i", numPower1Left];
        power1Left = [CCLabelTTF labelWithString:power1Num fontName:@"Roboto-Light" fontSize:25];
        power1Left.position = ccp(size.width/3 - 30, 20);
        power1Left.color = ccc3(0,0,0);
        [self addChild:power1Left z:200];
        
        power2Left = [[CCLabelBMFont alloc] init];
        power2Num = [[NSString alloc]initWithFormat:@"%i", numPower2Left];
        power2Left = [CCLabelTTF labelWithString:power2Num fontName:@"Roboto-Light" fontSize:25];
        power2Left.position = ccp(size.width/2 + 20, 20);
        power2Left.color = ccc3(0,0,0);
        [self addChild:power2Left z:200];
        
        power3Left = [[CCLabelBMFont alloc] init];
        power3Num = [[NSString alloc]initWithFormat:@"%i", numPower3Left];
        power3Left = [CCLabelTTF labelWithString:power3Num fontName:@"Roboto-Light" fontSize:25];
        power3Left.position = ccp(size.width/1.5 + 70, 20);
        power3Left.color = ccc3(0,0,0);
        [self addChild:power3Left z:200];
        
        
        powerUpBorder1 = [[CCMenuItemImage alloc] init];
        powerUpBorder1 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp1)];
        powerUpBorder1.position = ccp(size.width/3 - 53, 20);
//        [self addChild:powerUpBorder1 z:-5];
        
        powerUpBorder2 = [[CCMenuItemImage alloc] init];
        powerUpBorder2 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp2)];
        powerUpBorder2.position = ccp(size.width/2, 20);
//        [self addChild:powerUpBorder2 z:-5];
        
        powerUpBorder3 = [[CCMenuItemImage alloc] init];
        powerUpBorder3 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp3)];
        powerUpBorder3.position = ccp(size.width/1.5 + 53, 20);
//        [self addChild:powerUpBorder3 z:-5];
        
        CCMenu *powerBorderMenu = [CCMenu menuWithItems:powerUpBorder1, powerUpBorder2, powerUpBorder3, nil];
        powerBorderMenu.position = ccp(size.width/2-160, 0);
        [self addChild:powerBorderMenu z:-5];
        
        // init the border sprite for powerup1
        infiniteBorderPowerUp1 = [[CCSprite alloc] init];
        infiniteBorderPowerUp1 = [CCSprite spriteWithFile:@"border.png"];
        infiniteBorderPowerUp1.scale = 0;
        infiniteBorderPowerUp1.position = screenCenter;
        
        screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"SpaceraLT-Regular" fontSize:18];
        screenflashLabel.position = ccp(size.width/2, 405);
        screenflashLabel.color = ccc3(255,0,0);
        [self addChild:screenflashLabel z:110];
        screenflashLabel.visible = false;
        
        enemyShip1 = [[CCSprite alloc] init];
        enemyShip1 = [CCSprite spriteWithFile:@""];
        
        [self divideAngularSections];
        
        [self pickColor];
        [self initShips];
        
//        [self flashLabel:@"WELCOME!" forTime:2.0f];
        
        [self scheduleUpdate]; // schedule the framely update
	}
    
	return self;
}

+(id)scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [HelloWorldLayer node];
    [scene addChild:layer];
    return scene;
}


-(void) runEffect
{
	// remove any previous particle FX
	[self removeChildByTag:7 cleanup:YES];
	
    CCParticleSystem* system;
	
/*	switch (particleType)
	{
			// effects designed with Particle Designer http://particledesigner.71squared.com/
		case ParticleTypeDesignedFX:
			system = [CCParticleSystemQuad particleWithFile:@"designed-fx.plist"];
			break;
		case ParticleTypeDesignedFX2:
			// uses a plist with the texture already embedded
			system = [CCParticleSystemQuad particleWithFile:@"designed-fx2.plist"];
			system.positionType = kCCPositionTypeFree;
			break;
		case ParticleTypeDesignedFX3:
			// same effect but different texture (scaled down by Particle Designer)
			system = [CCParticleSystemQuad particleWithFile:@"designed-fx3.plist"];
			system.positionType = kCCPositionTypeFree;
			break;
			
			// programmed particle effect
		case ParticleTypeSelfMade:
			system = [ParticleEffectSelfMade node];
			break;
            
			// cocos2d built-in particle effects
		case ParticleTypeExplosion:
			system = [CCParticleExplosion node];
			break;
		case ParticleTypeFire:
			system = [CCParticleFire node];
			break;
		case ParticleTypeFireworks:
			system = [CCParticleFireworks node];
			break;
		case ParticleTypeFlower:
			system = [CCParticleFlower node];
			break;
		case ParticleTypeGalaxy:
			system = [CCParticleGalaxy node];
			break;
		case ParticleTypeMeteor:
			system = [CCParticleMeteor node];
			break;
		case ParticleTypeRain:
			system = [CCParticleRain node];
			break;
		case ParticleTypeSmoke:
			system = [CCParticleSmoke node];
			break;
		case ParticleTypeSnow:
			system = [CCParticleSnow node];
			break;
		case ParticleTypeSpiral:
			system = [CCParticleSpiral node];
			break;
		case ParticleTypeSun:
			system = [CCParticleSun node];
			break;
			
		default:
			// do nothing
			break;
	} */
    
    system = [CCParticleExplosion node];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	system.position = CGPointMake(winSize.width / 2, winSize.height / 2);
	[self addChild:system z:101 tag:7];
	
}



// Collision DETECTION

-(void) circleCollisionWith:(NSMutableArray *) circle2
{
    NSUInteger numSprites = [circle2 count];
    for (NSUInteger i = 0; i < numSprites; i++)
    {
        CCSprite *c = [circle2 objectAtIndex:i];
        //        [self circleCollisionWithSprite:c];
        
        float c1radius = playerWidth/2; //[circle1 boundingBox].size.width/2; // circle 1 radius
        // NSLog(@"Circle 1 Radius: %f", c1radius);
        float c2radius = [c boundingBox].size.width/2; // circle 2 radius
        //        float c2radius = c.contentSize.width/2;
        radii = c1radius + c2radius;
        float distX = player.position.x - c.position.x;
        float distY = player.position.y - c.position.y;
        distance = sqrtf((distX * distX) + (distY * distY));
        
        if (distance <= radii) { // did the two circles collide at all??
            //            [self circleCollisionWithSprite:c];
            float ratio = distY/distance; // ratio of distance in terms of Y to distance from player
            float shipAngleRadians = asin(ratio); // arcsin of ratio
            float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
            float shipAngle; // shipAngle
            
            if (antiShipAngle < 0.0f) {
                shipAngle = (-360 + (antiShipAngle));
            } else {
                shipAngle = antiShipAngle;
            }
            
            if (shipAngle < -360.0f) {
                [self removeChild:c cleanup:YES];
                //                NSLog(@"ERROR WITH SHIP GENERATION: DELETING AND RETRYING");
                //            [self initShips];
            }
            
            //            NSLog(@"Ship Angle %f", shipAngle);
            
            [self divideAngularSections];
            [self scoreCheck:shipAngle withColor:shipColor];
            
            if (distance < radii) {
                c.visible = false;
                [self removeChild:c cleanup:YES];
                [circle2 removeObjectAtIndex:i];
            }
            
            //            NSLog(@"HIT");
            c.visible = false;
            [self removeChild:c cleanup:YES];
            [circle2 removeObjectAtIndex:i];
        }
    }
    
}






-(void) circleCollisionWithSprite:(CCSprite *)circle1 andThis:(CCSprite *) circle2
{
    //        CCSprite *c = [circle2 objectAtIndex:i];
    //        [self circleCollisionWithSprite:c];
    //        [self doubleCheckCollisions:c];
    
    float c1radius = playerWidth/2; //[circle1 boundingBox].size.width/2; // circle 1 radius
    // NSLog(@"Circle 1 Radius: %f", c1radius);
    float c2radius = [circle2 boundingBox].size.width/2; // circle 2 radius
    //        float c2radius = c.contentSize.width/2;
    radii = c1radius + c2radius;
    float distX = circle1.position.x - circle2.position.x;
    float distY = circle1.position.y - circle2.position.y;
    distance = sqrtf((distX * distX) + (distY * distY));
    
    //            [self circleCollisionWithSprite:c];
    
    //    if (antiShipAngle < 0.0f) {
    //        shipAngle = (-360 + (antiShipAngle));
    //    } else {
    //        shipAngle = antiShipAngle;
    //    }
    
    
    if (distance <= radii) { // did the two circles collide at all??
        //        if (shipAngle < -360.0f) {
        //            [self removeChild:circle2 cleanup:YES];
        //            [self initShips];
        //        } else {
        
        
        float ratio = distY/distance; // ratio of distance in terms of Y to distance from player
        float shipAngleRadians = asin(ratio); // arcsin of ratio
        float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
        //    float shipAngle; // shipAngle
        
        CGPoint pos1 = [circle2 position];
        CGPoint pos2 = [player position];
        
        float theta = atan((pos1.y-pos2.y)/(pos1.x-pos2.x)) * 180 / M_PI;
        
        float shipAngle;
        
        if(pos1.y - pos2.y > 0)
        {
            if(pos1.x - pos2.x < 0)
            {
                shipAngle = (-90-theta);
            }
            else if(pos1.x - pos2.x > 0)
            {
                shipAngle = (90-theta);
            }
        }
        else if(pos1.y - pos2.y < 0)
        {
            if(pos1.x - pos2.x < 0)
            {
                shipAngle = (270-theta);
            }
            else if(pos1.x - pos2.x > 0)
            {
                shipAngle = (90-theta);
            }
        }
        
        if (shipAngle < 0)
        {
            shipAngle+=360;
        }
        
        shipAngle = shipAngle;
        
        
        
        
        [self divideAngularSections];
        numCollisions++;
        NSLog(@"%f", shipAngle);
        NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
        NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
        NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
        NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
        NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
        NSLog(@"Section 3 EndAngle: %f", section3EndAngle);
        [self scoreCheck:shipAngle withColor:shipColor];
        
        collisionDidHappen = true;
        
        if (playerLives == 0) {
            [self removeChild:circle2 cleanup:YES];
            [self initShips];
            //            warning = true;
            [self gameOver];
        } else {
            id dock = [CCScaleTo actionWithDuration:0.2f scale:0];
            id removeSprite = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            [circle2 runAction:[CCSequence actions:dock, removeSprite, nil]];
//            [self removeChild:circle2 cleanup:YES];
            [self initShips];
        }
        
        /* if ((numCollisions - playerScore) > playerLives - 2) {
         [self removeChild:circle2 cleanup:YES];
         [self initShips];
         //            warning = true;
         [self gameOver];
         } else if ((numCollisions - playerScore) > playerLives - 1) {
         [self removeChild:circle2 cleanup:YES];
         warning = false;
         [self gameOver]; // GAME OVER
         } else {
         [self removeChild:circle2 cleanup:YES];
         [self initShips];
         }
         //        } */
    }
}

-(void) removeSprite:(id)sender
{
    NSLog(@"SPRITE REMOVED");
    [self removeChild:sender cleanup:YES];
}

-(void) scoreCheck:(int) angle withColor: (int) color
{
    if (shipColor == 1)
    {
        //        if (section1StartAngle > section1EndAngle) {
        [self divideAngularSections];
        if (angle > section1StartAngle && angle < section1EndAngle) {
            playerScore = playerScore + scoreAdd;
        } else if (section1StartAngle > section1EndAngle) {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
        } else {
            playerLives = playerLives - livesSubtract;
            [self divideAngularSections];
            
        }
        
        
        //            if (angle < section1StartAngle && angle > section1EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        
        //        }
        
        
        
        
        //        }
        //        if (section1StartAngle < section1EndAngle) {
        //            [self divideAngularSections];
        //            if (angle > section1StartAngle && angle < section1EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        //        }
        
    }
    else if (shipColor == 2)
    {
        [self divideAngularSections];
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            playerScore = playerScore + scoreAdd;
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
        } else {
            playerLives = playerLives - livesSubtract;
            [self divideAngularSections];
        }
        
        
        //            if (angle < section2StartAngle && angle > section2EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        
        
        
        //        }
        //        if (section2StartAngle < section2EndAngle) {
        //            [self divideAngularSections];
        //            if (angle > section2StartAngle && angle < section2EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        //        }
        
    } else if (shipColor == 3) {
        [self divideAngularSections];
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            playerScore = playerScore + scoreAdd;
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                playerScore = playerScore + scoreAdd;
            }
        } else {
            playerLives = playerLives - livesSubtract;
            [self divideAngularSections];
        }
        
        //            if (angle < section3StartAngle && angle > section3EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        
        
        
        //        if (section3StartAngle < section3EndAngle) {
        //            [self divideAngularSections];
        //            if (angle > section3StartAngle && angle < section3EndAngle) {
        //                playerScore = playerScore + 1;
        //            } else {
        //                // carry on with checking for collisions
        //                [self divideAngularSections];
        //            }
        //        }
        
    }
}


-(void) infiniteBorderCollisionWith:(CCSprite *) shipToCollideWith
{
    float c1radius = [infiniteBorderPowerUp1 boundingBox].size.width/2; // circle 1 radius
    // NSLog(@"Circle 1 Radius: %f", c1radius);
    float c2radius = [shipToCollideWith boundingBox].size.width/2; // circle 2 radius
    //        float c2radius = c.contentSize.width/2;
    float cradii = c1radius + c2radius;
    float distX = infiniteBorderPowerUp1.position.x - shipToCollideWith.position.x;
    float distY = infiniteBorderPowerUp1.position.y - shipToCollideWith.position.y;
    float cdistance = sqrtf((distX * distX) + (distY * distY));
    
    if (cdistance <= cradii) {
        playerScore = playerScore + scoreAdd;
        id dockInfin = [CCFadeTo actionWithDuration:0.1f opacity:0];
        id removeSpriteInfin = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
        [shipToCollideWith runAction:[CCSequence actions:dockInfin, removeSpriteInfin, nil]];
//        [self removeChild:shipToCollideWith cleanup:YES];
        [self initShips];
    }
}

// INITIALIZE SHIPS AND POWERUPS

-(void) enablePowerUp1
{
    // powerup that allows any ship to go ANYWHERE on the player and still grant points
    if (numPower1Left > 0) {
        [self flashLabel:@"ENERGY SHIELD UP" forTime:5.0f];
        id addBorder = [CCCallFunc actionWithTarget:self selector:@selector(addInfiniteBorder)];
        id delayRemoval = [CCDelayTime actionWithDuration:5.0f];
        id removeBorder = [CCCallFunc actionWithTarget:self selector:@selector(removeInfiniteBorder)];
        CCSequence *powerUp1Seq = [CCSequence actions:addBorder, delayRemoval, removeBorder, nil];
        numPower1Left--;
        [self runAction:powerUp1Seq];
    } else {
        // do nothing
    }

}

-(void) addInfiniteBorder
{
    infiniteBorderPowerUp1.scale = 1.3f;
    [self addChild:infiniteBorderPowerUp1 z:-10 tag:50];
}

-(void) removeInfiniteBorder
{
    infiniteBorderPowerUp1.scale = 0;
    [self removeChild:infiniteBorderPowerUp1 cleanup:YES];
}


-(void) enablePowerUp2
{
    if (numPower2Left > 0) {
    id stopShip = [CCCallFunc actionWithTarget:self selector:@selector(shipPauseAllActions)];
    id delayShip = [CCDelayTime actionWithDuration:1.5f];
    id resumeShip = [CCCallFunc actionWithTarget:self selector:@selector(shipResumeAllActions)];
    CCSequence *powerUp2Seq = [CCSequence actions:stopShip, delayShip, resumeShip, nil];
    numPower2Left -= 1;
    [self runAction:powerUp2Seq];
    } else {
        // do nothing
    }

}


-(void) enablePowerUp3
{
    if (numPower3Left > 0) {
        id removeEffect = [CCFadeOut actionWithDuration:0.2f];
        id removeSpriteForP3 = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
        [ship1 runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
//    [self removeChild:ship1 cleanup:YES];
    [self unscheduleUpdate];
    [self initShips];
    numPower3Left -= 1;
    [self scheduleUpdate];
    } else {
        // do nothing
    }
}


-(void) shipPauseAllActions
{
    [ship1 pauseSchedulerAndActions];
}

-(void) shipResumeAllActions
{
    [ship1 resumeSchedulerAndActions];
}


-(void) addPowerup1
{
    powerUp1 = [[CCSprite alloc] init];
    powerUp1 = [CCSprite spriteWithFile:@"section1.png"];
    powerUp1.scale = 0.2f;
    powerUp1.position = ccp(powerUpCreator1.position.x, powerUpCreator1.position.y + 30);
    [self addChild:powerUp1 z:20];
    [powerUpType1 addObject:powerUp1];
}

-(void) addPowerup2
{
    powerUp2 = [[CCSprite alloc] init];
    powerUp2 = [CCSprite spriteWithFile:@"section2.png"];
    powerUp2.scale = 0.2f;
    powerUp2.position = ccp(powerUpCreator2.position.x, powerUpCreator2.position.y + 30);
    [self addChild:powerUp2 z:20];
    [powerUpType2 addObject:powerUp2];
}

-(void) addPowerup3
{
    powerUp3 = [[CCSprite alloc] init];
    powerUp3 = [CCSprite spriteWithFile:@"section3.png"];
    powerUp3.scale = 0.2f;
    powerUp3.position = ccp(powerUpCreator3.position.x, powerUpCreator3.position.y + 30);
    [self addChild:powerUp3 z:20];
    [powerUpType3 addObject:powerUp3];
}


-(void) pickColor
{
    int color = (arc4random()%(3-1+1))+1;
    shipColor = color;
}


-(void) initSect1Ships
{
 	int numShips1 = 1;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section1Ships == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section1Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips1; i++)
	{
		// Creating a spider sprite, positioning will be done later
		ship1 = [CCSprite spriteWithFile:@"section1.png"];
        ship1.scale = 0.15f;
		[self createShipCoord:ship1];
        [self addChild:ship1 z:50 tag:100];
		
		// Also add the spider to the spiders array so it can be accessed more easily.
		[section1Ships addObject:ship1];
        [self moveShip:ship1];
	}
}

-(void) initSect2Ships
{
 	int numShips2 = 1;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section2Ships  == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section2Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips2; i++)
	{
		// Creating a spider sprite, positioning will be done later
		ship2 = [CCSprite spriteWithFile:@"section2.png"];
        ship2.scale = 0.15f;
        [self createShipCoord:ship2];
		[self addChild:ship2 z:50 tag:200];
		
		// Also add the spider to the spiders array so it can be accessed more easily.
		[section2Ships addObject:ship2];
        [self moveShip:ship2];
	}
}

-(void) initSect3Ships
{
 	int numShips3 = 1;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section3Ships == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section3Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips3; i++)
	{
		// Creating a spider sprite, positioning will be done later
		ship3 = [CCSprite spriteWithFile:@"section3.png"];
        ship3.scale = 0.15f;
        [self createShipCoord:ship3];
		[self addChild:ship3 z:50 tag:300];
		
		// Also add the spider to the spiders array so it can be accessed more easily.
		[section3Ships addObject:ship3];
        [self moveShip:ship3];
	}
}

-(void) initShips
{
    [self pickColor];
    if (shipColor == 1) {
        ship1 = [CCSprite spriteWithFile:@"ship1.png"];
        ship1.scale = 0.15;
        //        [self initSect1Ships];
    }
    
    if (shipColor == 2) {
        ship1 = [CCSprite spriteWithFile:@"ship2.png"];
        ship1.scale = 0.15;
        //        [self initSect2Ships];
    }
    
    if (shipColor == 3) {
        ship1 = [CCSprite spriteWithFile:@"ship3.png"];
        ship1.scale = 0.15;
        //        [self initSect3Ships];
    }
    
    [self createShipCoord:ship1]; // create coordinate for ship to spawn to
    [self moveShip:ship1];
}


-(void) moveShip:(CCSprite *) shipToMove
{
    shipMove = [CCMoveTo actionWithDuration:shipSpeed position:screenCenter]; // initialize the action to run when the ship is appeneded to the layer
    [shipToMove runAction:shipMove]; // run the action initialized
}

-(void) createShipCoord:(CCSprite *)shipForCoord
{
    // Temporary way of generating random coordinates to spawn to
    int fromNumber = -160;
    int toNumber = 480;
    
    int topBottomChoose = (arc4random()%(2-1+1))+1;
    
    if (topBottomChoose == 1) {
        shipRandY = 500;
    } else {
        shipRandY = -20;
    }
    
    shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//    shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    
//    if (shipRandX < 320) {
//        shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//    }
    
//    if (shipRandY < 480) {
//        shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//    }
    
//    if (shipRandX < 320 && shipRandY < 480) {
//        shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//        shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//    }
    
//    while (shipRandY < 280 && shipRandY > 200) {
//        shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//        shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
//    }
    
    shipForCoord.position = ccp(shipRandX, shipRandY);
    [self addChild:shipForCoord z:7];
}


// METHODS THAT MUST RUN EVERY FRAME
-(void) updateScore
{
    score = [[NSString alloc] initWithFormat:@"Score: %i",playerScore];
    [scoreLabel setString:score];
    lives = [[NSString alloc] initWithFormat:@"Lives: %i",playerLives];
    [liveLabel setString:lives];
    
    power1Num = [[NSString alloc] initWithFormat:@"%i",numPower1Left];
    [power1Left setString:power1Num];
    
    power2Num = [[NSString alloc] initWithFormat:@"%i",numPower2Left];
    [power2Left setString:power2Num];
    
    power3Num = [[NSString alloc] initWithFormat:@"%i",numPower3Left];
    [power3Left setString:power3Num];
    
    sharedScore = [NSNumber numberWithInteger:playerScore];
    [[NSUserDefaults standardUserDefaults] setObject:sharedScore forKey:@"sharedScore"];
    
    if (warning == true) {
        warningLabel.visible = true;
        //        [warningLabel runAction:[CCFadeIn actionWithDuration:0.5]];
    } else {
        //        [warningLabel runAction:[CCFadeOut actionWithDuration:0.5f]];
        warningLabel.visible = false;
    }
}

-(void) divideAngularSections
{
    float normalizedStart1Ang = player.rotation;
    if (normalizedStart1Ang > 360.0f) {
        normalizedStart1Ang-=360;
    }
    
    float normalizedEnd1Ang = player.rotation + 120;
    if (normalizedEnd1Ang > 360.0f) {
        normalizedEnd1Ang-=360;
    }
    
    section1StartAngle = normalizedStart1Ang; //120 + player.rotation;
    section1EndAngle = normalizedEnd1Ang;
    section2StartAngle = normalizedEnd1Ang;
    
    float normalizedEnd2Ang = normalizedEnd1Ang + 120;
    if (normalizedEnd2Ang > 360.0f) {
        normalizedEnd2Ang-=360;
    }
    
    section2EndAngle = normalizedEnd2Ang;
    section3StartAngle = normalizedEnd2Ang; // the line below's problem applies to this line
    section3EndAngle = normalizedStart1Ang; // right now does not work for some reason
    //    [self normalizeAngle:section1StartAngle];
    //    [self normalizeAngle:section1EndAngle];
    //    [self normalizeAngle:section2StartAngle];
    //    [self normalizeAngle:section2EndAngle];
    //    [self normalizeAngle:section3StartAngle];
    //    [self normalizeAngle:section3EndAngle];
    
    
    //       NSLog(@"%f", player.rotation);
    //     NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
    //     NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
    //     NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
    //     NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
    //     NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
    //     NSLog(@"Section 3 EndAngle: %f", section3EndAngle);
}

-(void) normalizeAngle:(float) angleInput
{
    while (angleInput > 360) {
        angleInput = angleInput - 360;
    }
}

-(void) handleUserInput
{
//    int timesPowerUp1enabled = 0;
    
    KKInput *input = [KKInput sharedInput];
    input.multipleTouchEnabled = true;
    CGPoint pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];

    if(pos.x != 0 && pos.y != 0)
    {
        [self divideAngularSections];
        //        player.rotation = ((pos.x/360)*360) * (-1);
        float distX = pos.x - screenCenter.x;
        float distY = pos.y - screenCenter.y;
        float touchDistance = sqrtf((distX * distX) + (distY * distY));
        
        //            [self circleCollisionWithSprite:c];
        float ratio = distY/touchDistance; // ratio of distance in terms of Y to distance from player
        float shipAngleRadians = asin(ratio); // arcsin of ratio
        float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
        //        float rotation = antiShipAngle; // shipAngle
        
        CGPoint rot_pos1 = [player position];
        CGPoint rot_pos2 = pos;
        
        CGPoint circle_pos1 = [player position];
        CGPoint circle_pos2 = pos;
        
        //    rot_pos1 = [player position];
        //    rot_pos2 = posOfTouch;
        
        float rotation_theta = atan((rot_pos1.y-rot_pos2.y)/(rot_pos1.x-rot_pos2.x)) * 180 / M_PI;
        
        //        float rotation;
        
        if(rot_pos1.y - rot_pos2.y > 0)
        {
            if(rot_pos1.x - rot_pos2.x < 0)
            {
                rotation = (-90-rotation_theta);
            }
            else if(rot_pos1.x - rot_pos2.x > 0)
            {
                rotation = (90-rotation_theta);
            }
        }
        else if(rot_pos1.y - rot_pos2.y < 0)
        {
            if(rot_pos1.x - rot_pos2.x < 0)
            {
                rotation = (270-rotation_theta);
            }
            else if(rot_pos1.x - rot_pos2.x > 0)
            {
                rotation = (90-rotation_theta);
            }
        }
        
        if (rotation < 0)
        {
            rotation+=360;
        }
        
        /*float circle_theta = atan((circle_pos1.y-circle_pos2.y)/(circle_pos1.x-circle_pos2.x)) * 180 / M_PI;
        
        //        float rotation;
        
        if(circle_pos1.y - circle_pos2.y > 0)
        {
            if(circle_pos1.x - circle_pos2.x < 0)
            {
                circle_rotation = (-90-circle_theta);
            }
            else if(circle_pos1.x - circle_pos2.x > 0)
            {
                circle_rotation = (90-circle_theta);
            }
        }
        else if(circle_pos1.y - circle_pos2.y < 0)
        {
            if(circle_pos1.x - circle_pos2.x < 0)
            {
                circle_rotation = (270-circle_theta);
            }
            else if(circle_pos1.x - circle_pos2.x > 0)
            {
                circle_rotation = (90-circle_theta);
            }
        }
        
        if (circle_rotation < 0)
        {
            circle_rotation+=360;
        }

        NSLog(@"Circle's Rotation: %f", circle_rotation); */
//        [self normalizeThisToStandards:rotation_pos1 andThis:rotation_pos2 withRotVariable:rotation];
        
    
        float diff = (lastTouchAngle-rotation) * (-1);
    
//        NSLog(@"Rotation: %f", rotation);
        
        if (!input.anyTouchBeganThisFrame) {
//            NSLog(@"LastTouchAngle: %f", lastTouchAngle);
//            NSLog(@"Rotation: %f", rotation);
//            NSLog(@"Diff: %f", diff);
            player.rotation += diff; // was originally player.rotation += diff
            if (player.rotation < 0) {
                player.rotation = player.rotation + 360.f;
            }
            
            if (player.rotation > 360) {
                player.rotation -= 360;
            }
            
            NSLog(@"Player Rotation: %f", player.rotation);
        }
    
        lastTouchAngle = rotation;
        
        
//        NSLog(@"Rotation %f", player.rotation);
//        player.rotation = rotation; // for now until the code above gets fixed
//        [player runAction:[CCRotateTo actionWithDuration:0.1f angle:rotation]];
        
//        player.rotation = rotation;
        
//        NSLog(@"%f", player.rotation);
        [self divideAngularSections];
        
    
 /*        if ([input isAnyTouchOnNode:powerUp1 touchPhase:KKTouchPhaseAny]) {
         CGPoint powerUp1Pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
         powerUp1.position = powerUp1Pos;
         }
  
         if ([input isAnyTouchOnNode:powerUp2 touchPhase:KKTouchPhaseAny]) {
         CGPoint powerUp2Pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
         powerUp2.position = powerUp2Pos;
         }
         
         if ([input isAnyTouchOnNode:powerUp3 touchPhase:KKTouchPhaseAny]) {
         CGPoint powerUp3Pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
         powerUp3.position = powerUp3Pos;
         } */
        
        
        // PAUSE BUTTON
        if ([input isAnyTouchOnNode:pauseButton touchPhase:KKTouchPhaseAny]) {

            [self pauseGame];
            
        }
    }
}

-(void) normalizeThisToStandards:(CGPoint) rot_pos1 andThis:(CGPoint) rot_pos2 withRotVariable:(float) rotationVar
{

}

-(void) initChallenges
{
    // speed challenge
    if (playerScore > 6) {
        shipSpeed = 3.5f;
    }
    
    if (playerScore > 9) {
        shipSpeed = 2.0f;
    }
    
    if (playerScore > 10) {
        shipSpeed = 3.7f;
    }
    
    if (playerScore > 15) {
        shipSpeed = 2.8f;
    }
    
    if (playerScore > 19) {
        shipSpeed = 1.5f;
    }
    
    if (playerScore > 20) {
        shipSpeed = 2.2f;
    }
    
    if (playerScore > 29) {
        shipSpeed = 2.0f;
    }
    
    // 
}

-(void) initMenuItems
{
    
}

-(void) flashLabel:(NSString *) stringToFlashOnScreen forTime:(float) numSecondsToFlash
{
    [screenflashLabel setString:stringToFlashOnScreen];
    id addVisibility = [CCCallFunc actionWithTarget:self selector:@selector(makeFlashLabelVisible)];
    id delayInvis = [CCDelayTime actionWithDuration:numSecondsToFlash];
    id addInvis = [CCCallFunc actionWithTarget:self selector:@selector(makeFlashLabelInvisible)];
    CCSequence *flashLabelSeq = [CCSequence actions:addVisibility, delayInvis, addInvis, nil];
    [self runAction:flashLabelSeq];
}

-(void) makeFlashLabelVisible
{
    screenflashLabel.visible = true;
}

-(void) makeFlashLabelInvisible
{
    screenflashLabel.visible = false;
}

-(void) goToGameOver
{
    [ship1 stopAction:shipMove]; // stop any currently moving ships to avoid the explosion from happening twice
    id particleEffects = [CCCallFunc actionWithTarget:self selector:@selector(runEffect)];
    id effectDelay = [CCDelayTime actionWithDuration:2.4f];
    id goToScene = [CCCallFunc actionWithTarget:self selector:@selector(transferToGameOverScene)];
    [self removeChild:player cleanup:YES];
    [self removeChild:ship1 cleanup:YES];
    CCSequence *gameOverSequence = [CCSequence actions:particleEffects, effectDelay, goToScene, nil];
    
    // execute the sequence
    [self runAction:gameOverSequence]; // delay
}

-(void) transferToGameOverScene
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[GameOver node]]];
//    [[CCDirector sharedDirector] replaceScene: [GameOver node]];
}

-(void) resetVariables
{
    gameOver = false;
    // reset all game variables
    shipSpeed = 4.8f; // default speed
    playerScore = 0;
    playerLives = 5;
    framesPassed = 0;
    secondsPassed = 0;
    numCollisions = 0;
    livesSubtract = 1;
    scoreAdd = 1;
    
    numPower1Left = 1;
    numPower2Left = 5;
    numPower3Left = 5;
    
    warning = false;
    collisionDidHappen = false;
    
    NSNumber *curHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
    playerHighScore = [curHighScore intValue]; // read from the devices memory
}

-(void) gameOver
{
    gameOver = true;
    if (playerHighScore == 0) {
        playerHighScore = playerScore;
        sharedHighScore = [NSNumber numberWithInteger:playerHighScore];
        [[NSUserDefaults standardUserDefaults] setObject:sharedHighScore forKey:@"sharedHighScore"];
//        [MGWU setObject:sharedHighScore forKey:@"sharedHighScore"];
    }
    
    if (playerScore > playerHighScore) {
        playerHighScore = playerScore;
        sharedHighScore = [NSNumber numberWithInteger:playerHighScore];
        [[NSUserDefaults standardUserDefaults] setObject:sharedHighScore forKey:@"sharedHighScore"];
//        [MGWU setObject:sharedHighScore forKey:@"sharedHighScore"];
    }
    
//    NSNumber *savedHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
//    NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    [MGWU submitHighScore:[savedHighScore intValue] byPlayer:savedUser forLeaderboard:@"defaultLeaderboard"];
    
    [self goToGameOver];
}

-(void) pauseGame
{
    [[CCDirector sharedDirector] pushScene:
	 [CCTransitionCrossFade transitionWithDuration:0.5f scene:[PauseLayer node]]];
}

-(void)update:(ccTime)dt // update method
{
    collisionDidHappen = false;
    framesPassed++;
    secondsPassed = framesPassed/60; // divide by framerate;
//     if ((framesPassed % 100) == 0) {
//            NSLog(@"New Ship Generated!");
//        [self initShips];
//    } else {
//     do nothing
//     }
    [self divideAngularSections];
    [self circleCollisionWithSprite:player andThis:ship1];
    [self infiniteBorderCollisionWith:ship1];
    //    [self circleCollisionWith:section2Ships];
    //    [self circleCollisionWith:section3Ships];
    [self handleUserInput];
    [self divideAngularSections];
    //    [self normalizeAngle:section1StartAngle];
    //    [self normalizeAngle:section1EndAngle];
    //    [self normalizeAngle:section2StartAngle];
    //    [self normalizeAngle:section2EndAngle];
    //    [self normalizeAngle:section3StartAngle];
    //    [self normalizeAngle:section3EndAngle];
    [self updateScore];
    [self initChallenges];
}

@end
