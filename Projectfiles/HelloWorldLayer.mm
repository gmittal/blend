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
 - PHYSICS FOR USER INPUT (MAKE THE PLANET HAVE A MORE FLUID SPIN, MUCH LIKE A WHEEL, OPTIONAL)
 - LEADERBOARDS (IMPLEMENTED)
 - HAVE A 'SWEET-SPOT' WHICH GETS ENABLED EVERY ONCE IN A WHILE WHERE IF THE USER LANDS THE SHIP THERE, THEY GET BONUS POINTS
 - (NEW POSSIBLE GAMEPLAY FEATURE): HAVE THE USER COAT THE OUTSIDE OF THE BALL WITH SHIPS TO PROCEED TO THE NEXT ROUND
 - HAVE A SHAPE ASSOCIATED WITH EACH COLOR AND IF THE SHAPE AND COLOR OF THE SHIP MATCHES THE SECTOR, THEN GRANT EXTRA POINTS
 */

/* SHAPES ASSOSCIATED WITH COLORS
 - RED = SQUARE
 - BLUE = HEXAGON
 - YELLOW = TRIANGLE
 */

/*
 POWERUP IDEAS:
 - ENERGY SHEILD (IMPLEMENTED, POWERUP1)
 - PAUSE POWER (IMPLEMENTED, POWERUP2)
 - DESTROY SHIP POWER (IMPLEMENTED, POWERUP3)
 
 (4) E - SLOW MOTION POWER
 (3) I - WORLD SPlITS INTO 2 COLORS FOR A CERTAIN AMOUNT OF TIME
 - COLORS BECOME INVERSE (RED GOES TO BLUE, BLUE TO YELLOW, YELLOW TO RED)
 (2) E - SUICIDE POWERUP (BLOW EVERYTHING UP)
 - ATMOSPHERE POWERUP (certain section can be broken by each ship collision, but the rest of the section will remain intact)
 - MORE SECTIONS POWERUP (creates more colored sections on the middle wheel)
 (3) A - UNLEASH MONSTER POWERUP (releases monster that shoots ships, redirecting to a minigame where you shoot ships)
 (3) I - STORE POWER (buy anything midway through a game, but with limited time)
 (2) E - MUSIC MODE (play music to increase focus and coordination)
 (1) I - NEGATIVE COLOR MODE (inverts the colors on screen)
 (3) I - GOLF MODE (try and get the most ships into the wrong sectors as possible)
 (3) E - POINT BOOST (any ship that collides with the player will grant some extra number of points)
 (2) I - RED SHIP BOOST (only creates red ships for some amount of time)
 (2) I - BLUE SHIP BOOST (only creates blue ships for some amount of time)
 (2) I - YELLOW SHIP BOOST (only creates yellow ships for some amount of time)
 (2) E - LIVES BOOST (gain lives every time a ship correctly lands into a sector)
 (2) E - CHANGE THE DEATH OF THE PLANET (change the death of the planet randomly, will it explode? will it melt? will it burn?)
 (3) E - ZOMBIE PLANET (right before death, activate powerup to ressurect the planet and give you an additional life)
 (1) A - KATAMARI PLANET (enable this powerup to allow any ship that collides with the planet to add on to the ships mass for a certain amount of time)
 - INVERSE STEERING (does what its name claims)
 (1) E/I - BOUNCE OFF POWERUP (all ships that collide with the planet bounce off)
 */

/*
 PROJECTILE IDEAS:
 - MAGENTA SHIP (IMPLEMENTED, SHPIP1)
 - BLUE SHIP (IMPLEMENTED, SHIP2)
 - YELLOW SHIP (IMPLEMENTED, SHIP3)
 - BAG OF COINS: GIVES USER 10 COINS IF PLACED IN CORRECT SECTOR
 */



#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

@interface HelloWorldLayer (PrivateMethods)
@end

@implementation HelloWorldLayer

-(id) init
{
	if ((self = [super init]))
	{
        // initialize game variables
		glClearColor(0.32, 0.46, 0.73, 1.0); // default background color
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
        [self addChild:player z:20];
        //        [player runAction:explode];
        
        section1 = [CCSprite spriteWithFile:@"element1.png"];
        progressBar1 = [CCProgressTimer progressWithSprite:section1];
        progressBar1.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar1 z:21];
        progressBar1.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //        [progressBar1 setAnchorPoint:zero];
        progressTo1 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        section2 = [CCSprite spriteWithFile:@"element2.png"];
        progressBar2 = [CCProgressTimer progressWithSprite:section2];
        progressBar2.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar2 z:21];
        progressBar2.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar2.rotation = 120.0f;
        progressTo2 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        section3 = [CCSprite spriteWithFile:@"element3.png"];
        progressBar3 = [CCProgressTimer progressWithSprite:section3];
        progressBar3.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar3 z:21];
        progressBar3.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar3.rotation = 240.0f;
        progressTo3 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        
        [progressBar1 runAction:progressTo1];
        [progressBar2 runAction:progressTo2];
        [progressBar3 runAction:progressTo3];
        
        // score label
        score = [[NSString alloc]initWithFormat:@"%i", playerScore];
        scoreLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:25];
        scoreLabel.position = ccp(45, size.height - 19);
        scoreLabel.color = ccc3(0,0,0);
        scoreLabel.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:scoreLabel z:1001];
        
        // lives label
        lives = [[NSString alloc]initWithFormat:@"Lives: %i", playerLives];
        liveLabel = [CCLabelTTF labelWithString:lives fontName:@"HelveticaNeue-Light" fontSize:25];
        liveLabel.position = ccp(size.width/2, 435);
        liveLabel.color = ccc3(0,0,0);
        //        [self addChild:liveLabel z:100];
        
        
        /*    lifeBarBorder = [CCSprite spriteWithFile:@"healthbarBorder.png"];
         lifeBarBorder.position = ccp(screenCenter.x, size.height - 15);
         [self addChild:lifeBarBorder];
         
         lifeBarSprite = [CCSprite spriteWithFile:@"healthBarFill.png"];
         lifeBar = [CCProgressTimer progressWithSprite:lifeBarSprite];
         lifeBar.type = kCCProgressTimerTypeBar;
         [lifeBarBorder addChild:lifeBar z:2];
         lifeBar.position = ccp(size.width/2, size.height/2 - 15);
         //   [progressBar2 setAnchorPoint:zero];
         //        progressBar3.rotation = 240.0f;
         lifeUpdater = [CCProgressTo actionWithDuration:1 percent:playerLives];
         [lifeBar runAction:lifeUpdater]; */
        
        lifeBarBorder = [CCSprite spriteWithFile: @"healthbarBorder.png"];
        lifeBarBorder.scale = 0.85f;
        [lifeBarBorder setPosition:ccp(screenCenter.x + 7, size.height - 20)];
//        [self addChild:lifeBarBorder z:1001];
        
        lifeBarSprite = [CCSprite spriteWithFile:@"healthbarFill.png"];
        lifeBar = [CCProgressTimer progressWithSprite:lifeBarSprite];
        lifeBar.scale = 0.85f;
        lifeBar.type = kCCProgressTimerTypeBar;
        lifeBar.position = ccp(52, size.height - 35);
        lifeBar.midpoint = ccp(0.f, 0.5f);
        //        lifeBar.midpoint = ccp(screenCenter.x, size.height - 20);
        lifeBar.barChangeRate = ccp(1,0);
//        [self addChild:lifeBar z:1002];
        [lifeBar setAnchorPoint: ccp(0,0)];
        lifeBar.percentage = 100;
        //        lifeUpdater = [CCProgressTo actionWithDuration:1 percent:100];
        //        [lifeBar runAction:lifeUpdater];
        
        
        // warning label
        warningLabel = [CCLabelTTF labelWithString:@"STATUS CRITICAL" fontName:@"Courier" fontSize:25];
        warningLabel.position = ccp(size.width/2, 435);
        warningLabel.color = ccc3(255,0,0);
        //        [self addChild:warningLabel z:100];
        
        // initialize arrays
        powerUpType1 = [[NSMutableArray alloc] init];
        powerUpType2 = [[NSMutableArray alloc] init];
        powerUpType3 = [[NSMutableArray alloc] init];
        
//        ship1 = [[CCSprite alloc] init];
//        ship1 = [CCSprite spriteWithFile:@"ship1.png"];
//        ship1.scale = 0.15f;
        
        ship2 = [[CCSprite alloc] init];
        ship2 = [CCSprite spriteWithFile:@"ship1.png"];
        ship2.scale = 0.15f;
        
        //        ship1.tag = spriteTagNum;
        
        powerUpCreator1 = [[CCMenuItemImage alloc] init];
        powerUpCreator1 = [CCMenuItemImage itemWithNormalImage:@"element1.png"
                                                 selectedImage: @"element1.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp1)];
        powerUpCreator1.scale = 0.15f;
        powerUpCreator1.position = ccp(size.width/3 - 70, 20);
        //        [self addChild:powerUpCreator1 z:5];
        
        powerUpCreator2 = [[CCMenuItemImage alloc] init];
        powerUpCreator2 = [CCMenuItemImage itemWithNormalImage:@"element2.png"
                                                 selectedImage: @"element2.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp2)];
        powerUpCreator2.scale = 0.15f;
        powerUpCreator2.position = ccp(size.width/2 - 20, 20);
        //        [self addChild:powerUpCreator2 z:5];
        
        powerUpCreator3 = [[CCMenuItemImage alloc] init];
        powerUpCreator3 = [CCMenuItemImage itemWithNormalImage:@"element3.png"
                                                 selectedImage: @"element3.png"
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
        [self addChild:pauseButton z:1001];
        
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
        
        screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:20];
        screenflashLabel.position = ccp(size.width/2, 405);
        screenflashLabel.color = ccc3(255,0,0);
        [self addChild:screenflashLabel z:110];
        screenflashLabel.visible = false;
        
        
        multiplierWrapper = [CCSprite spriteWithFile:@"multiplier_wrapper.png"];
        multiplierWrapper.position = ccp(15, size.height - 19);
        [self setDimensionsInPixelsOnSprite:multiplierWrapper width:50 height:50];
        [self addChild:multiplierWrapper z:scoreLabel.zOrder];
        
        multiplierString = [[NSString alloc] initWithFormat:@"x%i", pointMultiplier];
        multiplierLabel = [CCLabelTTF labelWithString:multiplierString fontName:@"Roboto-Light" fontSize:25];
        multiplierLabel.position = ccp(multiplierWrapper.position.x - 7, multiplierWrapper.position.y);
        multiplierLabel.color = ccc3(255,255,255);
        multiplierLabel.anchorPoint = ccp(0.0f,0.5f);
        [self addChild:multiplierLabel z:scoreLabel.zOrder+1];
        
        
        enemyShip1 = [[CCSprite alloc] init];
        enemyShip1 = [CCSprite spriteWithFile:@""];
        
        CCSprite *topBar = [CCSprite spriteWithFile:@"topbar.png"];
        topBar.position = ccp(screenCenter.x, size.height - 20);
        topBar.scaleX = 3.0f;
//        [self addChild:topBar z:1000];
        
        CCSprite *background = [CCSprite spriteWithFile:@"backgroundip5.png"];
        background.position = screenCenter;
//        [self addChild:background z:-100];
        
        
        [self divideAngularSections];
        
        //        [self pickArray];
        [self pickShape];
        [self initShips];
        
        // preload sound effects so that there is no delay when playing sound effect
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"click1.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gameover1.mp3"];

//        [self flashWithRed:0 green:0 blue:255 alpha:255 actionWithDuration:1.0f];
        
        [self scheduleUpdate]; // schedule the framely update
        
//        [self startTutorial]; // start the tutorial (if needed)
        
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


-(void) startTutorial
{
    [self flashLabel:@"Rotate the circle by /n moving your finger in a circle." actionWithDuration:5.0f font:@"spacera" fontSize:20 color:@"black"];
    [self flashLabel:@"Match the incoming projectiles /n into the correctly colored sectors." actionWithDuration:5.0f font:@"spacera" fontSize:20 color:@"black"];
    [self flashLabel:@"Use the powerups at /n the bottom for help in tough situations." actionWithDuration:5.0f font:@"spacera" fontSize:20 color:@"black"];
}




-(void) killGrass
{
    burnGrass = [CCParticleFire node];
	[progressBar3 addChild:burnGrass z:1001];
}

-(void) removeGrassEffect
{
    [progressBar3 removeChild:burnGrass];
}


-(void) killFire
{
    snuffedFire = [CCParticleSmoke node];
	[progressBar1 addChild:snuffedFire z:1001];
}

-(void) removeFireEffect
{
    [progressBar1 removeChild:snuffedFire];
}


-(void) killWater
{
    dryWater = [CCParticleSmoke node];
	[progressBar2 addChild:dryWater z:1001];
}

-(void) removeWaterEffect
{
    [progressBar2 removeChild:dryWater];
}

-(void) runDeathSeqOn:(NSString *) effectName
{
    if ([effectName isEqualToString:@"grass"] == true) {
    id execute = [CCCallFunc actionWithTarget:self selector:@selector(killGrass)];
    id delay = [CCDelayTime actionWithDuration:2.0f];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeGrassEffect)];
    CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
    [self runAction:deathSeq];
    }
    
    if ([effectName isEqualToString:@"fire"] == true) {
        id execute = [CCCallFunc actionWithTarget:self selector:@selector(killFire)];
        id delay = [CCDelayTime actionWithDuration:2.0f];
        id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeFireEffect)];
        CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
        [self runAction:deathSeq];
    }
    
    if ([effectName isEqualToString:@"water"] == true) {
        id execute = [CCCallFunc actionWithTarget:self selector:@selector(killWater)];
        id delay = [CCDelayTime actionWithDuration:2.0f];
        id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeWaterEffect)];
        CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
        [self runAction:deathSeq];
    }
}


-(void) runEffect
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"gameover1.mp3"];
	// remove any previous particle FX
    //	[self removeChildByTag:7 cleanup:YES];
	
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
    
    
	[self addChild:system z:101 tag:7]; // execute the explosion
	
}



// Collision DETECTION

-(void) circleCollisionWith:(NSMutableArray *) circle2
{
    
    for(NSUInteger i = 0; i < [circle2 count]; i++)
    {
        CCSprite* tempSprite = [circle2 objectAtIndex:i];
        [self infiniteBorderCollisionWith:tempSprite withObject:i];
        float c1radius = playerWidth/2; //[circle1 boundingBox].size.width/2; // circle 1 radius
        // NSLog(@"Circle 1 Radius: %f", c1radius);
        float c2radius = [tempSprite boundingBox].size.width/2; // circle 2 radius
        //        float c2radius = c.contentSize.width/2;
        radii = c1radius + c2radius;
        float distX = player.position.x - tempSprite.position.x;
        float distY = player.position.y - tempSprite.position.y;
        distance = sqrtf((distX * distX) + (distY * distY));
        
        
        if (distance <= radii) { // did the two circles collide at all??
            
            float ratio = distY/distance; // ratio of distance in terms of Y to distance from player
            float shipAngleRadians = asin(ratio); // arcsin of ratio
            float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
            //    float shipAngle; // shipAngle
            
            CGPoint pos1 = [tempSprite position];
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
//            NSLog(@"%f", shipAngle);
//            NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
//            NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
//            NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
//            NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
//            NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
//            NSLog(@"Section 3 EndAngle: %f", section3EndAngle);
            [self scoreCheck:shipAngle withSprite:tempSprite];
            
            collisionDidHappen = true;
            
            if (pointMultiplier == 0) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self removeChild:tempSprite cleanup:YES];
                [circle2 removeObjectAtIndex:i];
                [self gameOver];
                
            } else {
                
                id dock = [CCScaleTo actionWithDuration:0.2f scale:0];
                id removeSprite = [CCCallFuncN actionWithTarget:self selector:@selector(removeArraySprite:)];
                [tempSprite runAction:[CCSequence actions:dock, removeSprite, nil]];
                //            [self removeChild:circle2 cleanup:YES];
                [circle2 removeObjectAtIndex:i];
                //            [self initShips];
                //            numSpritesCollided++;
                //            if (numSpritesCollided > 2) {
                //            [circle2 runAction:[CCSequence actions:dock, removeSprite, nil]];
                //            [self initShips];
                //                numSpritesCollided = 0;
                //            }
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
//        [self scoreCheck:shipAngle withColor:shipColor];
        
        collisionDidHappen = true;
        
        if (playerLives == 0) {
            [self removeChild:circle2 cleanup:YES];
            [self initShips];
            //            warning = true;
            [self gameOver];
        } else {
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            id dock = [CCScaleTo actionWithDuration:0.2f scale:0];
            id removeSprite = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            [circle2 runAction:[CCSequence actions:dock, removeSprite, nil]];
            //            [self removeChild:circle2 cleanup:YES];
//            [self initShips];
            //            numSpritesCollided++;
            //            if (numSpritesCollided > 2) {
            //            [circle2 runAction:[CCSequence actions:dock, removeSprite, nil]];
            //            [self initShips];
            //                numSpritesCollided = 0;
            //            }
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

-(void) removeArraySprite:(id)sender
{
    NSLog(@"Array Count: %d", [section1Ships count]);
    [self removeChild:sender cleanup:YES];
    numSpritesCollided++;
//    if (numSpritesCollided == [section1Ships count]) {
//        numSpritesCollided = 0;
//        [self initShips];
//    }
    
    
    if ([section1Ships count] == 0) {
        numSpritesCollided = 0;
        [self initShips];
    }
    
}

-(void) removeSprite:(id)sender
{
    NSLog(@"SPRITE REMOVED");
    [self removeChild:sender cleanup:YES];
}


-(void) increaseMultiplier
{
    numHitsUntilNextMultiplier++;
    if (numHitsUntilNextMultiplier >= pointMultiplier) {
        numHitsUntilNextMultiplier = 0;
        pointMultiplier += 1;
    }
}


-(void) scoreCheck:(int) angle withSprite:(CCSprite *) spriteWithArray
{
    if (spriteWithArray.tag == 1)
    {
        [self divideAngularSections];
        
        if (angle > section1StartAngle && angle < section1EndAngle) {
            playerScore = playerScore + (scoreAdd * pointMultiplier);
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
            
        } else if (section1StartAngle > section1EndAngle) {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
                
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        }
    
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
        
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            pointMultiplier -= 1;
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
//                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
//                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
        }
    
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
//            playerScore = playerScore + (scoreAdd * pointMultiplier);
             [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"grass"];
            pointMultiplier -= 1;
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
//                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"grass"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
//                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"grass"];
                pointMultiplier -= 1;
            }
        } 
        
    }
    else if (spriteWithArray.tag == 2)
    {
        [self divideAngularSections];
        
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            playerScore = playerScore + (scoreAdd * pointMultiplier);
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        } 
        
        if (angle > section1StartAngle && angle < section1EndAngle)
        {
            //            playerScore = playerScore + (scoreAdd * pointMultiplier);
             [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"fire"];
            pointMultiplier -= 1;
        } else if (section1StartAngle > section1EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"fire"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"fire"];
                pointMultiplier -= 1;
            }
        }
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            //            playerScore = playerScore + (scoreAdd * pointMultiplier);
             [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            pointMultiplier -= 1;
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
        }
        

        
        
    } else if (spriteWithArray.tag == 3) {
        [self divideAngularSections];
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            playerScore = playerScore + (scoreAdd * pointMultiplier);
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                playerScore = playerScore + (scoreAdd * pointMultiplier);
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        }
        
        if (angle > section1StartAngle && angle < section1EndAngle)
        {
            //            playerScore = playerScore + (scoreAdd * pointMultiplier);
             [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            pointMultiplier -= 1;
        } else if (section1StartAngle > section1EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                pointMultiplier -= 1;
            }
        }
        
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            //            playerScore = playerScore + (scoreAdd * pointMultiplier);
             [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"water"];
            pointMultiplier -= 1;
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"water"];
                pointMultiplier -= 1;
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                //                playerScore = playerScore + (scoreAdd * pointMultiplier);
                 [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"water"];
                pointMultiplier -= 1;
            }
        }
        
    }
}


-(void) infiniteBorderCollisionWith:(CCSprite *) shipToCollideWith withObject:(int) index
{
    float c1radius = [infiniteBorderPowerUp1 boundingBox].size.width/2; // circle 1 radius
    float c2radius = [shipToCollideWith boundingBox].size.width/2; // circle 2 radius
    //        float c2radius = c.contentSize.width/2;
    float cradii = c1radius + c2radius;
    float distX = infiniteBorderPowerUp1.position.x - shipToCollideWith.position.x;
    float distY = infiniteBorderPowerUp1.position.y - shipToCollideWith.position.y;
    float cdistance = sqrtf((distX * distX) + (distY * distY));
    
    if (cdistance <= cradii) {
        id dockInfin = [CCFadeTo actionWithDuration:0.1f opacity:0];
        id grantPoints = [CCCallFunc actionWithTarget:self selector:@selector(addInfiniteArrayPoints)];
        id removeSpriteInfin = [CCCallFuncN actionWithTarget:self selector:@selector(removeArraySprite:)];
        [shipToCollideWith runAction:[CCSequence actions:dockInfin, grantPoints, removeSpriteInfin, nil]];
        [section1Ships removeObjectAtIndex:index];
        //        [self removeChild:shipToCollideWith cleanup:YES];
        //        [self initShips];
    }
}

-(void) addInfiniteArrayPoints
{
    playerScore = playerScore + (scoreAdd * pointMultiplier);
    [self increaseMultiplier];
}

-(void) removeInfiniteArraySprite:(id) sender
{
    //    NSLog(@"SPRITE REMOVED");
    playerScore += scoreAdd;
    [self removeChild:sender cleanup:YES];
    numSpritesCollidedWithShield++;
//    if (numSpritesCollidedWithShield == [section1Ships count]) {
//        numSpritesCollidedWithShield = 0;
//        [self removeInfiniteBorder];
//        [self initShips];
//    }
    
    if ([section1Ships count] == 0) {
        numSpritesCollided = 0;
        [self initShips];
    }
    
}

// INITIALIZE SHIPS AND POWERUPS

-(void) enablePowerUp1
{
    // powerup that allows any ship to go ANYWHERE on the player and still grant points
    
    if (numPower1Left > 0) {
        [self flashLabel:@"ENERGY SHIELD UP" actionWithDuration:5.0f font:@"spacera" fontSize:18 color:@"red"];
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

//        [ship1 runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
//        [ship2 runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
//        [ship3 runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
        //        [ship2 runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
        //    [self removeChild:ship1 cleanup:YES];
        
        id removeEffect = [CCFadeOut actionWithDuration:0.2f];
        id removeSpriteForP3 = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
        
        for (NSUInteger k = 0; k < [section1Ships count]; k++) {
            CCSprite *tempSpriteToRemove = [section1Ships objectAtIndex:k];
            [tempSpriteToRemove runAction:[CCSequence actions:removeEffect, removeSpriteForP3, nil]];
            [section1Ships removeObjectAtIndex:k];
        }
        
        numPower3Left -= 1;
        [self initShips];
        
//        [self scheduleUpdate];
    } else {
        // do nothing
    }
}


-(void) shipPauseAllActions
{
//    [ship1 pauseSchedulerAndActions];
//    [ship2 pauseSchedulerAndActions];
//    [ship3 pauseSchedulerAndActions];
    //    [ship2 pauseSchedulerAndActions];
    
}

-(void) shipResumeAllActions
{
//    [ship1 resumeSchedulerAndActions];
//    [ship2 resumeSchedulerAndActions];
//    [ship3 resumeSchedulerAndActions];
//    //    [ship2 pauseSchedulerAndActions];
    
}


-(void) addPowerup1
{
    powerUp1 = [[CCSprite alloc] init];
    powerUp1 = [CCSprite spriteWithFile:@"element1.png"];
    powerUp1.scale = 0.2f;
    powerUp1.position = ccp(powerUpCreator1.position.x, powerUpCreator1.position.y + 30);
    [self addChild:powerUp1 z:20];
    [powerUpType1 addObject:powerUp1];
}

-(void) addPowerup2
{
    powerUp2 = [[CCSprite alloc] init];
    powerUp2 = [CCSprite spriteWithFile:@"element2.png"];
    powerUp2.scale = 0.2f;
    powerUp2.position = ccp(powerUpCreator2.position.x, powerUpCreator2.position.y + 30);
    [self addChild:powerUp2 z:20];
    [powerUpType2 addObject:powerUp2];
}

-(void) addPowerup3
{
    powerUp3 = [[CCSprite alloc] init];
    powerUp3 = [CCSprite spriteWithFile:@"element3.png"];
    powerUp3.scale = 0.2f;
    powerUp3.position = ccp(powerUpCreator3.position.x, powerUpCreator3.position.y + 30);
    [self addChild:powerUp3 z:20];
    [powerUpType3 addObject:powerUp3];
}




-(void) pickShape
{
    int shape = (arc4random()%(3-1+1))+1;
    shipShape = shape;
}

-(void) pickColor
{
    int color = (arc4random()%(3-1+1))+1;
    shipColor = color;
}

-(void) pickArray
{
    int array = (arc4random()%(3-1+1))+1;
    shipArray = array;
}


-(void) initSect1Ships
{
 	int numShips1 = numSpritesPerArray;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section1Ships == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section1Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips1; i++)
	{
        [self initializeShip1Sprite];
//        id initShip = [CCCallFunc actionWithTarget:self selector:@selector(initializeShip1Sprite)];
//        id moveShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
        //        id delayMove = [CCDelayTime actionWithDuration:1.0f];
        //        id moveTheShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
//        [self runAction:[CCSequence actions:initShip, moveShip, nil]];
	}
}

-(void) initializeShip1Sprite
{
    // Creating a spider sprite, positioning will be done later
    [self pickColor];
    CCSprite *ship;
    if (shipColor == 1) {
        ship = [CCSprite spriteWithFile:@"element1.png"];
        ship.tag = 1;
    }
    
    if (shipColor == 2) {
        ship = [CCSprite spriteWithFile:@"element2.png"];
        ship.tag = 2;
    }
    
    if (shipColor == 3) {
        ship = [CCSprite spriteWithFile:@"element3.png"];
        ship.tag = 3;
    }
    
    ship.scale = 0.15f;
    

    [self createShipCoord:ship topBottomChoose:topBottomVariable];
    [self addChild:ship z:50];
    
    // Also add the spider to the spiders array so it can be accessed more easily.
    [section1Ships addObject:ship];
//    [self moveShip:ship];
    
//    float randomDelay = (arc4random()%(3-1+1))+1;
    [self performSelector:@selector(moveShip:) withObject:ship afterDelay:1];
}

-(void) moveShip1
{
    [self moveShip:ship1];
}


-(void) initSect2Ships
{
 	int numShips2 = numSpritesPerArray;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section2Ships  == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section2Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips2; i++)
	{
        id initShip = [CCCallFunc actionWithTarget:self selector:@selector(initializeShip2Sprite)];
        id moveShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip2)];
        //        id delayMove = [CCDelayTime actionWithDuration:1.0f];
        //        id moveTheShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
        [self runAction:[CCSequence actions:initShip, moveShip, nil]];
	}
}

-(void) initializeShip2Sprite
{
    // Creating a spider sprite, positioning will be done later
    [self pickColor];
    if (shipColor == 1) {
        ship2 = [CCSprite spriteWithFile:@"element1.png"];
        ship2.tag = 1;
    }
    
    if (shipColor == 2) {
        ship2 = [CCSprite spriteWithFile:@"element2.png"];
        ship2.tag = 2;
    }
    
    if (shipColor == 3) {
        ship2 = [CCSprite spriteWithFile:@"element3.png"];
        ship2.tag = 3;
    }
    
    ship2.scale = 0.15f;
    //        topBottomVariable = (arc4random()%(2-1+1))+1;
    [self createShipCoord:ship2 topBottomChoose:topBottomVariable];
    [self addChild:ship2 z:50];
    
    // Also add the spider to the spiders array so it can be accessed more easily.
    [section2Ships addObject:ship2];
    //    [self moveShip:ship2];
    
}

-(void) moveShip2
{
    [self moveShip:ship2];
}


-(void) initSect3Ships
{
 	int numShips3 = numSpritesPerArray;
    
	// Initialize the spiders array. Make sure it hasn't been initialized before.
	//NSAssert1(section3Ships == nil, @"%@: spiders array is already initialized!", NSStringFromSelector(_cmd));
	section3Ships = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < numShips3; i++)
	{
        id initShip = [CCCallFunc actionWithTarget:self selector:@selector(initializeShip3Sprite)];
        id moveShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip3)];
        //        id delayMove = [CCDelayTime actionWithDuration:1.0f];
        //        id moveTheShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
        [self runAction:[CCSequence actions:initShip, moveShip, nil]];
	}
}

-(void) initializeShip3Sprite
{
    // Creating a spider sprite, positioning will be done later
    [self pickColor];
    if (shipColor == 1) {
        ship3 = [CCSprite spriteWithFile:@"element1.png"];
        ship3.tag = 1;
    }
    
    if (shipColor == 2) {
        ship3 = [CCSprite spriteWithFile:@"element2.png"];
        ship3.tag = 2;
    }
    
    if (shipColor == 3) {
        ship3 = [CCSprite spriteWithFile:@"element3.png"];
        ship3.tag = 3;
    }
    ship3.scale = 0.15f;

    [self createShipCoord:ship3 topBottomChoose:topBottomVariable];
    [self addChild:ship3 z:50];
    
    [section3Ships addObject:ship3];
    //    [self moveShip:ship3];
}

-(void) moveShip3
{
    [self moveShip:ship3];
}


-(void) initShips
{
    //    [self pickArray];
    [self pickShape];
    topBottomVariable = (arc4random()%(2-1+1))+1;
    //    if (shipArray == 1) {
    //        ship1 = [CCSprite spriteWithFile:@"ship1.png"];
    //        ship1.scale = 0.15;
    //        ship2 = [CCSprite spriteWithFile:@"ship1.png"];
    //        ship2.scale = 0.15;
    [self initSect1Ships];
    //    }
    
    
    //    if (shipArray == 2) {
    //        ship1 = [CCSprite spriteWithFile:@"ship2.png"];
    //        ship1.scale = 0.15;
    //        ship2 = [CCSprite spriteWithFile:@"ship2.png"];
    //        ship2.scale = 0.15;
    //            [self initSect2Ships];
    //    }
    
    //    if (shipArray == 3) {
    //        ship1 = [CCSprite spriteWithFile:@"ship3.png"];
    //        ship1.scale = 0.15;
    //        ship2 = [CCSprite spriteWithFile:@"ship3.png"];
    //        ship2.scale = 0.15;
    //          [self initSect3Ships];
    //    }
    
    //    [self createShipCoord:ship1]; // create coordinate for ship to spawn to
    //    [self moveShip:ship1];
    //    [self createShipCoord:ship2]; // create coordinate for ship to spawn to
    //    [self moveShip:ship2];
}


-(void) moveShip:(CCSprite *) shipToMove
{
    float previousShipDelay;
    int slowestSpeed = shipSpeed + 1;
    int fastestSpeed = shipSpeed - 1;

    float speed = arc4random()%(slowestSpeed-fastestSpeed+1)+fastestSpeed;

    float delayInSeconds = arc4random()%(5-2+1)+2;
    if (delayInSeconds == previousShipDelay) {
        delayInSeconds = arc4random()%(5-2+1) + 2;

    }
    id delayMove = [CCDelayTime actionWithDuration:delayInSeconds];
    shipMove = [CCMoveTo actionWithDuration:speed position:screenCenter]; // initialize the action to run when the ship is appeneded to the layer
    [shipToMove runAction:[CCSequence actions:delayMove, shipMove, nil]]; // run the action initialized
    previousShipDelay = delayInSeconds;
}

-(void) createShipCoord:(CCSprite *)shipForCoord topBottomChoose:(int) decidingVariable
{
    // Temporary way of generating random coordinates to spawn to
    int fromNumber = -220;
    int toNumber = 580;
    
    if (decidingVariable == 1) {
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
    //    [self addChild:shipForCoord z:7];
}


// METHODS THAT MUST RUN EVERY FRAME
-(void) updateHealth
{
    //    float percent = (playerLives/startLives) * 100;
    //    NSLog(@"PERCENT: %f", percent);
    lifeBar.percentage -= 10; //(playerLives/startLives) * 100;
    //    NSLog(@"PERCENTAGE: %f", lifeBar.percentage);
    //    lifeUpdater = [CCProgressTo actionWithDuration:0.5f percent:(playerLives/startLives) * 100];
    //    [lifeBar runAction:lifeUpdater];
}

-(void) updateScore
{
    score = [[NSString alloc] initWithFormat:@"%i",playerScore];
    [scoreLabel setString:score];
    lives = [[NSString alloc] initWithFormat:@"Lives: %i",playerLives];
    [liveLabel setString:lives];
    
    multiplierString = [[NSString alloc] initWithFormat:@"x%i", pointMultiplier];
    [multiplierLabel setString:multiplierString];
    
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

-(void) updateLabelPositions
{
   /* if (score.length == 1) {
        scoreLabel.position = ccp(15, scoreLabel.position.y);
    } else {
    scoreLabel.position = ccp((score.length * 10), scoreLabel.position.y);
    } */
}

-(void) updateEffectPositions
{
    burnGrass.position = progressBar3.position; //progressBar3.position;
    snuffedFire.position = progressBar1.position;
    dryWater.position = progressBar2.position;

//    [burnGrass setAnchorPoint:screenCenter];
//    snuffedFire.anchorPoint = screenCenter;
//    dryWater.anchorPoint = screenCenter;
    
    burnGrass.rotation = progressBar3.rotation + 180;
    snuffedFire.rotation = progressBar1.rotation + 60;
    dryWater.rotation = progressBar2.rotation - 60;
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
            
            //            NSLog(@"Player Rotation: %f", player.rotation);
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
    
    if (playerScore > 20) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 2;
        
    }
    
    if (playerScore > 50) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 3;
        
    }
    
    
    if (playerScore > 90) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 4;
        
    }
    
    if (playerScore > 200) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 6;
        
    }
    
    if (playerScore > 400) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 6;
        
    }
    
    if (playerScore > 800) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 7;
        
    }
    
    if (playerScore > 1000) {
        //            shipSpeed = 4.2f;
        numSpritesPerArray = 10;
        
    }
    
    // speed challenge
    /*if (playerScore > 6) {
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
     }*/
    
    //    if (playerScore > 39) {
    //        shipSpeed = 1.9f;
    //    }
    
    //    if (playerScore > 59) {
    //        shipSpeed = 1.9f;
    //    }
    
    //    if (playerScore > 79) {
    //        shipSpeed = 1.9f;
    //    }
    
    //    if (playerScore > 99) {
    //        shipSpeed = 1.0f;
    //    }
    
    
}


-(void) initMenuItems
{

}


// CUSTOM FUNCTIONS TO INCREASE PRODUCTIVITY
-(void) flashWithRed:(int) red green:(int) green blue:(int) blue alpha:(int) alpha actionWithDuration:(float) duration
{
    colorLayer = [CCLayerColor layerWithColor:ccc4(red, green, blue, alpha)];
    [self addChild:colorLayer z:0];
    id delay = [CCDelayTime actionWithDuration:duration];
    id fadeOut = [CCFadeOut actionWithDuration:0.5f];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeFlashColor)];
    [colorLayer runAction:[CCSequence actions:delay, fadeOut, nil]];
    
}

-(void) removeFlashColor
{
    [self removeChild:colorLayer cleanup:YES];
}

-(void) setDimensionsInPixelsOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height
{
    spriteToSetDimensions.scaleX = width/[spriteToSetDimensions boundingBox].size.width;
    spriteToSetDimensions.scaleY = height/[spriteToSetDimensions boundingBox].size.height;
}

-(void) setDimensionsInPixelsGraduallyOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height
{
    float scaleXDimensions = width/[spriteToSetDimensions boundingBox].size.width;
    float scaleYDimensions = height/[spriteToSetDimensions boundingBox].size.height;
    id scaleX = [CCScaleTo actionWithDuration:0.5f scaleX:scaleXDimensions scaleY:scaleYDimensions];
    [spriteToSetDimensions runAction:scaleX];
}

-(void) flashLabel:(NSString *) stringToFlashOnScreen actionWithDuration:(float) numSecondsToFlash font:(NSString *) fontName fontSize:(int) fontSizeint color:(NSString *) colorString
{
    if ([fontName isEqualToString:@"spacera"] == true) {
//    screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"SpaceraLT-Regular" fontSize:fontSizeint];
//        [screenflashLabel setFntFile:@"Spacera.ttf"];
    }

    if ([fontName isEqualToString:@"roboto"] == true) {
//    screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:fontSizeint];
        
    }
//
//    screenflashLabel.position = ccp(size.width/2, 405);
//    
//    
//    if ([colorString isEqualToString:@"red"] == true) {
//    screenflashLabel.color = ccc3(255,0,0);
//    }
//    
//    if ([colorString isEqualToString:@"blue"] == true) {
//        screenflashLabel.color = ccc3(0,0,255);
//    }
//    
//    if ([colorString isEqualToString:@"green"] == true) {
//        screenflashLabel.color = ccc3(0,255,0);
//    }
//    
//    if ([colorString isEqualToString:@"black"] == true) {
//        screenflashLabel.color = ccc3(0,0,0);
//    }
//    
//    if ([colorString isEqualToString:@"white"] == true) {
//        screenflashLabel.color = ccc3(255,255,255);
//    }
//    
//    screenflashLabel.color = ccc3(255, 0, 0);
//
//    screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:fontSizeint];
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
    [self flashWithRed:255 green:0 blue:0 alpha:255 actionWithDuration:0.1f];
    [ship1 stopAction:shipMove]; // stop any currently moving ships to avoid the explosion from happening twice
    //    [ship2 stopAction:shipMove]; // stop any currently moving ships to avoid the explosion from happening twice
    id particleEffects = [CCCallFunc actionWithTarget:self selector:@selector(runEffect)];
    id effectDelay = [CCDelayTime actionWithDuration:2.4f];
    id goToScene = [CCCallFunc actionWithTarget:self selector:@selector(transferToGameOverScene)];
    [self removeChild:player cleanup:YES];
    [self removeChild:ship1 cleanup:YES];
    //    [self removeChild:ship2 cleanup:YES];
    
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
    startLives = 10;
    playerLives = 10;
    framesPassed = 0;
    secondsPassed = 0;
    numCollisions = 0;
    livesSubtract = 1;
    scoreAdd = 5;
    pointMultiplier = 2; // starting multiplier to prevent killing the user almost instantly
    
    numPower1Left = 1;
    numPower2Left = 5;
    numPower3Left = 5;
    
    generationInterval = 700;
    
    warning = false;
    collisionDidHappen = false;
    
    numSpritesCollided = 0;
    numSpritesCollidedWithShield = 0;
    
    numSpritesPerArray = 1;
    
    spriteTagNum = 0;
    
    rotation = 0.0f;
    
    NSNumber *curHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
    playerHighScore = [curHighScore intValue]; // read from the devices memory
    
    NSNumber *curCoins = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
    playerCoins = [curCoins intValue]; // read from devices memory
}

-(void) gameOver
{
    [section1Ships removeAllObjects];
    [section2Ships removeAllObjects];
    [section2Ships removeAllObjects];
    [self removeChild:ship1];
    [self removeChild:ship2];
    [self removeChild:ship3];
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
    
    if (playerCoins == 0) {
        playerCoins = playerScore;
        sharedCoins = [NSNumber numberWithInteger:playerCoins];
        [[NSUserDefaults standardUserDefaults] setObject:sharedCoins forKey:@"sharedCoins"];
    }
    if (playerCoins > 0) {
        playerCoins = playerCoins + playerScore;
        sharedCoins = [NSNumber numberWithInteger:playerCoins];
        [[NSUserDefaults standardUserDefaults] setObject:sharedCoins forKey:@"sharedCoins"];
    }
    
    
    
    //    NSNumber *savedHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
    //    NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //    [MGWU submitHighScore:[savedHighScore intValue] byPlayer:savedUser forLeaderboard:@"defaultLeaderboard"];
    
    [self goToGameOver];
}

-(void) pauseGame
{
    [[CCDirector sharedDirector] pushScene:
	 [CCTransitionSlideInR transitionWithDuration:0.5f scene:[PauseLayer node]]];
}

-(void)update:(ccTime)dt // update method
{
    collisionDidHappen = false;
    framesPassed++;
    secondsPassed = framesPassed/60; // divide by framerate;
//    if ((framesPassed % generationInterval) == 0) {
//        [self initShips];
//    }
    
    [self divideAngularSections]; // divide angle borders
    //    [self circleCollisionWithSprite:player andThis:ship1];
    //    [self infiniteBorderCollisionWith:ship1];
    //    [self circleCollisionWithSprite:player andThis:ship2];
    //    [self circleCollisionWithSprite:player andThis:ship2];
    //    [self infiniteBorderCollisionWith:ship2];
    [self circleCollisionWith:section1Ships]; // collision detection
    [self circleCollisionWith:section2Ships];
    [self circleCollisionWith:section3Ships];
    [self handleUserInput]; // handle the player's touch and rotation
    [self divideAngularSections]; // divide the angle borders to differentiate between colors
    [self updateScore]; // update the labels for player data
    [self updateLabelPositions];
    [self updateEffectPositions];
    [self initChallenges]; // start challenges to throw at the player
}


@end
