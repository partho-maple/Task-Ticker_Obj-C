//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
  
  /// once application finished launching, we call customizeAppearance method. customizeAppearance is responsible to theme the app
    
    //[self customizeAppearance];

    
    return YES;
}


/// customizing navigation bar and its items

-(void)customizeAppearance
{
    ///The UINavigationBar class implements a control for navigating hierarchical content. It’s a bar, typically displayed at the top of the screen, containing buttons for navigating up and down a hierarchy. The primary properties are a left (back) button, a center title, and an optional right button. You can specify custom views for each of these. You can modify the appearance of the bar using the barStyle, tintColor, and translucent properties. These properties affect the visual appearance of the bar itself but they also affect the way buttons are displayed in the bar. For example, if you set the translucent property to YES, any buttons in the bar are also made partially opaque.
    
    ///Customize navigation menu bar
    
    UIImage* navigationBar = [UIImage imageNamed:@"blue-menu-bar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBar forBarMetrics:UIBarMetricsDefault];
    
    
    
    ///A bar button item is a button specialized for placement on a UIToolbar or UINavigationBar object. It inherits basic button behavior from its abstract superclass, UIBarItem. The UIBarButtonItem defines additional initialization methods and properties for use on toolbars and navigation bars.
    
    ///Customize back button

    UIImage *backButton = [[UIImage imageNamed:@"blue-back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    ///Customize bar button

    UIImage *barButton = [[UIImage imageNamed:@"blue-bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(-1, 5, -1, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    ///Following method customize the uinavigation bar title. make changes here if you want to change to another style.
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
[NSValue valueWithUIOffset:UIOffsetMake(0, 3)],UITextAttributeTextShadowOffset,
[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20.0], UITextAttributeFont, nil]];


}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
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
