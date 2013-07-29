/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
//    [MGWU loadMGWU:@"LKcMLg20iO299nlPvawDquypxmnEomMVRhnasium3NVVFD0IuTL9hKbL15AeIoyBN5bQU9AjAZEYB8hlK6IbfozjyXEW9hPRGTky"];
//    [MGWU preFacebook]; //Temporarily disables Facebook until you integrate it later

#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
    
    
    [MGWU loadMGWU:@"natcrvZe5ytd9slSi2juce99D7Km0qeWI8OGvUgIWlKihnOvpOk6MXZY1cXasdahskdashdkajshIhjahdskjaPau83u"];
//    [MGWU preFacebook]; //Temporarily disables Facebook until you integrate it later
    
    //In Kobold+iOS 5 the call to initializationComplete occurs after applicationDidBecomeActive
	//This causes a problem in the mgwuSDK, so here is dirty hack to fix it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
		[[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
}

-(id) alternateView
{
	return nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    return [MGWU handleURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [director stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [director startAnimation];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
    [director pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [director resume];
}

@end
