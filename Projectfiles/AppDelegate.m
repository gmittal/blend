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
    NSLog(@"Test");
    [MGWU loadMGWU:@"natcrvZe5ytd9slSi2juce99D7Km0qeWI8OGvUgIWlKihnOvpOk6MXZY1cXy7VkduwchOwBgWshqj5VNBCZ2i3ARAOK1IgQkn7SP"];
        
    [MGWU dark];
    
    [MGWU noFacebookPrompt];
    
    [MGWU setReminderMessage:@"Come back and blend!"];
    
    [MGWU setTapjoyAppId: @"b4a93922-6209-4067-b0a3-a19320f68d0d" andSecretKey:@"1tb9JRwRw1OvePawxCIB"];
    
    [MGWU setAppiraterAppId:@"725766849" andAppName:@"Blend"];
    
    [MGWU useCrashlyticsWithApiKey:@"9fe93cfe42c0da72e3d0b1a0aa49822003c415a5"];
        
    [MGWU useIAPs];
    
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)tokenId {
    [MGWU registerForPush:tokenId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [MGWU gotPush:userInfo];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [MGWU failedPush:error];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [MGWU gotLocalPush:notification];
}

@end
