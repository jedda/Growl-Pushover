//
//  GrowlPushoverPreferencePane.m
//
//  Growl-Pushover
//  An action style for Growl 2.0 and higher that forwards messages to the Pushover notification service.
//  http://jedda.me/projects/pushover-action-growl/
//
//  Created by Jedda Wignall on 28/11/12.
//  This work is licensed under a Creative Commons Attribution 3.0 Unported License.
//  http://creativecommons.org/licenses/by/3.0/deed.en_US

#import "GrowlPushoverPreferencePane.h"
#import "GrowlPushoverAction.h"

@implementation GrowlPushoverPreferencePane

@synthesize  soundListButton, specificDeviceStringField, priorityListButton, prefixStringField;
@synthesize  testStatusField;

-(NSString*)mainNibName {
	return @"GrowlPushoverPrefPane";
}

/* This returns the set of keys the preference pane needs updated via bindings 
 * This is called by GrowlPluginPreferencePane when it has had its configuration swapped
 * Since we really only need a fixed set of keys updated, use dispatch_once to create the set
 */
- (NSSet*)bindingKeys {
	static NSSet *keys = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		keys = [NSSet setWithObjects:@"pushoverUserKey", @"onlyIfIdle", @"useCustomSound", @"customSoundName", @"onlyToSpecificDevice", @"specificDeviceString", @"onlyIfPriority", @"minimumPriority", @"usePrefix", @"prefixString", @"pushoverAppKey", nil];
        NSLog(@"BindingKeysBeingCalled");
	});
	return keys;
}

/* This method is called when our configuration values have been changed 
 * by switching to a new configuration.  This is where we would update certain things
 * that are unbindable.  Call the super version in order to ensure bindingKeys is also called and used.
 * Uncomment the method to use.
 */

-(void)updateConfigurationValues {
	[super updateConfigurationValues];
    
    if ([[self.configuration valueForKey:@"useCustomSound"] boolValue]) {
        [soundListButton setEnabled:TRUE];
    } else {
        [soundListButton setEnabled:FALSE];
    }
    
    if ([[self.configuration valueForKey:@"onlyIfPriority"] boolValue]) {
        [priorityListButton setEnabled:TRUE];
    } else {
        [priorityListButton setEnabled:FALSE];
    }
    
    if ([[self.configuration valueForKey:@"usePrefix"] boolValue]) {
        [prefixStringField setEnabled:TRUE];
    } else {
        [prefixStringField setEnabled:FALSE];
    }
    
    if ([[self.configuration valueForKey:@"onlyToSpecificDevice"] boolValue]) {
        [specificDeviceStringField setEnabled:TRUE];
    } else {
        [specificDeviceStringField setEnabled:FALSE];
    }

}

- (IBAction)testPushoverSettings:(id)sender {
    [self.mainView.window makeFirstResponder:sender];
    GrowlPushoverAction *pushoverAction = [[GrowlPushoverAction alloc] init];
    pushoverAction.preferencePaneInstance = self;
    NSDictionary* testNotification = [NSDictionary dictionaryWithObjectsAndKeys: @"Test Notification", @"NotificationTitle", @"This is a test notification.", @"NotificationDescription", nil];
    [pushoverAction sendPushoverNotificationWithGrowlNotification:testNotification configuration:self.configuration];
}

- (NSString*)pushoverUserKey { return [self.configuration valueForKey:@"pushoverUserKey"]; }

- (void)setPushoverUserKey:(NSString*)pushoverUserKey {
  [self setConfigurationValue:pushoverUserKey forKey:@"pushoverUserKey"];
}

- (BOOL)onlyIfIdle { return [[self.configuration valueForKey:@"onlyIfIdle"] boolValue]; }

- (void)setOnlyIfIdle:(BOOL)onlyIfIdle {
    [self setConfigurationValue:[NSNumber numberWithBool:onlyIfIdle] forKey:@"onlyIfIdle"];
}

- (BOOL)useCustomSound { return [[self.configuration valueForKey:@"useCustomSound"] boolValue]; }

- (void)setUseCustomSound:(BOOL)useCustomSound {
    [self setConfigurationValue:[NSNumber numberWithBool:useCustomSound] forKey:@"useCustomSound"];
    [self updateConfigurationValues];
}

- (NSString*)customSoundName { return [self.configuration valueForKey:@"customSoundName"]; }

- (void)setCustomSoundName:(NSString*)customSoundName {
    [self setConfigurationValue:customSoundName forKey:@"customSoundName"];
}

- (BOOL)onlyToSpecificDevice { return [[self.configuration valueForKey:@"onlyToSpecificDevice"] boolValue]; }

- (void)setOnlyToSpecificDevice:(BOOL)onlyToSpecificDevice {
    [self setConfigurationValue:[NSNumber numberWithBool:onlyToSpecificDevice] forKey:@"onlyToSpecificDevice"];
    [self updateConfigurationValues];
}

- (NSString*)specificDeviceString { return [self.configuration valueForKey:@"specificDeviceString"]; }

- (void)setSpecificDeviceString:(NSString*)specificDeviceString {
    [self setConfigurationValue:specificDeviceString forKey:@"specificDeviceString"];
}

- (BOOL)onlyIfPriority { return [[self.configuration valueForKey:@"onlyIfPriority"] boolValue]; }

- (void)setOnlyIfPriority:(BOOL)onlyIfPriority {
    [self setConfigurationValue:[NSNumber numberWithBool:onlyIfPriority] forKey:@"onlyIfPriority"];
    [self updateConfigurationValues];
}

- (int)minimumPriority { return [[self.configuration valueForKey:@"minimumPriority"] intValue]; }

- (void)setMinimumPriority:(int)minimumPriority {
    [self setConfigurationValue:[NSNumber numberWithInt:minimumPriority] forKey:@"minimumPriority"];
}

- (BOOL)usePrefix { return [[self.configuration valueForKey:@"usePrefix"] boolValue]; }

- (void)setUsePrefix:(BOOL)usePrefix {
    [self setConfigurationValue:[NSNumber numberWithBool:usePrefix] forKey:@"usePrefix"];
    [self updateConfigurationValues];
}

- (NSString*)prefixString { return [self.configuration valueForKey:@"prefixString"]; }

- (void)setPrefixString:(NSString*)prefixString {
    [self setConfigurationValue:prefixString forKey:@"prefixString"];
}

- (NSString*)pushoverAppKey { return [self.configuration valueForKey:@"pushoverAppKey"]; }

- (void)setPushoverAppKey:(NSString*)pushoverAppKey {
    [self setConfigurationValue:pushoverAppKey forKey:@"pushoverAppKey"];
}



@end
