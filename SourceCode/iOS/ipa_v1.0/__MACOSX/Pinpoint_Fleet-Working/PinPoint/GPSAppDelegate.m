//
//  GPSAppDelegate.m
//  PinPoint
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSAppDelegate.h"

#import "RESideMenu.h"

#import "GPSLoginVC.h"

#import <CFNetwork/CFNetwork.h>

@implementation GPSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[GMSServices provideAPIKey:@"AIzaSyAjo2qe2JurR0kYmS9PVhbHGtSiSBGldUo"];
    [GMSServices provideAPIKey:@"AIzaSyBEKChGLxcmztgAX_bqBtceBKkDnmnKcNQ"]; // NEW KEY from parth@entrust-us.com, Dt:21 Jan 22
    
    NSLog(@"self.view bound %f",self.window.frame.size.height);
        
        NSString* uniqueIdentifier = nil;
        if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) { // >=iOS 7
            uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        } else { //<=iOS6, Use UDID of Device
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            //uniqueIdentifier = ( NSString*)CFUUIDCreateString(NULL, uuid);- for non- ARC
            uniqueIdentifier = ( NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
            CFRelease(uuid);
        }
    
    NSLog(@"uniqueIdentifier: %@", uniqueIdentifier);
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
   
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        
        self.storyboard  = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        
    }
    else
    {
        
        self.storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    
    
    self.arrVehicleList = [[NSMutableArray alloc]init];

    self.arrSelectedGroupData = [[NSArray alloc]init];
    
    self.dicVehSetting = [[NSMutableDictionary alloc]init];
    
    self.arrDeviceID = [[NSMutableArray alloc]init];
    
    self.arrDeviceIDName = [[NSMutableArray alloc]init];
    
    self.strSensor = @"Digital Input 1:Opened,Digital Input 2:Opened,Digital Input 3:Opened,Digital Input 4:Opened,Supply Voltage:20.307000000000002 unit.volts,# of Temp Sensors:0.0 unit.percent,Temperature:1.0 unit.c";
    
    NSLog(@" Live URL -- %@",LiveURL);
    
    // show the storyboard
    return YES;
}

- (BOOL)isNetworkAvailable
{
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    BOOL connectionRequired;
    NSString* statusString = @"";
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            connectionRequired = YES;
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            connectionRequired = YES;
            break;
        }
    }
    
    return connectionRequired;
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
