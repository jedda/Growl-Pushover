//
//  GrowlGrowlPushoverAction.m
//  GrowlPushover
//
//  Created by Jedda Wignall on 28/11/12.
//  Copyright (c) 2012 Jedda Wignall. All rights reserved.
//
//  This class is where the main logic of dispatching a notification via your plugin goes.
//  There will be only one instance of this class, so use the configuration dictionary for figuring out settings.
//  Be aware that action plugins will be dispatched on the default priority background concurrent queue.
//  

#import "GrowlGrowlPushoverAction.h"
#import "GrowlGrowlPushoverPreferencePane.h"

@implementation GrowlGrowlPushoverAction

/* Dispatch a notification with a configuration, called on the default priority background concurrent queue
 * Unless you need to use UI, do not send something to the main thread/queue.
 * If you have a requirement to be serialized, make a custom serial queue for your own use. 
 */
-(void)dispatchNotification:(NSDictionary *)notification withConfiguration:(NSDictionary *)configuration {
}

/* Auto generated method returning our PreferencePane, do not touch */
- (GrowlPluginPreferencePane *) preferencePane {
	if (!preferencePane)
		preferencePane = [[GrowlGrowlPushoverPreferencePane alloc] initWithBundle:[NSBundle bundleWithIdentifier:@"me.jedda.GrowlPushover"]];
	
	return preferencePane;
}

@end
