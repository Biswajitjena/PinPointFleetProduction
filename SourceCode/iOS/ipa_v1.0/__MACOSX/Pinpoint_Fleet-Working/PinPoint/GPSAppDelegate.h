//
//  GPSAppDelegate.h
//  PinPoint
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <GoogleMaps/GoogleMaps.h>


//#define LiveURL @"http://192.168.111.91:8081" //Local

//#define LiveURL  @"http://199.87.53.154:8080"
#define LiveURL  @"http://209.145.61.7:8080" // Changed IP On 22Nov21, FleetAnalytics - Gary's IP
//#define LiveURL  @"http://209.145.61.6:8080" // Changed IP On 22Nov21, FleetAnalytics - Gary's IP
//#define LiveURL  @"http://18.117.142.44:8080" // Changed IP On 23Dec21
//#define LiveURL  @"http://3.17.248.193:8080" // Changed IP On 18 Jan22, This is Brian Server IP
@interface GPSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property(strong,nonatomic)UINavigationController *nav;

-(BOOL)isNetworkAvailable;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property(nonatomic,retain)NSMutableArray *arrVehicleList,*arrDeviceID,*arrDeviceIDName;

@property(nonatomic,retain)NSArray *arrSelectedGroupData;

@property(nonatomic,retain)NSString *strId,*strRightSubMenuVehId,*strUserName,*strVehID,*strroleID,*strSensor;

@property(nonatomic,retain)NSMutableDictionary *dicVehSetting;

@property(nonatomic,readwrite)BOOL isLoadAllData;
@property(nonatomic,readwrite)BOOL isperiodNotSelected;
@property(nonatomic,readwrite)BOOL isFromRightSideMenu;
@property(nonatomic,readwrite) BOOL notTopController;

@property(nonatomic,readwrite) UIStoryboard *storyboard;


// address = "";
//altitude = 0;
//date = "11/05/2014 14:42:52 PM";
//"engine_status" = On;
//icon = "pin30_red.png";
//id = "Calamp 2620-2";
//lat = 0;
//lon = 0;
//satellites = "";
//sensor = "Digital Input 1:Opened,Digital Input 2:Opened,Digital Input 3:Opened,Digital Input 4:Opened,Supply Voltage:20.307000000000002 unit.volts,# of Temp Sensors:0.0 unit.percent,Temperature:1.0 unit.c";
//speed = 0;


@end
