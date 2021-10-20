//
//  GPSMapVC.h
//  PinPoint
//
//  Created by Sandip Rudani on 23/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GPSAppDelegate.h"
#import "MBProgressHUD.h"
#import "RESideMenu.h"
#import "GPSRightMenuVC.h"

#import <CoreLocation/CoreLocation.h>

@interface GPSMapVC : UIViewController<GMSMapViewDelegate,UIGestureRecognizerDelegate,RESideMenuDelegate,CLLocationManagerDelegate>{
    
    
    GMSGeocoder *geocoder_;
    GMSPolyline *_polyline;
    GMSMarker *_markerStart;
    GMSMarker *_markerFinish;
    GPSAppDelegate *objDelegate;
    MBProgressHUD *hud;
    NSString *strId;
   IBOutlet UISegmentedControl *segmentedControl;
    

}
@property (strong, nonatomic) IBOutlet GMSMapView *mapview;
@property (weak, nonatomic) IBOutlet UIButton *btnsearch;


-(void)getNewData:(NSDictionary*)dic;

- (IBAction)DisplayGoogleMap:(UISegmentedControl*)MapType ;

@end
