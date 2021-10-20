//
//  GPSMarkerWindow.h
//  OpenGTS
//
//  Created by Sandip Rudani on 01/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GPSMarkerWindow : UIViewController<UIAlertViewDelegate>{
    
    
}
@property (nonatomic,retain)IBOutlet UILabel *lblID,*lblAddress,*lblDate,*lblTime,*lblLat,*lblLong,*lblSpeed,*lblEngine,*lblAltitude,*lblSatellites,*lblSensor,*lblSensorTitle;




@end
