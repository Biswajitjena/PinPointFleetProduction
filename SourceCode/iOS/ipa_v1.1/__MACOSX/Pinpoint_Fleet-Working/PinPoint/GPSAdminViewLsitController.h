//
//  GPSAdminViewLsitController.h
//  PinPoint
//
//  Created by Sandip Rudani on 24/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface GPSAdminViewLsitController : UIViewController<UITableViewDelegate,UITableViewDataSource,RESideMenuDelegate>



@property (nonatomic,retain)NSMutableArray *arrVehicleList;
@property(nonatomic,retain)NSString *strIdentifier;

@end
