//
//  AppDelegate.m
//  iOSInterviewDemo-objc
//
//  Created by Julie on 30/6/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate () <ViewControllerDelegate>

@end

@implementation AppDelegate

- (void)setName:(NSString *)name
{
    NSLog(@"%@", name);
}

- (NSString *)name
{
 	return @"AppDelegate";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ViewController *vc = (ViewController *)self.window.rootViewController;
    vc.delegate = self;
    
    return YES;
}



@end
