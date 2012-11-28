//
//  GrowlPushoverAction.m
//
//  Growl-Pushover
//  An action style for Growl 2.0 and higher that forwards messages to the Pushover notification service.
//  http://jedda.me/projects/pushover-action-growl/
//
//  Created by Jedda Wignall on 28/11/12.
//  This work is licensed under a Creative Commons Attribution 3.0 Unported License.
//  http://creativecommons.org/licenses/by/3.0/deed.en_US

#include <IOKit/IOKitLib.h>

#import "GrowlPushoverAction.h"
#import "GrowlPushoverPreferencePane.h"

@implementation GrowlPushoverAction

@synthesize preferencePaneInstance;

#define GrowlPushoverDefaultApplicationKey   @"YIgWXD9AnVZXf9qF0Y7rw5eAnUCouO"

/* Dispatch a notification with a configuration, called on the default priority background concurrent queue
 * Unless you need to use UI, do not send something to the main thread/queue.
 * If you have a requirement to be serialized, make a custom serial queue for your own use. 
 */
-(void)dispatchNotification:(NSDictionary *)notification withConfiguration:(NSDictionary *)configuration {
    
    // are we waiting for this mac to be idle?
    if ([[configuration valueForKey:@"onlyIfIdle"] boolValue] && SystemIdleTime() < 300) {
        // system idle for less than 5 minutes. do not notify.
        return;
    }
    // do we need to wait for a specific priority?
    if ([[configuration valueForKey:@"onlyIfPriority"] boolValue] && ([[notification objectForKey:@"NotificationPriority"] intValue] < [[configuration valueForKey:@"minimumPriority"] intValue] ) ) {
        // notification does not meet minimum priority. do not notify.
        return;
    }
    
    [self sendPushoverNotificationWithGrowlNotification:notification configuration:configuration];
}


- (BOOL) sendPushoverNotificationWithGrowlNotification:(NSDictionary *)notification configuration:(NSDictionary *)configuration {
    
    NSString *paramString = [NSString string];
    
    // append the app token. are we using ours, or a custom one from the user?
    if ([configuration valueForKey:@"pushoverAppKey"]) {
        paramString = [paramString stringByAppendingFormat:@"token=%@", [configuration valueForKey:@"pushoverAppKey"]];
    } else {
        paramString = [paramString stringByAppendingFormat:@"token=%@", GrowlPushoverDefaultApplicationKey];
    }
    paramString = [paramString stringByAppendingString:@"&"];
    paramString = [paramString stringByAppendingFormat:@"user=%@", [configuration valueForKey:@"pushoverUserKey"]];
    
    // append the message/description
    paramString = [paramString stringByAppendingString:@"&"];
    if ([[notification objectForKey:@"NotificationDescription"] isEqualToString:@""]) {
        paramString = [paramString stringByAppendingString:@"message=No Description"];
    } else {
        paramString = [paramString stringByAppendingFormat:@"message=%@", [notification objectForKey:@"NotificationDescription"] ];
    }
    
    // append the title
    paramString = [paramString stringByAppendingString:@"&title="];
    // do we need to append a prefix?
    if ([[configuration valueForKey:@"usePrefix"] boolValue]) {
        paramString = [paramString stringByAppendingFormat:@"%@", [configuration valueForKey:@"prefixString"] ];
    }
    paramString = [paramString stringByAppendingFormat:@"%@", [notification objectForKey:@"NotificationTitle"] ];
    
    // check to see if we are sending to a specific pushover device
    if ([[configuration valueForKey:@"onlyToSpecificDevice"] boolValue]) {
        paramString = [paramString stringByAppendingFormat:@"&device=%@", [configuration valueForKey:@"specificDeviceString"] ];
    }
        
    NSMutableURLRequest *pushoverRequest =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.pushover.net/1/messages.json"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];;
    pushoverRequest.HTTPBody = [[paramString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    pushoverRequest.HTTPMethod = @"POST";
        
    NSError *connectionError;
    NSHTTPURLResponse *connectionResponse;
    
    NSData *apiResponse = [NSURLConnection sendSynchronousRequest:pushoverRequest returningResponse:&connectionResponse error:&connectionError];
        
    switch (connectionResponse.statusCode) {
            
        case 200:
            if (preferencePaneInstance) {
                preferencePaneInstance.testStatusField.stringValue = @"Pushover notification sent successfully!";
            }
            return TRUE;
            break;
            
        case 429:
            NSLog(@"Error - Our app has reached the message limit!");
            if (preferencePaneInstance) {
                preferencePaneInstance.testStatusField.stringValue = @"Exceeded message limit. Perhaps use a custom key.";
            }
            break;
            
        default:
            // attempt to load JSON response, and parse error
            if (![self processErrorFromJSONData:apiResponse]) {
                // error was not handled specifically. sadness.
                NSLog(@"GrowlPushover - Invalid JSON back from API.");
                if (preferencePaneInstance) {
                    preferencePaneInstance.testStatusField.stringValue = @"Problem with Pushover API. Try again later?";
                }
            }
            break;
    }
    
    return FALSE;
    
}

- (BOOL) processErrorFromJSONData:(NSData*)jsonData {
    
    NSError *jsonError;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    if (!responseDict && jsonError) { return FALSE; }
    
    if (preferencePaneInstance) {
        // we are being called as a test
        preferencePaneInstance.testStatusField.stringValue = [[[responseDict objectForKey:@"errors"] firstObject] capitalizedString];
    }
    
    return TRUE;
}

#pragma mark System Idle Time Methods

/**
Thanks to Dan at http://www.danandcheryl.com/2010/06/how-to-check-the-system-idle-time-using-cocoa)
for the following SystemIdleTime() method.
**/

int64_t SystemIdleTime(void) {
    int64_t idlesecs = -1;
    io_iterator_t iter = 0;
    if (IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IOHIDSystem"), &iter) == KERN_SUCCESS) {
        io_registry_entry_t entry = IOIteratorNext(iter);
        if (entry) {
            CFMutableDictionaryRef dict = NULL;
            if (IORegistryEntryCreateCFProperties(entry, &dict, kCFAllocatorDefault, 0) == KERN_SUCCESS) {
                CFNumberRef obj = CFDictionaryGetValue(dict, CFSTR("HIDIdleTime"));
                if (obj) {
                    int64_t nanoseconds = 0;
                    if (CFNumberGetValue(obj, kCFNumberSInt64Type, &nanoseconds)) {
                        idlesecs = (nanoseconds >> 30); // Divide by 10^9 to convert from nanoseconds to seconds.
                    }
                }
                CFRelease(dict);
            }
            IOObjectRelease(entry);
        }
        IOObjectRelease(iter);
    }
    return idlesecs;
}

#pragma mark Required Growl Preference Methods

/* Auto generated method returning our PreferencePane, do not touch */
- (GrowlPluginPreferencePane *) preferencePane {
	if (!preferencePane)
		preferencePane = [[GrowlPushoverPreferencePane alloc] initWithBundle:[NSBundle bundleWithIdentifier:@"me.jedda.GrowlPushover"]];
	
	return preferencePane;
}

@end
