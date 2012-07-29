#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, NSURLConnectionDelegate>
{
    NSString* _appStoreURL;
    NSMutableData* _receivedData;
}

@property (strong, nonatomic) UIWindow* window;

@end
