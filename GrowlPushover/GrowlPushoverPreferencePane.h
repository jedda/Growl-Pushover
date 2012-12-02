//
//  GrowlPushoverPreferencePane.h
//
//  Growl-Pushover
//  An action style for Growl 2.0 and higher that forwards messages to the Pushover notification service.
//  http://jedda.me/projects/pushover-action-growl/
//
//  Created by Jedda Wignall on 28/11/12.
//  This work is licensed under a Creative Commons Attribution 3.0 Unported License.
//  http://creativecommons.org/licenses/by/3.0/deed.en_US


#import <GrowlPlugins/GrowlPluginPreferencePane.h>

@interface GrowlPushoverPreferencePane : GrowlPluginPreferencePane

@property IBOutlet NSPopUpButton            *soundListButton;
@property IBOutlet NSTextField              *specificDeviceStringField;
@property IBOutlet NSPopUpButton            *priorityListButton;
@property IBOutlet NSTextField              *prefixStringField;
@property IBOutlet NSTextField              *testStatusField;

- (IBAction)testPushoverSettings:(id)sender;

- (NSString*)pushoverUserKey;
- (void)setPushoverUserKey:(NSString*)pushoverUserKey;
- (BOOL)onlyIfIdle;
- (void)setOnlyIfIdle:(BOOL)onlyIfIdle;
- (BOOL)useCustomSound;
- (void)setUseCustomSound:(BOOL)onlyIfIdle;
- (NSString*)customSoundName;
- (void)setCustomSoundName:(NSString*)specificDeviceString;
- (BOOL)onlyToSpecificDevice;
- (void)setOnlyToSpecificDevice:(BOOL)onlyToSpecificDevice;
- (NSString*)specificDeviceString;
- (void)setSpecificDeviceString:(NSString*)specificDeviceString;
- (BOOL)onlyIfPriority;
- (void)setOnlyIfPriority:(BOOL)onlyIfPriority;
- (int)minimumPriority;
- (void)setMinimumPriority:(int)minimumPriority;
- (BOOL)usePrefix;
- (void)setUsePrefix:(BOOL)usePrefix;
- (NSString*)prefixString;
- (void)setPrefixString:(NSString*)prefixString;
- (NSString*)pushoverAppKey;
- (void)setPushoverAppKey:(NSString*)pushoverAppKey;

@end
