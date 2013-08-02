/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


/* SUGGESTIONS:
 - PHYSICS FOR USER INPUT (MAKE THE PLANET HAVE A MORE FLUID SPIN, MUCH LIKE A WHEEL, OPTIONAL)
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
//		glClearColor(0.0, 0.75, 1.0, 1.0); // default background color
        glClearColor(0.91, 0.92, 0.91, 1.0);
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
        
        
        player = [[CCSprite alloc] init];
        
        player = [CCSprite spriteWithFile:@"border.png"];
    
        
        player.position = ccp(size.width/2, size.height/2);
        player.scale = 0.85f;
        playerWidth = [player boundingBox].size.width; // get player width
        [self addChild:player z:20];
        //        [player runAction:explode];
        
        
        section1 = [CCSprite spriteWithFile:@"element1.png"];
        section1.scale = 0.85f;
        progressBar1 = [CCProgressTimer progressWithSprite:section1];
//        progressBar1.scale = 0.8f;
        progressBar1.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar1 z:21];
        progressBar1.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //        [progressBar1 setAnchorPoint:zero];
        progressTo1 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        
        
//        section2 = [CCSprite spriteWithFile:@"element2.png"];
        
        section2 = [CCSprite spriteWithFile:@"element2.png"];
        section2.scale = 0.85f;
        
        progressBar2 = [CCProgressTimer progressWithSprite:section2];
//        progressBar2.scale = 0.8f;
        progressBar2.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar2 z:21];
        progressBar2.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar2.rotation = 120.0f;
        progressTo2 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        section3 = [CCSprite spriteWithFile:@"element3.png"];
        section3.scale = 0.85f;
        progressBar3 = [CCProgressTimer progressWithSprite:section3];
//        progressBar3.scale = 0.8f;
        progressBar3.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar3 z:21];
        progressBar3.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar3.rotation = 240.0f;
        progressTo3 = [CCProgressTo actionWithDuration:1 percent:33.333f];
        
        // iPhone 5 Optimizations
        if ([director winSizeInPixels].height == 1136)
        {
            progressBar1.position = ccp(size.width/2 - 65, size.height/2 - 189);
            progressBar2.position = ccp(size.width/2 - 65, size.height/2 - 189);
            progressBar3.position = ccp(size.width/2 - 65, size.height/2 - 189);
        }
        
        if ([director winSizeInPixels].height == 1024)
        {
            oniPad = true;
            progressBar1.position = ccp(size.width/2 - 289, size.height/2 - 417);
            progressBar2.position = ccp(size.width/2 - 289, size.height/2 - 417);
            progressBar3.position = ccp(size.width/2 - 289, size.height/2 - 417);
            player.scale = 1.8f;
            playerWidth = [player boundingBox].size.width; // calibrate collision detection
            section1.scale = 1.8f;
            section2.scale = 1.8f;
            section3.scale = 1.8f;
            spawnDistance = 600;
            
        } else if ([director winSizeInPixels].height == 2048)
        {
            oniPad = true;
            progressBar1.position = ccp(size.width/2 - 289, size.height/2 - 417);
            progressBar2.position = ccp(size.width/2 - 289, size.height/2 - 417);
            progressBar3.position = ccp(size.width/2 - 289, size.height/2 - 417);
            player.scale = 1.8f;
            playerWidth = [player boundingBox].size.width; // calibrate collision detection
            section1.scale = 1.8f;
            section2.scale = 1.8f;
            section3.scale = 1.8f;
            spawnDistance = 600;
        } else {
            oniPad = false;
        }
        
        
        [progressBar1 runAction:progressTo1];
        [progressBar2 runAction:progressTo2];
        [progressBar3 runAction:progressTo3];
        
        // score label
        score = [[NSString alloc]initWithFormat:@"%i", playerScore];
        scoreLabel = [CCLabelTTF labelWithString:score fontName:@"Roboto-Light" fontSize:25];
        scoreLabel.position = ccp(55, size.height - 22);
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
        powerUpCreator1 = [CCMenuItemImage itemWithNormalImage:@"shield.png"
                                                 selectedImage: @"shield.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp1)];
        powerUpCreator1.scale = 0.3f;
        
        powerUpCreator1.position = ccp(size.width/3 - 70, 20);
        //        [self addChild:powerUpCreator1 z:5];
        
        powerUpCreator2 = [[CCMenuItemImage alloc] init];
        powerUpCreator2 = [CCMenuItemImage itemWithNormalImage:@"stop.png"
                                                 selectedImage: @"stop.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp2)];
        powerUpCreator2.scale = 0.3f;
        powerUpCreator2.position = ccp(size.width/2 - 20, 20);
        //        [self addChild:powerUpCreator2 z:5];
        
        powerUpCreator3 = [[CCMenuItemImage alloc] init];
        powerUpCreator3 = [CCMenuItemImage itemWithNormalImage:@"shock.png"
                                                 selectedImage: @"shock.png"
                                                        target:self
                                                      selector:@selector(enablePowerUp3)];
        powerUpCreator3.scale = 0.3f;
        powerUpCreator3.position = ccp(size.width/1.5 + 30, 20);
        //        [self addChild:powerUpCreator3 z:5];
        
        powerUpCreatorsMenu = [CCMenu menuWithItems:powerUpCreator1, powerUpCreator2, powerUpCreator3, nil];
        powerUpCreatorsMenu.position = ccp(size.width/2-160, 0);
        if (oniPad == true) {
            powerUpCreator1.position = ccp(size.width/3 - 65, 20);
            powerUpCreator2.position = ccp(size.width/2 - 85, 20);
            powerUpCreator3.position = ccp(size.width/1.5 - 105, 20);
            powerUpCreatorsMenu.position = ccp(size.width/2-320, 0);
        }
        
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
        
        if (oniPad == true) {
            power1Left.position = ccp(size.width/3 + 40, 20);
            power2Left.position = ccp(size.width/2 + 20, 20);
            power3Left.position = ccp(size.width/1.5, 20);
        }
        
        
        powerUpBorder1 = [[CCMenuItemImage alloc] init];
        powerUpBorder1 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp1)];
//        powerUpBorder1.position = ccp(size.width/3 - 53, 20);
        //        [self addChild:powerUpBorder1 z:-5];
        
        powerUpBorder2 = [[CCMenuItemImage alloc] init];
        powerUpBorder2 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp2)];
//        powerUpBorder2.position = ccp(size.width/2, 20);
        //        [self addChild:powerUpBorder2 z:-5];
        
        powerUpBorder3 = [[CCMenuItemImage alloc] init];
        powerUpBorder3 = [CCMenuItemImage itemWithNormalImage:@"PowerupBorder.png"
                                                selectedImage: @"PowerupBorder.png"
                                                       target:self
                                                     selector:@selector(enablePowerUp3)];
//        powerUpBorder3.position = ccp(size.width/1.5 + 53, 20);
        //        [self addChild:powerUpBorder3 z:-5];
        
        CCMenu *powerBorderMenu = [CCMenu menuWithItems:powerUpBorder1, powerUpBorder2, powerUpBorder3, nil];
        powerBorderMenu.position = ccp(size.width/2, 20);
        [powerBorderMenu alignItemsHorizontallyWithPadding:0.0f];
        [self addChild:powerBorderMenu z:-5];
        
        // init the border sprite for powerup1
        infiniteBorderPowerUp1 = [[CCSprite alloc] init];
        infiniteBorderPowerUp1 = [CCSprite spriteWithFile:@"border.png"];
        infiniteBorderPowerUp1.scale = 0;
        infiniteBorderPowerUp1.position = screenCenter;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
            screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"NexaBold" fontSize:40];
            screenflashLabel.position = ccp(size.width/2, size.height - 125);
            
        } else {
            screenflashLabel = [CCLabelTTF labelWithString:score fontName:@"NexaBold" fontSize:20];
            screenflashLabel.position = ccp(size.width/2, size.height - 85);
        }
        
        screenflashLabel.color = ccc3(255,0,0);
        [self addChild:screenflashLabel z:110];
        screenflashLabel.visible = false;
        
        
        multiplierWrapper = [CCSprite spriteWithFile:@"multiplier_wrapper.png"];
        multiplierWrapper.position = ccp(15, size.height - 19);
        [self setDimensionsInPixelsOnSprite:multiplierWrapper width:70 height:70];
        [self addChild:multiplierWrapper z:scoreLabel.zOrder];
        
        multiplierString = [[NSString alloc] initWithFormat:@"x%i", pointMultiplier];
        multiplierLabel = [CCLabelTTF labelWithString:multiplierString fontName:@"Roboto-Light" fontSize:25];
        multiplierLabel.position = ccp(multiplierWrapper.position.x + 10, multiplierWrapper.position.y - 3);
        multiplierLabel.color = ccc3(255,255,255);
        //        multiplierLabel.anchorPoint = ccp(0.0f,0.5f); // left justify
        [self addChild:multiplierLabel z:scoreLabel.zOrder+1];
        
        
        enemyShip1 = [[CCSprite alloc] init];
        enemyShip1 = [CCSprite spriteWithFile:@""];
        
        CCSprite *topBar = [CCSprite spriteWithFile:@"topbar.png"];
        topBar.position = ccp(screenCenter.x, size.height - 20);
        topBar.scaleX = 3.0f;
        //        [self addChild:topBar z:1000];
        
        CCSprite *background;
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024) {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        } else {
            background = [CCSprite spriteWithFile:@"skybgip5.png"];
        }
        
        background.position = screenCenter;
        [self addChild:background z:-100];
        
        
        [self divideAngularSections];
        
        //        [self pickArray];
        [self pickShape];
        [self initShips];
        
        // preload sound effects so that there is no delay when playing sound effect
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"click1.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gameover1.mp3"];
        
        //        [self flashWithRed:0 green:0 blue:255 alpha:255 actionWithDuration:1.0f];
        
        
//        burnGrass = [CCParticleFire node];
//        [progressBar3 addChild:burnGrass z:1001];
//        burnGrass.visible = false;
//        
//        snuffedFire = [CCParticleSnow node];
//        [progressBar1 addChild:snuffedFire z:1001];
//        snuffedFire.visible = false;
//        
//        dryWater = [CCParticleSnow node];
//        [progressBar2 addChild:dryWater z:1001];
//        dryWater.visible = false;
        
        rotateArrow = [CCSprite spriteWithFile:@"rotate.png"];
        rotateArrow.position = ccp(player.position.x + 20, player.position.y);
        [self addChild:rotateArrow z:1000];
        rotateArrow.visible = false;
        
        
        
//        [self setDimensionsInPixelsOnSprite:rotateArrow width:270 height:320];
        
        powerupArrow = [CCSprite spriteWithFile:@"powerupTutorial.png"];
        powerupArrow.position = ccp(screenCenter.x, 80);
        [self addChild:powerupArrow z:1000];
        powerupArrow.visible = false;

        [self setDimensionsInPixelsOnSprite:rotateArrow width:300 height:300];
    
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"newHighScore"]; // assume by default that a new high score hasn't occured yet
        
        
        
        [self scheduleUpdate]; // schedule the framely update
        
        [self startTutorial]; // start the tutorial (if needed)
        
        if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"dpgl_bg.mp3" loop:YES];
        }
//        [self enableSpiralEffect];
        
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
    if (playedTutorial == false) {
        playedTutorial = true;
        id delay = [CCDelayTime actionWithDuration:5.0f];
        id part1 = [CCCallFunc actionWithTarget:self selector:@selector(tutorial1)];
        id part2 = [CCCallFunc actionWithTarget:self selector:@selector(tutorial2)];
        id part3 = [CCCallFunc actionWithTarget:self selector:@selector(tutorial3)];
        id cleanupTutorial = [CCCallFunc actionWithTarget:self selector:@selector(hideAllTutorialSprites)];
        CCSequence *tutorialSeq = [CCSequence actions:part1, delay, part2, delay, part3, delay, cleanupTutorial, delay, nil];
        [self runAction:tutorialSeq];
        
        [[NSUserDefaults standardUserDefaults] setBool:playedTutorial forKey:@"tutorialStatus"];
    }
    
    
}

-(void) tutorial1
{
    [self flashLabel:@"Move the circle with your \n finger." actionWithDuration:5.0f color:@"black"];
    rotateArrow.visible = true;
}

-(void) tutorial2
{
    rotateArrow.visible = false;
    [self flashLabel:@"Match the colors!" actionWithDuration:5.0f color:@"black"];
}

-(void) tutorial3
{
    [self flashLabel:@"Use the powerups at the bottom" actionWithDuration:5.0f color:@"black"];
    powerupArrow.visible = true;
}

-(void) hideAllTutorialSprites
{
    powerupArrow.visible = false;
    rotateArrow.visible = false;
}

-(void) killGrass
{
    burnGrass = [CCParticleFire node];
	[progressBar3 addChild:burnGrass z:1101];
    burnGrass.visible = true;
    grassBeingKilled = true;
    fireBeingKilled = false;
    waterBeingKilled = false;
}

-(void) removeGrassEffect
{
    [progressBar3 removeChild:burnGrass];
    burnGrass.visible = false;
    grassBeingKilled = false;
}


-(void) killFire
{
    snuffedFire = [CCParticleFire node];
	[progressBar1 addChild:snuffedFire z:1101];
    snuffedFire.visible = true;
    grassBeingKilled = false;
    fireBeingKilled = true;
    waterBeingKilled = false;
}

-(void) removeFireEffect
{
    [progressBar1 removeChild:snuffedFire];
    snuffedFire.visible = false;
    fireBeingKilled = false;
}


-(void) killWater
{
    dryWater = [CCParticleFire node];
	[progressBar2 addChild:dryWater z:1101];
    dryWater.visible = true;
    grassBeingKilled = false;
    fireBeingKilled = false;
    waterBeingKilled = true;}

-(void) removeWaterEffect
{
    [progressBar2 removeChild:dryWater];
    dryWater.visible = false;
    waterBeingKilled = false;
}

-(void) runDeathSeqOn:(NSString *) effectName
{
    if ([effectName isEqualToString:@"grass"] == true) {
//        if (grassBeingKilled == true) {
        id execute = [CCCallFunc actionWithTarget:self selector:@selector(killGrass)];
        id delay = [CCDelayTime actionWithDuration:0.5f];
        id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeGrassEffect)];
        CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
        [self runAction:deathSeq];
//        }
    }
    
    if ([effectName isEqualToString:@"fire"] == true) {
//        if (fireBeingKilled == true) {
        id execute = [CCCallFunc actionWithTarget:self selector:@selector(killFire)];
        id delay = [CCDelayTime actionWithDuration:0.5f];
        id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeFireEffect)];
        CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
        [self runAction:deathSeq];
//        }
    }
    
    if ([effectName isEqualToString:@"water"] == true) {
//        if (waterBeingKilled == true) {
        id execute = [CCCallFunc actionWithTarget:self selector:@selector(killWater)];
        id delay = [CCDelayTime actionWithDuration:0.5f];
        id remove = [CCCallFunc actionWithTarget:self selector:@selector(removeWaterEffect)];
        CCSequence* deathSeq = [CCSequence actions:execute, delay, remove, nil];
        [self runAction:deathSeq];
//        }
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
    //    [self updateCollisionCounter];
    
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
            
            if (shipAngle == 0.f) {
                shipAngle = 90.f;
            }
            
            
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
            [self updateScore]; // update here instead of in update to save FPS (CCLabel updates are slow)
            
            collisionDidHappen = true;
            
            
            if (createSpiralEffectWithCoords == true) {
                if (numLivesForSpiral <= 0) {
//                    [self removeChild:tempSprite cleanup:YES];
//                    [circle2 removeObjectAtIndex:i];
                    if (explodedAlready == false) {
                        [self gameOver];
                    }
                }
            }
            
            if (pointMultiplier <= 0) {
                pointMultiplier = 0;
                [tempSprite stopAction:shipMove];
                id dock = [CCScaleTo actionWithDuration:0.2f scale:0];
                id removeSprite = [CCCallFuncN actionWithTarget:self selector:@selector(removeArraySprite:)];
                [tempSprite runAction:[CCSequence actions:dock, removeSprite, nil]];
                //            [self removeChild:circle2 cleanup:YES];
                [circle2 removeObjectAtIndex:i];

                
                [self enableSpiralEffect];
                
                
            } else {
                [tempSprite stopAction:shipMove];
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


-(void) removeAllSpritesFromArray
{
    for (int object  = 0; object < [section1Ships count]; object++)
    {
        CCSprite *tmp = [section1Ships objectAtIndex:object];
        [self removeChild:tmp cleanup:YES];
        [section1Ships removeObjectAtIndex:object];
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
        
        
//        float ratio = distY/distance; // ratio of distance in terms of Y to distance from player
//        float shipAngleRadians = asin(ratio); // arcsin of ratio
//        float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
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
//        NSLog(@"%f", shipAngle);
//        NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
//        NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
//        NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
//        NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
//        NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
//        NSLog(@"Section 3 EndAngle: %f", section3EndAngle);
        //        [self scoreCheck:shipAngle withColor:shipColor];
        
        collisionDidHappen = true;
        
        if (playerLives == 0) {
            [self removeChild:circle2 cleanup:YES];
            //            [self initShips];
            //            warning = true;
            [self gameOver];
        } else {
            [self stopAction:shipMove];
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
//    NSLog(@"Array Count: %d", [section1Ships count]);
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
//    NSLog(@"SPRITE REMOVED");
    [self removeChild:sender cleanup:YES];
}


-(void) increaseMultiplier
{
    numHitsUntilNextMultiplier++;
    
    if (pointMultiplier < 99) {
    if (p3Enabler == true) {
        // if the powerup is enabled, do this
        pointMultiplier +=1;
        numHitsUntilNextMultiplier = 0;
    } else {
        // if the powerup is not enabled do this
        if (numHitsUntilNextMultiplier >= pointMultiplier) {
            numHitsUntilNextMultiplier = 0;
            pointMultiplier += 1;
        }
    }
    }
}


-(void) penalizePlayer
{
    pointMultiplier -= multiplierDecrease;
    numLivesForSpiral -= 1;
}

-(void) rewardPlayer
{
    targetScore = playerScore + (scoreAdd * pointMultiplier);
}

-(void) scoreCheck:(int) angle withSprite:(CCSprite *) spriteWithArray
{
    if (spriteWithArray.tag == 1)
    {
        [self divideAngularSections];
        
        if (angle > section1StartAngle && angle < section1EndAngle) {
            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
            
        } else if (section1StartAngle > section1EndAngle) {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
                
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        }
        
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self penalizePlayer];
            
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
        }
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            //            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"grass"];
            [self penalizePlayer];
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"grass"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"grass"];
                [self penalizePlayer];
            }
        }
        
    }
    else if (spriteWithArray.tag == 2)
    {
        [self divideAngularSections];
        
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        }
        
        if (angle > section1StartAngle && angle < section1EndAngle)
        {
            //            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"fire"];
            [self penalizePlayer];
        } else if (section1StartAngle > section1EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"fire"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"fire"];
                [self penalizePlayer];
            }
        }
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            //            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self penalizePlayer];
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
        }
        
        
        
        
    } else if (spriteWithArray.tag == 3) {
        [self divideAngularSections];
        
        if (angle > section3StartAngle && angle < section3EndAngle)
        {
            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
            [self increaseMultiplier];
        } else if (section3StartAngle > section3EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section3EndAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
            
            if (angle > 241 && angle > section3StartAngle)
            {
                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"click1.mp3"];
                [self increaseMultiplier];
            }
        }
        
        if (angle > section1StartAngle && angle < section1EndAngle)
        {
            //            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self penalizePlayer];
        } else if (section1StartAngle > section1EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section1EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section1StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self penalizePlayer];
            }
        }
        
        if (angle > section2StartAngle && angle < section2EndAngle)
        {
            //            [self rewardPlayer];
            [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
            [self runDeathSeqOn:@"water"];
            [self penalizePlayer];
        } else if (section2StartAngle > section2EndAngle)
        {
            [self divideAngularSections];
            if (angle < 119 && angle < section2EndAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"water"];
                [self penalizePlayer];
            }
            
            if (angle > 241 && angle > section2StartAngle)
            {
                //                [self rewardPlayer];
                [[SimpleAudioEngine sharedEngine] playEffect:@"incorrect.wav"];
                [self runDeathSeqOn:@"water"];
                [self penalizePlayer];
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
    [self rewardPlayer];
    [self increaseMultiplier];
    [self updateScore];
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
        if (numTimesP1Used > 0) {
            if (p1Enabled == false) {
                [self flashLabel:@"ENERGY SHIELD UP" actionWithDuration:timeShieldEnabled color:@"red"];
                id addBorder = [CCCallFunc actionWithTarget:self selector:@selector(addInfiniteBorder)];
                id delayRemoval = [CCDelayTime actionWithDuration:timeShieldEnabled];
                id removeBorder = [CCCallFunc actionWithTarget:self selector:@selector(removeInfiniteBorder)];
                CCSequence *powerUp1Seq = [CCSequence actions:addBorder, delayRemoval, removeBorder, nil];
                numPower1Left-=1;
                numTimesP1Used-=1;
                [self runAction:powerUp1Seq];
                [self updateScore];
            }
        }
    } else {
        // do nothing
    }
    
}

-(void) addInfiniteBorder
{
    p1Enabled = true;
    infiniteBorderPowerUp1.scale = 1.3f;
    [self addChild:infiniteBorderPowerUp1 z:-10 tag:50];
    if (oniPad == true) {
        infiniteBorderPowerUp1.scale = 2.7f;
    }
}

-(void) removeInfiniteBorder
{
    p1Enabled = false;
    infiniteBorderPowerUp1.scale = 0;
    [self removeChild:infiniteBorderPowerUp1 cleanup:YES];
}


-(void) enablePowerUp2
{
    if (numPower2Left > 0) {
        if (numTimesP2Used > 0) {
            if (p2Enabled == false) {
                [self flashLabel:@"PROJECTILES PAUSED" actionWithDuration:1.5f color:@"red"];
                id stopShip = [CCCallFunc actionWithTarget:self selector:@selector(shipPauseAllActions)];
                id delayShip = [CCDelayTime actionWithDuration:1.5f];
                id resumeShip = [CCCallFunc actionWithTarget:self selector:@selector(shipResumeAllActions)];
                CCSequence *powerUp2Seq = [CCSequence actions:stopShip, delayShip, resumeShip, nil];
                numPower2Left -= 1;
                numTimesP2Used-=1;
                [self runAction:powerUp2Seq];
                [self updateScore];
            }
        }
    } else {
        // do nothing
    }
    
}


-(void) enablePowerUp3
{
    if (numPower3Left > 0) {
        
        
        if (numTimesP3Used > 0) {
            if (p3Enabler == false) {
                [self flashLabel:@"MULTIPLIER BOOST!" actionWithDuration:5.0f color:@"red"];
                
                id enableIncrease = [CCCallFunc actionWithTarget:self selector:@selector(enableShipMultiplierIncrease)];
                id delayDecrease = [CCDelayTime actionWithDuration:5.0f];
                id disable = [CCCallFunc actionWithTarget:self selector:@selector(disableShipMultiplierIncrease)];
                
                [self runAction:[CCSequence actions:enableIncrease, delayDecrease, disable, nil]];
                
                numPower3Left -= 1;
                numTimesP3Used -= 1;
                
                [self updateScore];
            }
        }

    } else {
        // do nothing
    }
}

-(void) enableShipMultiplierIncrease
{
    p3Enabler = true;
}

-(void) disableShipMultiplierIncrease
{
    p3Enabler = false;
}



-(void) shipPauseAllActions
{
    p2Enabled = true;
    [self unschedule:@selector(initializeTheShipArray:)]; // be careful with this! was just implemented
    
    for (int shipPauseIndex = 0; shipPauseIndex < [section1Ships count]; shipPauseIndex++)
    {
        [[section1Ships objectAtIndex:shipPauseIndex] pauseSchedulerAndActions];
    }
    //    [ship1 pauseSchedulerAndActions];
    //    [ship2 pauseSchedulerAndActions];
    //    [ship3 pauseSchedulerAndActions];
    //    [ship2 pauseSchedulerAndActions];
    
}

-(void) shipResumeAllActions
{
    p2Enabled = false;
    [self schedule:@selector(initializeTheShipArray:)];
    
    for (int shipResumeIndex = 0; shipResumeIndex < [section1Ships count]; shipResumeIndex++)
    {
        [[section1Ships objectAtIndex:shipResumeIndex] resumeSchedulerAndActions];
    }
    
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
    
    if (createSpiralEffectWithCoords == true) {
        shipColor = 1;
    }
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
	
    [self schedule:@selector(initializeTheShipArray:)];
    
    //	for (int i = 0; i < numShips1; i++)
    //	{
    //        [self initializeShip1Sprite];
    
    //        [self performSelector:@selector(initializeShip1Sprite) withObject:nil afterDelay:0.5f];
    //        [self runAction:[CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(initializeShip1Sprite)], [CCDelayTime actionWithDuration:1.0f], nil]];
    
    // [self performSelector:@selector(initializeShip1Sprite) withObject:self afterDelay:0.5f];
    //        id initShip = [CCCallFunc actionWithTarget:self selector:@selector(initializeShip1Sprite)];
    //        id moveShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
    //        id delayMove = [CCDelayTime actionWithDuration:1.0f];
    //        id moveTheShip = [CCCallFunc actionWithTarget:self selector:@selector(moveShip1)];
    //        [self runAction:[CCSequence actions:initShip, moveShip, nil]];
    //	}
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
    
    if (oniPad == true) {
        ship.scale = 0.3f;
    }
    
    [self createShipCoord:ship topBottomChoose:topBottomVariable withColor:ship.tag]; // create coordinate
    [self addChild:ship z:50]; // add sprite to scene
    
    // Also add the spider to the spiders array so it can be accessed more easily.
    [section1Ships addObject:ship]; // add sprite to array
    [self moveShip:ship]; // moves the ship
    
    //    float randomDelay = (arc4random()%(3-1+1))+1;
    
    //    [self performSelector:@selector(delayShipMove) onThread:[NSThread currentThread] withObject:self waitUntilDone:YES];
    //    [self moveShip:ship];
    
    didRun = false;
}

-(void) moveShip1
{
    [self moveShip:ship1];
}

-(void) delayShipMove
{
    [self runAction:[CCDelayTime actionWithDuration:0.5f]];
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
//    [self createShipCoord:ship2 topBottomChoose:topBottomVariable];
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
    
//    [self createShipCoord:ship3 topBottomChoose:topBottomVariable];
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
    [self pickShape];
    topBottomVariable = (arc4random()%(2-1+1))+1;
    
    [self initSect1Ships];
    updateMoveCounter = true;
    spriteMoveIndex = 0;
}


-(void) moveShip:(CCSprite *) shipToMove
{
    //    NSLog(@"Previous Delay: %f", previousShipDelay);
    //    NSLog(@"Previous Delay: %f", previousShipSpeed);
    //    int slowestSpeed = 8; //shipSpeed + 2;
    //    int fastestSpeed = 5; //shipSpeed - 1;
    
    //    float speed = arc4random()%(slowestSpeed-fastestSpeed+1)+fastestSpeed; // pick a random number between the 5 and 8
    //    NSLog(@"Speed: %f", speed);
    
    //    if (speed < previousShipSpeed + 1 && speed > previousShipSpeed - 1) {
    //        speed = previousShipSpeed + 1;
    //        NSLog(@"Changed Speed: %f", speed);
    //    }
    
    //    float delayInSeconds = arc4random()%(2-1+1)+1;
    //    NSLog(@"Current Delay: %f", delayInSeconds);
    
    //    if (delayInSeconds == previousShipDelay) {
    //        delayInSeconds = previousShipDelay + 1;
    //        NSLog(@"Changed Delay: %f", delayInSeconds);
    //    }
    
    
    //    id delayMove = [CCDelayTime actionWithDuration:delayInSeconds];
    id resetBool = [CCCallFunc actionWithTarget:self selector:@selector(setToFalse)];
    shipMove = [CCMoveTo actionWithDuration:shipSpeed position:screenCenter]; // initialize the action to run when the ship is appeneded to the layer
    [shipToMove runAction:[CCSequence actions:shipMove, resetBool, nil]]; // run the action initialized
    didRun = false;
    spriteMoveIndex++;
    //    previousShipDelay = delayInSeconds;
    //    previousShipSpeed = speed;
}

-(void) setToFalse
{
    didRun = false;
}

-(void) createShipCoord:(CCSprite *)shipForCoord topBottomChoose:(int) decidingVariable withColor:(int) color
{
    // Temporary way of generating random coordinates to spawn to
    int fromNumber = 0;
    int toNumber = 360;
    
    //    int fromNumber = 0;
    //    int toNumber = 320;
    
    //    if (decidingVariable == 1) {
    //        shipRandY = 500;
    //
    //        if (previousShipRandX == 0) {
    //            shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    //        } else {
    //            if (color == previousShipColor) {
    //                shipRandX = previousShipRandX;
    //            } else {
    //                shipRandX = previousShipRandX + ((arc4random()%(50-10+1))+10) + 100;
    //
    //            }
    //        }
    //    } else {
    //        shipRandY = -20;
    //
    //        if (previousShipRandX == 0) {
    //            shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    //        } else {
    //            if (color == previousShipColor) {
    //                shipRandX = previousShipRandX;
    //            } else {
    //                shipRandX = previousShipRandX - ((arc4random()%(50-10+1))+10) + 100;
    //            }
    //        }
    //    }
    //
    //
    //    shipForCoord.position = ccp(shipRandX, shipRandY);
    
    
    
    // THE KEVIN ALGORITHM
    
    /*   if (numSpritesPerArray == 1) {
     NSLog(@"HI");
     //        randGeneratedAngle = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
     //        shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
     if (color == 1) {
     NSLog(@"COLOR IS ORANGE");
     shipForCoord.position = [self generatePointByAngle:section1StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     
     if (color == 2) {
     NSLog(@"COLOR IS BLUE");
     shipForCoord.position = [self generatePointByAngle:section2StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     
     if (color == 3) {
     NSLog(@"COLOR IS GREEN");
     shipForCoord.position = [self generatePointByAngle:section3StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     } else {
     
     randGeneratedAngle = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
     
     if (color != previousShipColor) {
     // if the new sprite in the array is within 15 degrees of the previously generated angle
     //            if (randGeneratedAngle > previousGeneratedAngle - 15 && randGeneratedAngle < previousGeneratedAngle + 15) {
     //                randGeneratedAngle = previousGeneratedAngle + 120;
     //                shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
     //            } else {
     //                shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
     //            }
     
     if (color == 1) {
     NSLog(@"COLOR IS ORANGE");
     shipForCoord.position = [self generatePointByAngle:section1StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     
     if (color == 2) {
     NSLog(@"COLOR IS BLUE");
     shipForCoord.position = [self generatePointByAngle:section2StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     
     if (color == 3) {
     NSLog(@"COLOR IS GREEN");
     shipForCoord.position = [self generatePointByAngle:section3StartAngle + 60 distance:spawnDistance startPoint:screenCenter];
     }
     
     }
     
     if (color == previousShipColor) {
     if (randGeneratedAngle > previousGeneratedAngle - 50 && randGeneratedAngle < previousGeneratedAngle + 50)
     {
     shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
     
     } else {
     
     randGeneratedAngle = previousGeneratedAngle + 50;
     shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
     
     }
     }
     
     
     }
     
     previousGeneratedAngle = randGeneratedAngle;
     previousShipColor = color;
     
     //    NSLog(@"");
     
     //    previousShipRandX = shipRandX;
     //    previousShipColor = color; */
    if (createSpiralEffectWithCoords == true) {
        shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
        randGeneratedAngle += spiralIncrement;
    } else {
        randGeneratedAngle = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
        
        if (randGeneratedAngle == 270) { // for whatever reason when the angle is 270, the collision never works
            int chooseWhichSide = (arc4random()%(2-1+1))+1;
            if (chooseWhichSide == 1) {
                randGeneratedAngle = 271;
            } else if (chooseWhichSide == 2) {
                randGeneratedAngle = 272;
            }
        
        }
        shipForCoord.position = [self generatePointByAngle:randGeneratedAngle distance:spawnDistance startPoint:screenCenter];
    }
}


-(CGPoint) generatePointByAngle:(float) angle distance:(float) someDistance startPoint:(CGPoint) point
{
    //    NSLog(@"%f", angle);
    angle = CC_DEGREES_TO_RADIANS(angle);
    float addedX = cos(angle) * someDistance;
    float addedY = sin(angle) * someDistance;
    //    NSLog(@"ADDED X: %f", addedX);
    //    NSLog(@"ADDED Y: %f", addedY);
    //    NSLog(NSStringFromCGPoint(point));
    CGPoint endPoint = ccp(point.x + addedX, point.y + addedY);
    //     NSLog(NSStringFromCGPoint(endPoint));
    //    NSLog(NSStringFromCGPoint(endPoint));
    return endPoint;
}




-(void) enableSpiralEffect
{
    if (createSpiralEffectWithCoords == false) {
        [self removeAllSpritesFromArray];
        createSpiralEffectWithCoords = true;
        randGeneratedAngle = section1StartAngle + 60;
        numLivesForSpiral = 1;
        framesPassed = 0;
        
        [multiplierWrapper runAction:[CCFadeOut actionWithDuration:1.0f]];
        [multiplierLabel runAction:[CCFadeOut actionWithDuration:1.0f]];
        
        [scoreLabel runAction:[CCMoveTo actionWithDuration:1.0f position:ccp(multiplierLabel.position.x - 10, multiplierLabel.position.y)]];
        
        //    [MGWU showMessage:@"FURY MODE!" withImage:nil];
        [self flashLabel:@"FURY MODE!" actionWithDuration:5.0f color:@"red"];
    }
//    if ([section1Ships count] > 0) {
//        [section1Ships removeAllObjects];
//    }
//    int angle = 0;
//    spiralEffectPositions = [[NSMutableArray alloc] init];
//    section1Ships = [[NSMutableArray alloc] init];
//    for (int numAngles = 0; numAngles < [section1Ships count]; numAngles++)
//    {
//        CGPoint spiralPoint = [self generatePointByAngle:angle distance:spawnDistance startPoint:screenCenter];
//        [spiralEffectPositions addObject:spiralPoint];
//        angle += 10;
//        
//    }
}

-(void) disableSpiralEffect
{
    createSpiralEffectWithCoords = false;
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
//    if ((framesPassed % 10) == 0) {
//    while (playerScore < targetScore) {
//        playerScore += 1;
//        score = [[NSString alloc] initWithFormat:@"%i",playerScore];
//        [scoreLabel setString:score];
//    }
    
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
        //    [[NSUserDefaults standardUserDefaults] setObject:sharedScore forKey:@"sharedScore"];
        [MGWU setObject:sharedScore forKey:@"sharedScore"];
//    }
    if (warning == true) {
        warningLabel.visible = true;
        //        [warningLabel runAction:[CCFadeIn actionWithDuration:0.5]];
    } else {
        //        [warningLabel runAction:[CCFadeOut actionWithDuration:0.5f]];
        warningLabel.visible = false;
    }
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
        
        float distX = pos.x - screenCenter.x;
        float distY = pos.y - screenCenter.y;
        float touchDistance = sqrtf((distX * distX) + (distY * distY));
        
       
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
        
        
        
        // PAUSE BUTTON
        if ([input isAnyTouchOnNode:pauseButton touchPhase:KKTouchPhaseAny]) {
            
            [self pauseGame];
            
        }
        
//        startDbTapCheck = true;
//
//        if (dbTapFrames < 40 && dbTapFrames > 0) {
//            NSLog(@"DOUBLE TAP!");
//            startDbTapCheck = false;
//        }

    }


    if (input.touchesAvailable == true) {
//        userIsTapping = true;
        userIsTapping = false;
//        playerVelocity = 6.0f;
    } else {
        userIsTapping = false;
    }




    // momentum
    if ([input anyTouchBeganThisFrame] == true) {
        startRotationAngleForLog = player.rotation;
        [self schedule:@selector(momentumCount:)];
    }

    if ([input anyTouchEndedThisFrame])
    {
        [self unschedule:@selector(momentumCount:)];
        endRotationAngleForLog = player.rotation;
        
        if (endRotationAngleForLog < startRotationAngleForLog) {
            endRotationAngleForLog += 360;
        }
        
        
        int angleDiff = endRotationAngleForLog - startRotationAngleForLog;
        
        playerVelocity = angleDiff; //(angleDiff/360)/velocityFrames;
    }

}

-(void) momentumCount:(ccTime)dt
{
    velocityFrames = 0;
    velocityFrames++;
}


-(void) normalizeThisToStandards:(CGPoint) rot_pos1 andThis:(CGPoint) rot_pos2 withRotVariable:(float) rotationVar
{
    
}




-(void) initChallenges
{
    if (createSpiralEffectWithCoords == false) {
        // speed and fruit initialization delay modified by score
        if (playerScore < 20) {
            initDelayInFrames = 1; // there is only one sprite on screen, so there is no need to have a delay between initializations
            shipSpeed = 6.0f;
            // by default the numSpritesPerArray is set to 1
        }
        
        if (playerScore > 20) {
            
            initDelayInFrames = 80; //deviceFPS * 1.33333f; //80;
            shipSpeed = 6.0f;
            numSpritesPerArray = 2;
            
        }
        
        if (playerScore > 50) {
            
            shipSpeed = 5.5f;
            numSpritesPerArray = 3;
            
        }
        
        
        if (playerScore > 90) {
            
            numSpritesPerArray = 4;
            
        }
        
        if (playerScore > 200) {
            
            initDelayInFrames = 70; //deviceFPS * 1.16666667f; //70; // if the FPS is 60 the commented out numbers would make sense
            numSpritesPerArray = 6;
            shipSpeed = 5.0f;
            
        }
        
        if (playerScore > 400) {
            
            initDelayInFrames = 60; //deviceFPS; //60;
            numSpritesPerArray = 6;
            shipSpeed = 4.5f;
            
        }
        
        if (playerScore > 800) {
            
            initDelayInFrames = 50; //deviceFPS * 0.91666667f; //55;
            numSpritesPerArray = 7;
            shipSpeed = 4.3f;
            
        }
        
        if (playerScore > 1000) {
            initDelayInFrames = 40; //deviceFPS * 0.66666667f; //40;
            //        numSpritesPerArray = 8;
        }
        
        if (playerScore > 1300) {
            initDelayInFrames = 40; //deviceFPS * 0.66666667f; // 40;
            numSpritesPerArray = 8;
        }
        
        if (playerScore > 2000)
        {
            initDelayInFrames = 40; //deviceFPS * 0.66666667f; //40;
            numSpritesPerArray = 10;
        }
        
        if (playerScore > 2500)
        {
            initDelayInFrames = 40; //deviceFPS * 0.66666667f; //40;
            numSpritesPerArray = 11;
        }
        
        if (playerScore > 3000)
        {
            initDelayInFrames = 40; //35; //deviceFPS * 0.58333333f; //35;
            numSpritesPerArray = 12;
        }
        
        if (playerScore > 4000) // if the user makes it this far, definitely make it harder, making it this far is pretty impressive.
        {
            initDelayInFrames = 35; //deviceFPS * 0.58333333f; //35;
            numSpritesPerArray = 13;
            //        shipSpeed = 4.0f;
        }
        
        if (playerScore > 5000)
        {
            initDelayInFrames = 35; //deviceFPS * 0.58333333f; //35;
            numSpritesPerArray = 15;
            //        shipSpeed = 3.7f;
        }
        
        if (playerScore > 6000)
        {
            initDelayInFrames = 32; //deviceFPS * 0.53333333f; //32;
            numSpritesPerArray = 13;
            shipSpeed = 4.1f;
        }
        
        
        // multiplier decrease modified based on current point multiplier value
        if (pointMultiplier > 0 && pointMultiplier < 10) {
            multiplierDecrease = 1;
        }
        
        if (pointMultiplier > 10 && pointMultiplier < 20) {
            multiplierDecrease = 2;
        }
        
        if (pointMultiplier > 20 && pointMultiplier < 30) {
            multiplierDecrease = 3;
        }
        
        if (pointMultiplier > 30 && pointMultiplier < 50) {
            multiplierDecrease = 4;
        }
        
        if (pointMultiplier > 50 && pointMultiplier < 70) {
            multiplierDecrease = 5;
        }
        
        if (pointMultiplier > 70 && pointMultiplier < 90) {
            multiplierDecrease = 6;
        }
        
        if (pointMultiplier > 90 && pointMultiplier < 99) {
            multiplierDecrease = 8;
        }
        
    } else {
        
        if (framesPassed < 300) {
            shipSpeed = 2.5f;
            if (oniPad == true) {
                initDelayInFrames = 15;
            } else {
                initDelayInFrames = 25;
            }
            numSpritesPerArray = 200;
        }
        
        if (framesPassed > 300) {
//            shipSpeed = 3.0f;
            spiralIncrement = 87;
//            initDelayInFrames = 35;
//            numSpritesPerArray = 7;
        }
        
        if (framesPassed > 600) {
            shipSpeed = 2.5f;
            spiralIncrement = 127;
//            initDelayInFrames = 30 ;
//            numSpritesPerArray = 10;
        }
        
        if (framesPassed > 900) {
            shipSpeed = 2.5f;
            spiralIncrement = 167;
//            initDelayInFrames = 15;
//            initDelayInFrames = 35;
//            numSpritesPerArray = 13;
        }
        
        if (framesPassed > 1200) {
//            shipSpeed = 2.0f;
            spiralIncrement = 207;
//            initDelayInFrames = 30;
//            numSpritesPerArray = 17;
        }
        
        if (framesPassed > 1500) {
            shipSpeed = 2.0f;
            if (oniPad == true) {
                initDelayInFrames = 10;
            } else {
                initDelayInFrames = 20;
            }
            spiralIncrement = 247;
//            initDelayInFrames = 25;
//            numSpritesPerArray = 22;
        }
        
        if (framesPassed > 1800) {
            shipSpeed = 2.0f;
            spiralIncrement = 287;
//            initDelayInFrames = 25;
//            numSpritesPerArray = 27;
        }
        
        if (framesPassed > 2100) {
            shipSpeed = 2.0f;
            initDelayInFrames = 10;
            spiralIncrement = 327;
//            numSpritesPerArray = 35;
        }
        
        if (framesPassed > 2400) {
            shipSpeed = 1.5f;
//            initDelayInFrames = 10;
            spiralIncrement = 327;
            //            numSpritesPerArray = 35;
        }
    }
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

-(void) flashLabel:(NSString *) stringToFlashOnScreen actionWithDuration:(float) numSecondsToFlash color:(NSString *) colorString
{

    if ([colorString isEqualToString:@"red"] == true) {
        screenflashLabel.color = ccc3(255,0,0);
    }
    
    if ([colorString isEqualToString:@"blue"] == true) {
        screenflashLabel.color = ccc3(0,0,255);
    }
    
    if ([colorString isEqualToString:@"green"] == true) {
        screenflashLabel.color = ccc3(0,255,0);
    }
    
    if ([colorString isEqualToString:@"black"] == true) {
        screenflashLabel.color = ccc3(0,0,0);
    }
    
    if ([colorString isEqualToString:@"white"] == true) {
        screenflashLabel.color = ccc3(255,255,255);
    }
    
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

-(NSString *) deviceInfo
{
    NSString *currentDevice;
    if ([[CCDirector sharedDirector] winSizeInPixels].height == 480) {
        currentDevice = @"iPhone";
    } else if ([[CCDirector sharedDirector] winSizeInPixels].height == 960) {
        currentDevice = @"iPhone Retina";
    } else if ([[CCDirector sharedDirector] winSizeInPixels].height == 1136) {
        currentDevice = @"iPhone 5";
    } else if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024) {
        currentDevice = @"iPad";
    } else if ([[CCDirector sharedDirector] winSizeInPixels].height == 2048) {
        currentDevice = @"iPad Retina";
    }
    
    return currentDevice;
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
//    playerVelocity = 100.0f;
    
    startDbTapCheck = false;
    
    
    oniPad = false;
    spiralIncrement = 47;
    explodedAlready = false;
    numLivesForSpiral = 1;
    p1Enabled = false;
    p2Enabled = false;
    p3Enabler = false;
    initCounter = 0;
    frameCountForShipInit = 0;
    initDelayInFrames = 90;
    didRun = false;
    updateMoveCounter = false;
    gameOver = false;
    // reset all game variables
    shipSpeed = 7.5f; // default speed
    playerScore = 0;
    startLives = 10;
    playerLives = 10;
    framesPassed = 0;
    secondsPassed = 0;
    numCollisions = 0;
    livesSubtract = 1;
    scoreAdd = 5;
    pointMultiplier = 2; // starting multiplier to prevent killing the user almost instantly
    
    moveDelayInFrames = 20;
    
    previousShipRandX = 0;
    
    spawnDistance = 350.f;
    
    generationInterval = 700;
    
    
    warning = false;
    collisionDidHappen = false;
    
    numSpritesCollided = 0;
    numSpritesCollidedWithShield = 0;
    
    numSpritesPerArray = 1;
    
    spriteTagNum = 0;
    
    rotation = 0.0f;
    
    multiplierDecrease = 1;
    
    // grab powerup values
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"power1Status"] == nil) {
        numPower1Left = 1;
    } else {
        numPower1Left = [[NSUserDefaults standardUserDefaults] integerForKey:@"power1Status"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"power2Status"] == nil) {
        numPower2Left = 5;
    } else {
        numPower2Left = [[NSUserDefaults standardUserDefaults] integerForKey:@"power2Status"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"power3Status"] == nil) {
        numPower3Left = 3;
    } else {
        numPower3Left = [[NSUserDefaults standardUserDefaults] integerForKey:@"power3Status"];
    }
    
    numTimesP1Used = 5;
    numTimesP2Used = numPower2Left;
    numTimesP3Used = numPower3Left;
    
    timeShieldEnabled = 10.0f;
    
    
    bool tutorialStatusCheck = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialStatus"];
    
    if (tutorialStatusCheck == nil) {
        playedTutorial = false;
    } else {
        playedTutorial = [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialStatus"];
    }
    
    
    NSNumber *curHighScore = [MGWU objectForKey:@"sharedHighScore"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
    playerHighScore = [curHighScore intValue]; // read from the devices memory
    
    NSNumber *curCoins = [MGWU objectForKey:@"sharedCoins"]; //[[NSUserDefaults standardUserDefaults] objectForKey:@"sharedCoins"];
    playerCoins = [curCoins intValue]; // read from devices memory
}

-(void) gameOver
{
//    if ([section1Ships count] > 0) {
//        [section1Ships removeAllObjects];
//    }
//    [section2Ships removeAllObjects];
//    [section2Ships removeAllObjects];
//    [self removeChild:ship1];
//    [self removeChild:ship2];
//    [self removeChild:ship3];
    explodedAlready = true;
    gameOver = true;
    if (playerHighScore == 0) {
        playerHighScore = playerScore;
        sharedHighScore = [NSNumber numberWithInteger:playerHighScore];
        //        [[NSUserDefaults standardUserDefaults] setObject:sharedHighScore forKey:@"sharedHighScore"];
        [MGWU setObject:sharedHighScore forKey:@"sharedHighScore"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"newHighScore"];
    }
    
    if (playerScore > playerHighScore) {
        playerHighScore = playerScore;
        sharedHighScore = [NSNumber numberWithInteger:playerHighScore];
        //        [[NSUserDefaults standardUserDefaults] setObject:sharedHighScore forKey:@"sharedHighScore"];
        [MGWU setObject:sharedHighScore forKey:@"sharedHighScore"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"newHighScore"];
    }
    
    if (playerCoins == 0) {
        playerCoins = playerScore;
        sharedCoins = [NSNumber numberWithInteger:playerCoins];
        //        [[NSUserDefaults standardUserDefaults] setObject:sharedCoins forKey:@"sharedCoins"];
        [MGWU setObject:sharedCoins forKey:@"sharedCoins"];
    }
    if (playerCoins > 0) {
        playerCoins = playerCoins + playerScore;
        sharedCoins = [NSNumber numberWithInteger:playerCoins];
        //        [[NSUserDefaults standardUserDefaults] setObject:sharedCoins forKey:@"sharedCoins"];
        [MGWU setObject:sharedCoins forKey:@"sharedCoins"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:numPower1Left forKey:@"power1Status"];
    [[NSUserDefaults standardUserDefaults] setInteger:numPower2Left forKey:@"power2Status"];
    [[NSUserDefaults standardUserDefaults] setInteger:numPower3Left forKey:@"power3Status"];
    
    
    //    NSNumber *savedHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"sharedHighScore"];
    //    NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //    [MGWU submitHighScore:[savedHighScore intValue] byPlayer:savedUser forLeaderboard:@"defaultLeaderboard"];
    
    [self goToGameOver];
}

-(void) pauseGame
{
    [[CCDirector sharedDirector] pushScene:
	 [CCTransitionFadeBL transitionWithDuration:0.5f scene:[PauseLayer node]]];
}

-(void) updateCollisionCounter
{
    NSUInteger previousCount;
    
    int numTimesIndexMoves = 0;
    NSUInteger previousIndexMoves = 0;
    
    int previousIndex = 0;
    
    for (int a = 0; a < [section1Ships count]; a++)
    {
        CCSprite *spriteToMove = [section1Ships objectAtIndex:a];
        if ((numFramesBetweenCollisions % moveDelayInFrames) == 0) {
            if ([section1Ships count] != previousCount) {
                if (didRun == false) {
                    [self moveShip:spriteToMove];
                    didRun = true;
                }
            }
            previousCount = [section1Ships count];
        }
    }
}

-(void) updateMoveDelayCounter:(ccTime) dt
{
    numFramesBetweenCollisions++;
}




-(void) initializeTheShipArray:(ccTime) dt
{
    frameCountForShipInit++;
    if ((frameCountForShipInit % initDelayInFrames) == 0)
    {
        if (initCounter < numSpritesPerArray) {
            [self initializeShip1Sprite];
            initCounter++;
        } else {
            [self unschedule:@selector(initializeTheShipArray:)];
            initCounter = 0;
            frameCountForShipInit = 0;
        }
    }
}




-(void)update:(ccTime)dt // update method
{
    deviceFPS = 1/dt;
    
    
    if (playerScore < targetScore) {
        int increment = (targetScore - playerScore)/2;
        if (increment < 1) {
            increment = 1;
        }
        playerScore += increment;
        NSNumber *formattedScore = [NSNumber numberWithInt:playerScore];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [numberFormatter setGroupingSeparator:@","];
        NSString* scoreStr = [numberFormatter stringForObjectValue:formattedScore];
        
        
        score = scoreStr; //[[NSString alloc] initWithFormat:@"%i",playerScore];
        [scoreLabel setString:score];
    }

    if (userIsTapping == false) {
//        player.rotation += playerVelocity;
        if (playerVelocity <= 0) {
            playerVelocity = 0.0f;
        } else {
            playerVelocity -= 0.5f;
        }
    }
    
//    playerMomentum = velocityFrames * playerVelocity;
//    NSLog(@"%i", playerMomentum);
    if ((framesPassed % 20) == 0) {
//        NSLog(@"%f", playerVelocity);
        if (playerVelocity > 0) {
            playerVelocity = sqrtf(playerVelocity);
        }
    }
    
//    player.rotation += playerVelocity;
    
    collisionDidHappen = false;
    
    if (updateMoveCounter == true) {
        numFramesBetweenCollisions++;
    }
    
    framesPassed++;
    secondsPassed = framesPassed/60; // divide by framerate;
    
//    if (framesPassed == 120) {
//        [section1 setTexture:[[CCTextureCache sharedTextureCache] addImage:@"element1.png"]];
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
//    [self updateScore]; // update the labels for player data
    [self updateEffectPositions];
    [self initChallenges]; // start challenges to throw at the player
}

@end