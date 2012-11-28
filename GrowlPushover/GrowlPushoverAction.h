//
//  GrowlPushoverAction.h
//
//  Growl-Pushover
//  An action style for Growl 2.0 and higher that forwards messages to the Pushover notification service.
//  http://jedda.me/projects/pushover-action-growl/
//
//  Created by Jedda Wignall on 28/11/12.
//  This work is licensed under a Creative Commons Attribution 3.0 Unported License.
//  http://creativecommons.org/licenses/by/3.0/deed.en_US

#import <GrowlPlugins/GrowlActionPlugin.h>
#import "GrowlPushoverPreferencePane.h"

@interface GrowlPushoverAction : GrowlActionPlugin <GrowlDispatchNotificationProtocol>

@property GrowlPushoverPreferencePane *preferencePaneInstance;

- (BOOL) sendPushoverNotificationWithGrowlNotification:(NSDictionary *)notification configuration:(NSDictionary *)configuration;
- (BOOL) processErrorFromJSONData:(NSData*)jsonData;
int64_t SystemIdleTime(void);

@end
