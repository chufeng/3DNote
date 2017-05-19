//
//  XPAppDelegate.m
//  simpleNote
//
//  Created by Vic on 13-11-20.
//  Copyright (c) 2013年 vic. All rights reserved.
//
#import "addNoteViewController.h"
#import "rootViewController.h"
#import "YDAppDelegate.h"
#import "rootViewController.h"

@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //  创建ShortcutItem
    [self createShortcutItem]; // 设置 3D touch 快捷选项
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    rootViewController *rootViewCtrl = [[rootViewController alloc]init];
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:rootViewCtrl];
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
    
    
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    
    if (shortcutItem) {
        if ([shortcutItem.type isEqualToString:@"com.chuefng.save"]) {
            addNoteViewController *addViewCtrl = [[addNoteViewController alloc]init];
            self.window.rootViewController = addViewCtrl;
            
        } else if ([shortcutItem.type isEqualToString:@"com.chuefng.myQRCode"]) {
            // 进入我的二维码界面
            //            GFBLog(@"我的二维码界面");
        } else if ([shortcutItem.type isEqualToString:@"com.chuefng.start"]){
            rootViewController *rootViewCtrl = [[rootViewController alloc]init];
            self.window.rootViewController = rootViewCtrl;
        }
        return NO;
    }

    return YES;
}
- (void) createShortcutItem {
    // 创建系统风格的icon
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"HomePage_Scan"];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"red-envelope"];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"blackberry-qr-code-variant"];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.chuefng.start" localizedTitle:@" 快捷开启" localizedSubtitle:@"" icon:icon1 userInfo:nil];
    UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType:@"com.chuefng.save" localizedTitle:@"记事界面" localizedSubtitle:@"" icon:icon2 userInfo:nil];
    UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"com.chuefng.myQRCode" localizedTitle:@"我的二维码" localizedSubtitle:@"" icon:icon3 userInfo:nil];
    
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item, item1, item2];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
