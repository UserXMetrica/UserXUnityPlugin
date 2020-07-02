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

    void _UserXPluginAddEventParams(const char *e, char **parametrs)
    {
#if !TARGET_OS_SIMULATOR
        if (e) {
            //hard code one pair key value
            char *key = parametrs[0];
            char *value = parametrs[1];
            
            NSDictionary *dict = @{[NSString stringWithUTF8String:key] : [NSString stringWithUTF8String:value]};
            [UserX addEvent:[NSString stringWithUTF8String:e] with: dict];
        }
#endif
    }

    void _UserXPluginAddEventParamsCount(const char *e, int paramCount, char **parametrs)
    {
#if !TARGET_OS_SIMULATOR
        if (e) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:paramCount];
            int i = 0;
            for (i = 0; i < paramCount; i++)
            {
                char *key = parametrs[0+i*2];
                char *value = parametrs[1+i*2];
                [dict setObject:[NSString stringWithUTF8String:value] forKey:[NSString stringWithUTF8String:key]];
            }
            
            [UserX addEvent:[NSString stringWithUTF8String:e] with:dict];
        }
#endif
    }

    void _UserXPluginStartScreen(const char *scr, const char *parentScr)
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
