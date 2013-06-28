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
    
    [MGWU loadMGWU:@"natcrvZe5ytd9slSi2juce99D7Km0qeWI8OGvUgIWlKihnOvpOk6MXZY1cXy7VkduwchOwBgWshqj5VNBCZ2i3ARAOK1IgQkn7SP"];
    [MGWU preFacebook]; //Temporarily disables Facebook until you integrate it later
}

-(id) alternateView
{
	return nil;
}

@end
