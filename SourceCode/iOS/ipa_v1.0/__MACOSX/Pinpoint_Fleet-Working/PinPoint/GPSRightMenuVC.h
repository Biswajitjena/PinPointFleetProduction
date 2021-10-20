//
//  SMRightMenuVC.h
//  SlideMenu
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface GPSRightMenuVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
    
    NSArray *topItems;
    NSMutableArray *subItems; // array of arrays
    
    NSMutableArray *arrDeviceId;
    
    int currentExpandedIndex;
    
    NSString *strId;
}

@property (nonatomic, retain) NSArray *arrayOriginal;
@property (nonatomic, retain) NSMutableArray *arForTable;

-(void)miniMizeThisRows:(NSArray*)ar;

-(void)CheckNetworkAvailability;
@end
