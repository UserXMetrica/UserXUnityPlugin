#import <Foundation/Foundation.h>
#import <UserXKit/UserXKit-Swift.h>
#import <TargetConditionals.h>

@interface UserXPlugin : NSObject

@property (nonatomic, retain) NSDictionary* screens;

@end

@implementation UserXPlugin

+(void)start: (NSString *) key
{
#if !TARGET_OS_SIMULATOR
    [UserX start: key];
#endif
}

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

extern "C"
{
    void _UserXPluginInit(const char *key)
    {
#if !TARGET_OS_SIMULATOR
        if (key) {
            [UserXPlugin start: [NSString stringWithUTF8String:key]];
        }
#endif
    }

    void _UserXPluginStart()
    {
#if !TARGET_OS_SIMULATOR
        [UserX startScreenRecording];
#endif
    }

    void _UserXPluginStop()
    {
#if !TARGET_OS_SIMULATOR
        [UserX stopScreenRecording];
#endif
    }

    void _UserXPluginUID(const char *key)
    {
#if !TARGET_OS_SIMULATOR
        if (key) {
            [UserX setUserId:[NSString stringWithUTF8String:key]];
        }
#endif
    }

    void _UserXPluginAddEvent(const char *e)
    {
#if !TARGET_OS_SIMULATOR
        if (e) {
            [UserX addEvent:[NSString stringWithUTF8String:e] with:nullptr];
        }
#endif
    }

    void _UserXPluginShowScreen(const char *scr, const char *parentScr)
    {
#if !TARGET_OS_SIMULATOR
        if (scr) {
            NSString* scrName = [NSString stringWithUTF8String:scr];
            NSString* obj = [[UserXPlugin shared].screens valueForKey:scrName];
            
            if (!obj) {
                obj = scrName;
                [[UserXPlugin shared].screens setValue:obj forKey:obj];
            }
            
            NSString* parentObj = nullptr;
            
            if (parentScr) {
                NSString* parentScrName = [NSString stringWithUTF8String:parentScr];
                parentObj = [[UserXPlugin shared].screens valueForKey:parentScrName];
                
                if (!parentObj) {
                    parentObj = parentScrName;
                    [[UserXPlugin shared].screens setValue:parentObj forKey:parentObj];
                }
            }
            
            
            [UserX startScreen:obj screenName:obj parentController:parentObj parentName:parentObj];
        }
#endif
    }
}
