/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

// NOT OPTIMIZED FOR 4-Inch RETINA SCREENS YET
/*
 CURRENT BUGS:
 - SHIP COMBOS DO NOT EFFECTIVELY WORK WITHOUT BREAKING COLLISION DETECTION
 - NOT ALL 360 DEGREES OF WORK WHEN DIVIDING THE PLAYER INTO 3 SECTIONS
 - SOMETIMES FAILS TO GIVE POINTS WHEN SHIP LANDS IN CORRECT SECTION
 - COLLISION DETECTION needs to be more accurate
 
 */


#import "HelloWorldLayer.h"

@interface HelloWorldLayer (PrivateMethods)
@end

@implementation HelloWorldLayer

float distance;
float radii;
int numCollisions;

CCLabelBMFont *warningLabel;
bool warning = false;

-(id) init
{
	if ((self = [super init]))
	{
        // initialize game variables
		glClearColor(255, 255, 255, 255); // default background color
        director = [CCDirector sharedDirector];
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = CGPointMake(size.width/2, size.height/2);
        shipSpeed = 6.4f; // default speed
        playerScore = 0;
        playerLives = 5;
        framesPassed = 0;
        secondsPassed = 0;
        
        player = [[CCSprite alloc] init];
        player = [CCSprite spriteWithFile:@"border.png"];
        player.position = ccp(size.width/2, size.height/2);
        playerWidth = [player boundingBox].size.width; // get player width
        [self addChild:player z:1];
        
        section1 = [CCSprite spriteWithFile:@"section1.png"];
        progressBar1 = [CCProgressTimer progressWithSprite:section1];
        progressBar1.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar1 z:1];
        progressBar1.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //        [progressBar1 setAnchorPoint:zero];
        progressTo1 = [CCProgressTo actionWithDuration:2 percent:33.3f];
        
        section2 = [CCSprite spriteWithFile:@"section2.png"];
        progressBar2 = [CCProgressTimer progressWithSprite:section2];
        progressBar2.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar2 z:2];
        progressBar2.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar2.rotation = 120.0f;
        progressTo2 = [CCProgressTo actionWithDuration:2 percent:33.3f];
        
        section3 = [CCSprite spriteWithFile:@"section3.png"];
        progressBar3 = [CCProgressTimer progressWithSprite:section3];
        progressBar3.type = kCCProgressTimerTypeRadial;
        [player addChild:progressBar3 z:2];
        progressBar3.position = ccp(size.width/2 - 65, size.height/2 - 145);
        //   [progressBar2 setAnchorPoint:zero];
        progressBar3.rotation = 240.0f;
        progressTo3 = [CCProgressTo actionWithDuration:2 percent:33.3f];
        
        [progressBar1 runAction:progressTo1];
        [progressBar2 runAction:progressTo2];
        [progressBar3 runAction:progressTo3];
        
        // score label
        score = [[NSString alloc]initWithFormat:@"Score: %i", playerScore];
        scoreLabel = [CCLabelTTF labelWithString:score fontName:@"HelveticaNeue-Light" fontSize:25];
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
        [self addChild:warningLabel z:100];
        
        
        ship1 = [[CCSprite alloc] init];
        ship1 = [CCSprite spriteWithFile:@"section1.png"];
        ship1.scale = 0.15f;
        
        [self divideAngularSections];
        
        [self pickColor];
        [self initShips];
        
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



// Collision DETECTION
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
    float ratio = distY/distance; // ratio of distance in terms of Y to distance from player
    float shipAngleRadians = asin(ratio); // arcsin of ratio
    float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
    //    float shipAngle; // shipAngle
    
    CGPoint pos1 = [circle1 position];
    CGPoint pos2 = [circle2 position];
    
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
        
        [self divideAngularSections];
        numCollisions++;
        NSLog(@"%f", shipAngle);
        //            NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
        //            NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
        //            NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
        //            NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
        //            NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
        //            NSLog(@"Section 3 EndAngle: %f", section3EndAngle);
        [self scoreCheck:shipAngle withColor:shipColor];
        if ((numCollisions - playerScore) > playerLives) {
            [self removeChild:circle2 cleanup:YES];
            [self initShips];
            warning = true;
        } else {
            [self removeChild:circle2 cleanup:YES];
            [self initShips];
        }
        //        }
    }
}

-(void) scoreCheck:(int) angle withColor: (int) color
{
    if (shipColor == 1)
    {
//        if (section1StartAngle > section1EndAngle) {
            [self divideAngularSections];
            if (angle < section1StartAngle && angle > section1EndAngle) {
                playerScore = playerScore + 1;
            } else {
                // carry on with checking for collisions
                [self divideAngularSections];
            }
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
//        if (section2StartAngle > section2EndAngle) {
            [self divideAngularSections];
            if (angle < section2StartAngle && angle > section2EndAngle) {
                playerScore = playerScore + 1;
            } else {
                // carry on with checking for collisions
                [self divideAngularSections];
            }
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
        
    }
    else if (shipColor == 3)
    {
//        if (section3StartAngle > section3EndAngle) {
            [self divideAngularSections];
            if (angle < section3StartAngle && angle > section3EndAngle) {
                playerScore = playerScore + 1;
            } else {
                // carry on with checking for collisions
                [self divideAngularSections];
            }
//        }
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






// INITIALIZE SHIPS
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
        ship1 = [CCSprite spriteWithFile:@"section1.png"];
        ship1.scale = 0.15;
        //        [self initSect1Ships];
    }
    
    if (shipColor == 2) {
        ship1 = [CCSprite spriteWithFile:@"section2.png"];
        ship1.scale = 0.15;
        //        [self initSect2Ships];
    }
    
    if (shipColor == 3) {
        ship1 = [CCSprite spriteWithFile:@"section3.png"];
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
    int fromNumber = 100;
    int toNumber = 600;
    shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    if (shipRandX < 320) {
        shipRandX = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    }
    
    if (shipRandY < 480) {
        shipRandY = (arc4random()%(toNumber-fromNumber+1))+fromNumber;
    }
    
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
    section3StartAngle = section2EndAngle; // the line below's problem applies to this line
    section3EndAngle = section1StartAngle; // right now does not work for some reason
    //    [self normalizeAngle:section1StartAngle];
    //    [self normalizeAngle:section1EndAngle];
    //    [self normalizeAngle:section2StartAngle];
    //    [self normalizeAngle:section2EndAngle];
    //    [self normalizeAngle:section3StartAngle];
    //    [self normalizeAngle:section3EndAngle];
    
    
    //    NSLog(@"%f", player.rotation);
    /*    NSLog(@"Section 1 StartAngle: %f", section1StartAngle);
     NSLog(@"Section 1 EndAngle: %f", section1EndAngle);
     NSLog(@"Section 2 StartAngle: %f", section2StartAngle);
     NSLog(@"Section 2 EndAngle: %f", section2EndAngle);
     NSLog(@"Section 3 StartAngle: %f", section3StartAngle);
     NSLog(@"Section 3 EndAngle: %f", section3EndAngle); */
}

-(void) normalizeAngle:(float) angleInput
{
    while (angleInput > 360) {
        angleInput = angleInput - 360;
    }
}

-(void) handleUserInput
{
    KKInput *input = [KKInput sharedInput];
    if(input.touchesAvailable)
    {
        [self divideAngularSections];
        CGPoint pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
        //        player.rotation = ((pos.x/360)*360) * (-1);
        float distX = pos.x - screenCenter.x;
        float distY = pos.y - screenCenter.y;
        float touchDistance = sqrtf((distX * distX) + (distY * distY));
        
        //            [self circleCollisionWithSprite:c];
        float ratio = distY/touchDistance; // ratio of distance in terms of Y to distance from player
        float shipAngleRadians = asin(ratio); // arcsin of ratio
        float antiShipAngle = CC_RADIANS_TO_DEGREES(shipAngleRadians) * (-1); // convert to degrees from radians
        //        float rotation = antiShipAngle; // shipAngle
        CGPoint pos1 = [player position];
        CGPoint pos2 = pos;
        
        float theta = atan((pos1.y-pos2.y)/(pos1.x-pos2.x)) * 180 / M_PI;
        
        float rotation;
        
        if(pos1.y - pos2.y > 0)
        {
            if(pos1.x - pos2.x < 0)
            {
                rotation = (-90-theta);
            }
            else if(pos1.x - pos2.x > 0)
            {
                rotation = (90-theta);
            }
        }
        else if(pos1.y - pos2.y < 0)
        {
            if(pos1.x - pos2.x < 0)
            {
                rotation = (270-theta);
            }
            else if(pos1.x - pos2.x > 0)
            {
                rotation = (90-theta);
            }
        }
        
        if (rotation < 0)
        {
            rotation+=360;
        }
        
        //        [player runAction:[CCRotateTo actionWithDuration:0.1f angle:rotation]];
        
        
        //        NSLog(@"Rotation: %f", rotation);
        player.rotation = rotation;
        //        NSLog(@"%f", player.rotation);
        [self divideAngularSections];
    }
}

-(void) initChallenges
{
    // challenge 1
    if (playerScore > 9) {
        shipSpeed = 0.8f;
    }
    
    if (playerScore > 11) {
        shipSpeed = 1.1f;
    }
}

-(void) gameOver
{
    NSLog(@"Game Over!");
}

-(void)update:(ccTime)dt // update method
{
    framesPassed++;
    secondsPassed = framesPassed/60; // divide by framerate;
    // if ((framesPassed % 100) == 0) {
    //        NSLog(@"New Ship Generated!");
    //    [self initShips];
    //} else {
    // do nothing
    // }
    [self circleCollisionWithSprite:player andThis:ship1];
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
    //    [self initChallenges];
}

@end
