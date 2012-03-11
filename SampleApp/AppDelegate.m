#import "AppDelegate.h"
#import "CJSONDeserializer.h"

// http://gamesfromwithin.wordpress.com

@implementation AppDelegate

@synthesize window = _window;

- (void) checkForUpdate:(NSString*)appId
{
	NSString* url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appId];
	NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	NSDictionary* responseDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];		
	NSArray* resultsArray = [responseDictionary objectForKey:@"results"];
	
	// Since we are requesting info for only one app, the results array should contain only one item: the info for that app.
	NSDictionary* result = [resultsArray objectAtIndex:0];
	
    _appStoreURL = [[result objectForKey:@"trackViewUrl"] retain];
    
	NSString* appStoreVersion   = [result objectForKey:@"version"];	
	NSString* installedVersion  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
	
	if ([appStoreVersion compare:installedVersion options:NSNumericSearch] == NSOrderedDescending)
	{
        NSString* appName   = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
		NSString* title     = [NSString stringWithFormat:@"%@ update", appName];
		NSString* message   = [NSString stringWithFormat:@"A newer version (%@) of %@ is available. Would you like to update?", appStoreVersion, appName];
		
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Update", nil];
		
		[alert show];
		[alert release];
	}
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appStoreURL]];
	}
	
}

- (void)dealloc
{
    [_appStoreURL release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self checkForUpdate:@"284882215"]; // This id is for the Facebook app.
    
    return YES;
}

@end
