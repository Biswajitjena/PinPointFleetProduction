//
//  GPSMapVC.m
//  PinPoint
//
//  Created by Sandip Rudani on 23/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//Sahil

#import "GPSMapVC.h"
#import "GPSMarkerWindow.h"
#import "GPSVehSettingVC.h"

@interface GPSMapVC ()<UIAlertViewDelegate> {
    
    NSString *strAlertString;
    
    NSDateFormatter *df,*dfDisplay;
    
    CLLocationManager *locationManager;
    
    UILabel *pinLabel;
    UIImage *pinIcon;
    BOOL isSelected;
}

@property(nonatomic,retain)  NSMutableArray *arrVehDetail;

@property (nonatomic, retain) NSArray *arrayOriginal;
@property (nonatomic, retain) NSMutableArray *arForTable;
@property (nonatomic, retain) NSMutableDictionary *dictNew;

@end

@implementation GPSMapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pinLabel= [[UILabel alloc]init];

    // Do any additional setup after loading the view.
    
//    self.view.frame = CGRectMake(0, 64, 320, 504);
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    objDelegate =(GPSAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.navigationItem.title = @"Map View";
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        [barAppearance setBackgroundColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
        self.navigationItem.standardAppearance = barAppearance;
        self.navigationItem.scrollEdgeAppearance = barAppearance;
    }
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    UIBarButtonItem *btnMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuView)];
    
    btnMenu.tintColor = [UIColor whiteColor];

    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshMap)];
    
    btnRefresh.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItems = @[btnMenu,btnRefresh];
    
    UIBarButtonItem * btnRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(presentRightMenuView)];
    
    btnRight.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem * btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(ShowSetting)];
    
   
    
    self.navigationItem.rightBarButtonItems =@[btnRight,btnSetting];
    
    btnSetting.tintColor = [UIColor whiteColor];
    
    _arrVehDetail = [[NSArray alloc]init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showHideNavbar:)];
    [self.mapview addGestureRecognizer:tapGesture];
    
    df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    dfDisplay = [[NSDateFormatter alloc]init];
    [dfDisplay setDateFormat:@"MM/DD/YYYY"];
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNewData:) name:@"LoadMapForCurrentDate" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetAllDeviceFirstTime:) name:@"LoadMap" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetAllDeviceFirstTime:) name:@"LoadMapForFirstTime" object:nil];
  
    self.sideMenuViewController.panGestureEnabled = FALSE;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:33.2326
                                                            longitude:-97.2416
                                                                 zoom:6];
    self.mapview = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.mapview setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    self.mapview.mapType = kGMSTypeNormal;
    
    self.mapview.delegate = self;
    
    [self.view addSubview:self.mapview];
    
    NSArray *arrMapType =@[@"Standard",@"Hybrid",@"Satellite"];

    segmentedControl= [[UISegmentedControl alloc] initWithItems:arrMapType];
    [segmentedControl addTarget:self action:@selector(DisplayGoogleMap:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.layer.cornerRadius = 5;
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
      //segmentedControl.frame = CGRectMake(60, self.view.frame.size.height - 100, 240, 40);
        segmentedControl.frame = CGRectMake((self.view.frame.size.width / 2)-120, self.view.frame.size.height - 100, 240, 40);
    
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        [self.view addSubview:self.btnsearch];

    }
    
    else {
        
        //segmentedControl.frame = CGRectMake(60, self.view.frame.size.height - 50, 200, 30);
        segmentedControl.frame = CGRectMake((self.view.frame.size.width / 2)-120, self.view.frame.size.height - 80, 240, 40);
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
//        UIImage *buttonOff = [UIImage imageNamed:@"setting_1.png"];
//        UIButton *predictButton = [UIButton alloc];
//        predictButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        //predictButton.frame = CGRectMake(280.0, 10.0, 30.0, 30.0);
//        [predictButton setBackgroundImage:buttonOff forState:UIControlStateNormal];
//        [predictButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
//        [predictButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [predictButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
//        [self.view addSubview:predictButton];
        [self.view addSubview:self.btnsearch];


    }
//    NSLog(@"self.view.window.bounds.size.height== %f segmentedControl.frame origin y = %f",self.view.frame.size.height,segmentedControl.frame.origin.y);
    [self.mapview addSubview:segmentedControl];
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    

    

//    [NSTimer scheduledTimerWithTimeInterval:60.0 * 5 target:self selector:@selector(deviceLocation) userInfo:nil repeats:YES];
    

    
//    [self deviceLocation];

   
}


- (IBAction)btnSearch:(id)sender {
    
    //NSLog(@"Btn Search");
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Search"
                               message:@""
                               preferredStyle:UIAlertControllerStyleAlert];
    
   
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
            //NSLog(@"cancel btn");
                                                       
            [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                  
        UITextField *textField = alert.textFields[0];
        //NSLog(@"text was %@", textField.text);
        // NSLog(@"arrDeviceIDandName:%@ ",[objDelegate.arrDeviceIDName description]);
        // NSLog(@"Count:%d",[objDelegate.arrDeviceIDName count]);
                                           
        if (textField.text.length == 0)
        {
            UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Enter Device ID !!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [avalert show];
        }
        else
        {
 
            NSMutableArray *temp = [objDelegate.arrDeviceIDName valueForKey:@"name"];
            //NSLog(@"TEMP:%@",[temp description]);
            NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //NSString *textStr = [textField.text string]
            //int indexValue = [temp indexOfObject:textField.text];
            int indexValue = [temp indexOfObjectPassingTest:^BOOL(NSString *obj, NSUInteger idx, BOOL *stop) {
                return [obj caseInsensitiveCompare:trimmedString] == NSOrderedSame;
            }];

            NSLog(@"Index:%d",indexValue);
            
            if(indexValue >= 0)
            {
            NSString *name = [[objDelegate.arrDeviceIDName objectAtIndex:indexValue] valueForKey:@"deviceID"];
            NSLog(@"Device ID:%@",name);
            
             objDelegate.isFromRightSideMenu = TRUE;
             [self getMapDetailID:name FromDate:@"" ToDate:@""];
            }
            else
            {
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"No data found!!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [avalert show];
            }
        }
         }];
    
    
    [ok setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Device ID here";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}


//- (void)deviceLocation {
//    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
//    
//    [locationManager startUpdatingLocation];
////    [locationManager startMonitoringSignificantLocationChanges];
//    
//    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
//  
//    NSLog(@"Current Location --> %@",theLocation);
//    
//    [self PostDeviceInfo];
//    
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    
//    NSLog(@"didUpdateLocations called !! ");
//    
//    NSLog(@"Locations Array %@",[locations description]);
//    
//    [locationManager stopUpdatingLocation];
//
//    
//    [self PostDeviceInfo];
//    
//    
//}
-(void)PostDeviceInfo{
    
    NSLog(@"PostDeviceInfo Called !! ");
    
  
//    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
//    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
//    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
//    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
//    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    
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
    
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=phonetrack",LiveURL];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    //  [[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]
    
    NSString *postString =[NSString stringWithFormat:@"&uniqueID=%@&lat=%f&lng=%f&deviceName=%@&type=ios&username=%@",uniqueIdentifier,locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,[[UIDevice currentDevice] name],[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]];
    
    NSLog(@"Post device info URL --> %@ Poststring --> %@",strURL,postString);

    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         // [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
         
         if (error) {
             
             NSLog(@"-- Error to post device info  ---");
             
             
             
         }
         else{ //1
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
//             NSLog(@"Return Data %@",[jsonData description]);
             
            
            
             
         }
         
     }];
     
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.autoresizesSubviews = YES;
    

    
    NSLog(@"View will appear");
    
    objDelegate =(GPSAppDelegate*) [[UIApplication sharedApplication]delegate];

    if (objDelegate.isLoadAllData) {
        
        //        [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        if([objDelegate isNetworkAvailable]){
            
            if([objDelegate.arrDeviceID count] >0){
                
                NSString *strIds= [objDelegate.arrDeviceID componentsJoinedByString:@","];
                //
                NSLog(@"str id --> %@",strIds);
                
                NSDictionary *dic = @{@"Id":strIds};
                
                objDelegate.dicVehSetting = [dic mutableCopy];
                
                [self LoadAllDevice:dic];
                
                //          [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMap" object:nil userInfo:dic];
            }
            
            else {
                
                
                [self GetVehicleList];
            }
            
        }
        
        else{
            
            strAlertString = @"No internet avaiable.Please try again later";
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
            
        }
        
    }
    
}

-(void)GetVehicleList{
    
    
    NSLog(@"GetVehicleListFromServer Called !! ");
    
    //NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=deviceList",LiveURL];
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=getRoleBasedDeviceList",LiveURL];
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    //  [[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]
    NSLog(@"UserID:%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"]);
    
    //for deviceList
    //    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&tmz=%@&userrole=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],[[NSUserDefaults standardUserDefaults] valueForKey:@"timezone"],[[NSUserDefaults standardUserDefaults] valueForKey:@"userole"]];
    
    // for getRoleBasedDeviceList
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@&userrole=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],[[NSUserDefaults standardUserDefaults]valueForKey:@"userId"],[[NSUserDefaults standardUserDefaults] valueForKey:@"userole"]];
    
    
    NSLog(@"PostString:%@",postString);
    NSLog(@"url:%@",aUrl);
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
         
         if (error) {
             
             NSLog(@"--Its error inside  getvehicle list ---");
             
             strAlertString = [NSString stringWithFormat:@"%@",error.localizedDescription];
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
             
         }
         else{ //1
             
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // NSLog(@"Response:%@",responseBody);
             NSDictionary *jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options: NSJSONReadingMutableContainers
                                                                              error: &error];
             NSLog(@"Return Data Classtype --: %@",[jsonData class]);
             //NSLog(@"Return Data %@",[jsonData description]);
             
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 
                 if([jsonData valueForKey:@"success"]){
                     
                     if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                         
                         NSLog(@"its Dictionary for success = FALSE");
                         
                         strAlertString = @"No data found";
                         
                         [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                         
                     }
                 }
                 
                 else {
                     
                     self.arrayOriginal=[jsonData valueForKey:@"List"];
                     //NSLog(@"arr original --> %@",[self.arrayOriginal description]);
                     
                     objDelegate.arrDeviceIDName = [[NSMutableArray alloc]init];
                     NSLog(@"get vehicle ");
                     
                     self.arForTable=[[NSMutableArray alloc] init];
                     //[self.arForTable addObjectsFromArray:self.arrayOriginal];
                     //===================== 22 March 2018
                     NSMutableArray* result = [[NSMutableArray alloc] init];
                     for(int i = 0 ; i < self.arrayOriginal.count ; i++){
                         NSMutableArray *groupArray = [[self.arrayOriginal objectAtIndex:i]valueForKey:@"List"];
                         NSMutableDictionary *level0 = [[NSMutableDictionary alloc] init];
                         [level0 setValue:[[self.arrayOriginal objectAtIndex:i] objectForKey:@"level"] forKey:@"level"];
                         [level0 setValue:[[self.arrayOriginal objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
                         NSMutableArray *deviceListForGroup = [[NSMutableArray alloc] init];
                         for(int j = 0 ; j < groupArray.count ; j++){
                             NSString *groupName = [[groupArray objectAtIndex:j]valueForKey:@"name"];
                             NSString *groupLevel = [[groupArray objectAtIndex:j]valueForKey:@"level"];
                             NSMutableArray *deviceArray = [[groupArray objectAtIndex:j]valueForKey:@"List"];
                             if(deviceArray.count != 0){
                                 NSMutableDictionary *level1 = [[NSMutableDictionary alloc] init];
                                 [level1 setValue:groupLevel forKey:@"level"];
                                 [level1 setValue:groupName forKey:@"name"];
                                 [level1 setValue:deviceArray forKey:@"List"];
                                 [deviceListForGroup addObject:level1];
                             }
                         }
                         [level0 setValue:deviceListForGroup forKey:@"List"];
                         [result addObject:level0];
                     }
                     [self.arForTable addObjectsFromArray:result];
                     //[objDelegate.arrDeviceIDName addObjectsFromArray:result];
                     
                     if([objDelegate.arrDeviceID count]> 0){
                         [objDelegate.arrDeviceID removeAllObjects];
                     }
                     
                     
                     
                     for(NSDictionary *dic in self.arrayOriginal){
                         
                         NSMutableArray *arrList = [dic valueForKey:@"List"];
                         //NSLog(@"arr List --> %@",[arrList description]);
                         //NSLog(@"arr List Count --> %d",[arrList count]);
                         
                         
                         for (NSDictionary *dicID in arrList) {
                             
                             if([dicID objectForKey:@"List"]){
                                 
                                 NSLog(@"GRoup:%@",[dicID valueForKey:@"name"]);
                                 
                                 NSMutableArray *arrNewDic = [dicID objectForKey:@"List"];
                                 //NSLog(@"arr NewDic --> %@",[arrNewDic description]);
                                 
                                 
                                 
                                 [objDelegate.arrDeviceIDName addObjectsFromArray:arrNewDic];
                                 
                                 for (NSDictionary *newDic in arrNewDic) {
                                     NSString *strID = [newDic valueForKey:@"deviceID"];
                                     
                                     [objDelegate.arrDeviceID addObject:strID];
                                     
                                 }
                                 
                             }
                             
                             else {
                                 
                                 NSString *deviceId = [dicID valueForKey:@"deviceID"];
                                
                                 [objDelegate.arrDeviceID addObject:deviceId];
                                 
                             }
                         }
                     }
                     
                     //NSLog(@"arr DeviceIDANme --> %@",[objDelegate.arrDeviceIDName description]);
                     // NSLog(@"arr DeviceIDANme count --> %d",[objDelegate.arrDeviceIDName count]);
                     NSLog(@"arrDeviceID count --> %lu \n description -->%@ ",(unsigned long)[objDelegate.arrDeviceID count],[objDelegate.arrDeviceID description]);
                  
                     //NSLog(@"OBj:%@",[objDelegate.arrDeviceIDName description]);
                     
                     objDelegate.arrVehicleList = [self.arrayOriginal mutableCopy];
                     
                     strId = [[NSString alloc]init];
                     
                     strId= [objDelegate.arrDeviceID componentsJoinedByString:@","];
                     
                   
                     NSDictionary *dic = @{@"Id":strId};
                     NSLog(@"Dictionary:%@",dic);
                     
                     objDelegate.dicVehSetting = [dic mutableCopy];
                     
                     NSLog(@"strid count --> %lu && objDelegate.arrDeviceID count --> %lu",(unsigned long)[[strId componentsSeparatedByString:@","]count],(unsigned long)[objDelegate.arrDeviceID count]);
                    
                     objDelegate.isLoadAllData = FALSE;
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMapForFirstTime" object:nil userInfo:dic];
                   
                 }
                 
             }
          
         }
         
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
}

-(void)GetAllDeviceFirstTime:(NSNotification*)notif{
    
    [self.mapview clear];

    
    NSLog(@"---- Get All device First data Called !! ----");
    //NSLog(@"---- Array DeviceID !! %@",objDelegate.arrDeviceID);
    NSDictionary *dicInfo = notif.userInfo;
    NSLog(@"notification dictionary --> %@ && dicInfo --> %@",[notif.userInfo description],[dicInfo description]);
    

    //objDelegate = [[UIApplication sharedApplication]delegate];
    if ([objDelegate isNetworkAvailable]) {
            
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
        
        if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
            [[UIView appearance] setTintColor:[UIColor lightTextColor]];
        }
        [hud setLabelText:@"Loading Data..."];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setAnimationType:MBProgressHUDAnimationFade];
        [self.view addSubview:hud];
//        [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        NSLog(@"get all data called");
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=allmapDetails",LiveURL];
        
        
        NSURL *aUrl = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:0];
        
        //  alternative Request Method
        [request setHTTPMethod:@"POST"];
        NSString *ids20 = @"";
        for(int i = 0 ; i < objDelegate.arrDeviceID.count ; i++){
            //[ids20 stringByAppendingString:[objDelegate.arrDeviceID objectAtIndex:i]]
             ids20 = [ids20 stringByAppendingFormat:@"%@,",[objDelegate.arrDeviceID objectAtIndex:i]];;
           
            if((i != 0 && i % 20 == 0) || (i == (objDelegate.arrDeviceID.count - 1))){
                
                 ids20 = [ids20 substringToIndex:[ids20 length] - 1];
                //HIT API
                NSLog(@"IDS:%@",ids20);
                NSString *postString =[NSString stringWithFormat:@"&devicelist=%@&tmz=%@",ids20,[[NSUserDefaults standardUserDefaults] valueForKey:@"timezone"]];
                NSLog(@"URL --> %@%@",strURL,postString);
                NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
                
                [request setHTTPBody:postData];
                
                
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    // handle response
                    
                    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                    
                    if (error) {
                        
                        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                        
                        
                        NSLog(@"--Its error inside  getall device list --- %@",[error localizedDescription]);
                        
                        strAlertString = [NSString stringWithFormat:@"%@",error.localizedDescription];
                        
                        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                        
                    }
                    else{ //1
                        
                        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        id jsonData= [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
                        
                        NSLog(@"GetAllDeviceFirstTime Json Data Count %lu",(unsigned long)[jsonData count]);
                        
                        NSLog(@"Return Data %@",[jsonData description]);
                        
                        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                        
                        
                        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                            
                            NSLog(@"its Dictionary ");
                            
                            NSMutableArray *arrTemp = [jsonData valueForKey:@"mapData"];
                            NSLog(@"ArrTemp GetAllDeviceFirstTime:%@",[arrTemp description]);
                            
                            [self performSelectorOnMainThread:@selector(ReloadAllDeviceOnMap:) withObject:arrTemp waitUntilDone:NO];
                            
                        }
                        
                    }
                    
                }];
                
                //}] resume];
                ids20 = @"";
                [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
                
               
            }
        
        }
    }
    else{
        
        strAlertString =@"Network is unavailable.Pleae try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }

}

-(void)LoadAllDevice:(NSDictionary*)dicInfo{
    
    NSLog(@"---- Get  Load All Device data Called !! ----");
    //NSDictionary *dicInfo = notif.userInfo;
    //NSLog(@"notification dictionary --> %@ && dicInfo --> %@",[notif.userInfo description],[dicInfo description]);
    
    
    //objDelegate = [[UIApplication sharedApplication]delegate];
    if ([objDelegate isNetworkAvailable]) {
        
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
        
        if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
            [[UIView appearance] setTintColor:[UIColor lightTextColor]];
        }
        [hud setLabelText:@"Loading Data..."];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setAnimationType:MBProgressHUDAnimationFade];
        [self.view addSubview:hud];
        //        [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        NSLog(@"get all data called");
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=allmapDetails",LiveURL];
        
        
        NSURL *aUrl = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:0];
        
        //  alternative Request Method
        [request setHTTPMethod:@"POST"];
        NSString *ids20 = @"";
        for(int i = 0 ; i < objDelegate.arrDeviceID.count ; i++){
            //[ids20 stringByAppendingString:[objDelegate.arrDeviceID objectAtIndex:i]]
            ids20 = [ids20 stringByAppendingFormat:@"%@,",[objDelegate.arrDeviceID objectAtIndex:i]];;
            
            if((i != 0 && i % 20 == 0) || (i == (objDelegate.arrDeviceID.count - 1))){
                
                ids20 = [ids20 substringToIndex:[ids20 length] - 1];
                //HIT API
                NSLog(@"IDS:%@",ids20);
                NSString *postString =[NSString stringWithFormat:@"&devicelist=%@&tmz=%@",ids20,[[NSUserDefaults standardUserDefaults] valueForKey:@"timezone"]];
                NSLog(@"URL --> %@%@",strURL,postString);
                NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
                
                [request setHTTPBody:postData];
                
                
                
                
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                    // handle response
                    
                    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                    
                    if (error) {
                        
                        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                        
                        
                        NSLog(@"--Its error inside  getall device list --- %@",[error localizedDescription]);
                        
                        strAlertString = [NSString stringWithFormat:@"%@",error.localizedDescription];
                        
                        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                        
                    }
                    else{ //1
                        
                        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options: NSJSONReadingMutableContainers
                                                                              error: &error];
                        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
                        
                        NSLog(@"GetAllDeviceFirstTime Json Data Count %lu",(unsigned long)[jsonData count]);
                        
                        NSLog(@"Return Data %@",[jsonData description]);
                        
                        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];
                        
                        
                        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                            
                            NSLog(@"its Dictionary ");
                            
                            NSArray *arrTemp = [jsonData valueForKey:@"mapData"];
                            NSLog(@"ArrTemp GetAllDeviceFirstTime:%@",[arrTemp description]);
                            
                            [self performSelectorOnMainThread:@selector(ReloadAllDeviceOnMap:) withObject:arrTemp waitUntilDone:NO];
                            
                        }
                        
                    }
                    
                }];
                
                //}] resume];
                ids20 = @"";
                [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
                
                
            }
            
        }
    }
    else{
        
        strAlertString =@"Network is unavailable.Pleae try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }

    
    
}
//sahil code-13-09-16
-(void)RefreshMap
{
    //[self viewDidLoad];
        [self.mapview clear];
    NSLog(@"refresh map Called !! ");
    
        //objDelegate = [[UIApplication sharedApplication]delegate];
    
        //NSLog(@"objdelegate dictionary count %d is--> %@",[objDelegate.dicVehSetting count],[objDelegate.dicVehSetting description]);
    [self GetVehicleList];
    
//        if([objDelegate.dicVehSetting count]>0){
//    
//            if ([objDelegate isNetworkAvailable]) {
//    
//                hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
//    
//                if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
//                    [[UIView appearance] setTintColor:[UIColor lightTextColor]];
//                }
//                [hud setLabelText:@"Loading Data..."];
//                [hud setMode:MBProgressHUDModeIndeterminate];
//                [hud setAnimationType:MBProgressHUDAnimationFade];
//                //[self.view addSubview:hud];
//                
//                if([objDelegate.arrDeviceID count] >0){
//                    
//                    NSString *strId= [objDelegate.arrDeviceID componentsJoinedByString:@","];
//                    //
//                    NSLog(@"str id --> %@",strId);
//                    
//                    NSDictionary *dic = @{@"Id":strId};
//                  
//                    [self LoadAllDevice:dic];
//                }
//                else {
//                    
//                    
//                    [self GetVehicleList];
//                }
//                
//            }
//            
//            else{
//                
//                strAlertString = @"No internet avaiable.Please try again later";
//                
//                [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//                
//            }
//            
//        }

    
//           else {
//            
//            strAlertString =@"No data found !!";
//            
//            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//            
//        }


}
-(void)ShowSetting{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    GPSVehSettingVC *screen = (GPSVehSettingVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"GPSVehSettingVC"];
        screen.view.backgroundColor = [UIColor blackColor];
    [screen setModalPresentationStyle: UIModalPresentationFullScreen];
    //Commented below code for smooth transition,
//        screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    screen.view.backgroundColor = [UIColor clearColor];
//    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
//    objDelegate.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//
//    screen.navigationController.navigationBarHidden = FALSE;
//
    [self.navigationController presentViewController:screen animated:YES completion:nil];
    objDelegate.isperiodNotSelected = FALSE;
    isSelected=TRUE;
}

-(void)presentLeftMenuView{
    
    [self.sideMenuViewController presentLeftMenuViewController];

    
}

-(void)presentRightMenuView{
    

    
    [self.sideMenuViewController presentRightMenuViewController];
    
    
}

- (IBAction)DisplayGoogleMap:(UISegmentedControl*)MapType {
    
    if( MapType.selectedSegmentIndex == 0){
        
        self.mapview.mapType =  kGMSTypeNormal;

    }
    
    else if( MapType.selectedSegmentIndex == 1){
        
        self.mapview.mapType =  kGMSTypeHybrid;

    }

    else if( MapType.selectedSegmentIndex == 2){
        
        self.mapview.mapType =  kGMSTypeSatellite;

    }
   
}

-(void)getNewData:(NSNotification*)notif{
    NSLog(@"---- Get New data Called !! ----");

    NSDictionary *dicInfo = notif.userInfo;
    NSLog(@"notification dictionary --> %@ && dicInfo --> %@",[notif.userInfo description],[dicInfo description]);

    objDelegate = [[UIApplication sharedApplication]delegate];
    if ([objDelegate isNetworkAvailable]) {
        
        hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
        
        if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
            [[UIView appearance] setTintColor:[UIColor lightTextColor]];
        }
        [hud setLabelText:@"Loading Data..."];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud setAnimationType:MBProgressHUDAnimationFade];
        [self.view addSubview:hud];
//        [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];

        
        NSString *fromDate = [dicInfo valueForKey:@"Fr_Dt"];
        NSString *toDate = [dicInfo valueForKey:@"To_Dt"];
        NSLog(@"FromDate:%@ ToDate:%@",fromDate,toDate);
        
        [self getMapDetailID:[dicInfo valueForKey:@"VehID"] FromDate:[dicInfo valueForKey:@"Fr_Dt"] ToDate:[dicInfo valueForKey:@"To_Dt"]];
        
    }
    else{
        
        strAlertString =@"Network is unavailable.Pleae try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
}

-(void)getMapDetailID:(NSString*)strVehID FromDate:(NSString*)strFrom_Dt ToDate:(NSString*)strTo_Dt{
    
    // this method is used to fetch data from server using NSURLSession Class
    [self.mapview clear];
    NSString *strURL;
   
    if (objDelegate.isFromRightSideMenu == TRUE)
    {
        objDelegate.isperiodNotSelected = TRUE;
      NSLog(@"IS FROM RIGHTSIDE call GetlastMapDetails");
      strURL = [NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=getlastmapDetails&method=login&format=JSON&deviceID=%@&tmz=%@",LiveURL,strVehID,[[NSUserDefaults standardUserDefaults]valueForKey:@"timezone"]];
        
        NSLog(@"URL Request from RightSide --> %@",strURL);
    }
    
    else
        
    {
        strURL = [NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=mapDetails&deviceID=%@&date_fr=%@&date_to=%@&tmz=%@",LiveURL,strVehID,[strTo_Dt stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[strFrom_Dt stringByReplacingOccurrencesOfString:@" " withString:@"%20"],[[NSUserDefaults standardUserDefaults]valueForKey:@"timezone"]];
        NSLog(@"URL Request from LeftSide --> %@",strURL);
    }
    
    
   // NSLog(@"GetVehicleDetail FromServer Called !! ");
    
//    [self.mapview clear];
//    
//    NSString *strURL = [NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=mapDetails&deviceID=%@&date_fr=%@&date_to=%@&tmz=%@",LiveURL,strVehID,strFrom_Dt,strTo_Dt,[[NSUserDefaults standardUserDefaults]valueForKey:@"timezone"]];
//    
//    NSLog(@"URL Request --> %@",strURL);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:strURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
        [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];

                
         if (error) {
             NSLog(@"Error: %@",error.localizedDescription);
             strAlertString = @"Please try again later";
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
         }
         else{ //1

             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
//             NSLog(@"Return Data %@",[jsonData description]);
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 NSLog(@"its Dictionary ");
                 
                 NSMutableArray *arrTemp = [jsonData valueForKey:@"mapData"];
                 NSLog(@"%d:ArrData:%@",[arrTemp count],[arrTemp description]);
                 
               [self performSelectorOnMainThread:@selector(ReloadMapwithData:) withObject:arrTemp waitUntilDone:NO];
                 
             }
             
         }
         
  //   }];
         
       }] resume];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
}

//sahil code-13-09-16
-(void)ReloadAllDeviceOnMap:(NSMutableArray*)arrresponse{
    
   // [self.mapview clear];

    
    NSLog(@"ReloadAllDeviceOnMap Called");
    
    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    
    if([arrresponse count]>0){
        
        self.arrVehDetail = [arrresponse copy];
        
        NSLog(@"VehDetail Count:%d",self.arrVehDetail.count);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lat"]doubleValue]longitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lon"]doubleValue] zoom:6];
        
        [self.mapview setCamera:camera];
        
        GMSMutablePath *path = [GMSMutablePath path];
       
        [self.arrVehDetail enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            GMSMarker *marker = [[GMSMarker alloc] init];
           // marker.icon = icon;
            marker.position = CLLocationCoordinate2DMake([[obj valueForKey:@"lat"] doubleValue], [[obj valueForKey:@"lon"] doubleValue]);
            marker.userData = obj;
            marker.appearAnimation = kGMSMarkerAnimationPop;
            
//marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
            marker.infoWindowAnchor =kGMSMarkerDefaultInfoWindowAnchor;
            marker.groundAnchor =kGMSMarkerDefaultGroundAnchor ;
            
            marker.map = self.mapview;
            
            [path addCoordinate:CLLocationCoordinate2DMake([[obj valueForKey:@"lat"] doubleValue], [[obj valueForKey:@"lon"] doubleValue])];
           
            NSString *strSpeed = [NSString stringWithFormat:@"%@",[obj objectForKey:@"speed"]];
            if([[obj valueForKey:@"engine_status"] isEqualToString:@"Off" ] && [strSpeed isEqualToString:@"0"] ){
                
                //NSLog(@"vehicle stop - Red pin");
                //marker.icon = [self plotMarkerWithText:[obj valueForKey:@"id"] andColor:[UIColor redColor]];
                marker.icon = [UIImage imageNamed:@"car-pin-red.png" ];
                
                
                
            }
            
            else if([[obj valueForKey:@"engine_status"] isEqualToString:@"On" ] && [strSpeed isEqualToString:@"0"] ){
                
               // NSLog(@"vehicle idle - yellow pin");
               //marker.icon = [self plotMarkerWithText:[obj valueForKey:@"id"] andColor:[UIColor yellowColor]];
                marker.icon = [UIImage imageNamed:@"car-pin-yellow.png"];
                
               

               
            }
            
            else if([[obj valueForKey:@"engine_status"] isEqualToString:@"On" ] && ![strSpeed isEqualToString:@"0"] ){
                
                //NSLog(@"vehicle start - Green pin");
                //marker.icon = [self plotMarkerWithText:[obj valueForKey:@"id"] andColor:[UIColor greenColor]];
                marker.icon = [UIImage imageNamed:@"car-pin-green.png"];
                
                
                
            }
            
            else {
                //marker.icon = [self plotMarkerWithText:[obj valueForKey:@"id"] andColor:[UIColor redColor]];
               marker.icon = [UIImage imageNamed:@"car-pin-red.png"];
                
                
            }
            //}
        }];
        
        //[objDelegate.arrDeviceID removeAllObjects];
    }
    
    else{
        NSLog(@"No Data Found!!");
//        strAlertString = @"No Data Found !!";
//        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
        //        [CustomAlert showAlert:@"No Data Found !!" Message:nil];
        
        
    }
}

-(UIImage *) plotMarkerWithText: (NSString *)text andColor:(UIColor *)color{
    
    pinLabel.text = text;
    pinLabel.backgroundColor =[color colorWithAlphaComponent:0.5];
    //pinLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blah"]];
    [pinLabel setFont:[UIFont fontWithName:@"Alegre Sans" size:12.0]];
    CGSize maxSize = CGSizeMake(250, CGFLOAT_MAX); //250 is max desired width
    CGSize textSize = [pinLabel.text sizeWithFont:pinLabel.font constrainedToSize:maxSize];
    pinLabel.frame = CGRectMake(0, 0, textSize.width, 20); // desired Bounds
    //grab it
    if (UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(pinLabel.bounds.size, NO, [[UIScreen mainScreen] scale]);
    }
    else
    {
        UIGraphicsBeginImageContext(pinLabel.bounds.size);
    }

    //UIGraphicsBeginImageContextWithOptions(pinLabel.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [pinLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    pinIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pinIcon;
}


//sahil code-26-09
-(void)ReloadMapwithData:(NSMutableArray*)arrresponse{
//target only only last location of car and remove polyline
    NSLog(@"ReloadMapwithData Called");

    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
    
    

    if([arrresponse count]>0){
        self.arrVehDetail = [arrresponse copy];
        //NSLog(@"devicePositionCount:%d",self.arrVehDetail.count);
        //NSLog(@"Last object :%@",[self.arrVehDetail lastObject ]);
        //NSLog(@"first object :%@",[self.arrVehDetail objectAtIndex:0]);
        //NSLog(@"Last object lat :%@",[[self.arrVehDetail lastObject]valueForKey:@"lat"]);
        //NSLog(@"Last object lon :%@",[[self.arrVehDetail lastObject]valueForKey:@"lon"]);
        
        //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lat"]doubleValue]longitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lon"]doubleValue] zoom:20];
        
        
//[self.mapview setCamera:camera];
        
       // GMSMarker *marker = [[GMSMarker alloc] init];

        

        
       // objDelegate =(GPSAppDelegate*) [[UIApplication sharedApplication]delegate];
        if(objDelegate.isperiodNotSelected == TRUE)
        {
            NSLog(@"Period is Not Selected");
            
            
           GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lat"]doubleValue]longitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lon"]doubleValue] zoom:17];
           
           [self.mapview setCamera:camera];
            GMSMarker *marker = [[GMSMarker alloc] init];
            
            marker.position = CLLocationCoordinate2DMake([[[self.arrVehDetail lastObject]valueForKey:@"lat"]doubleValue],[[[self.arrVehDetail lastObject]valueForKey:@"lon"]doubleValue]);
            
            marker.userData = [self.arrVehDetail lastObject];
            marker.appearAnimation = kGMSMarkerAnimationPop;
            
            //            marker.infoWindowAnchor = CGPointMake(0.3, 0.3);
            
            marker.infoWindowAnchor =kGMSMarkerDefaultInfoWindowAnchor;
            marker.groundAnchor =kGMSMarkerDefaultGroundAnchor ;
            
            //        marker.map = self.mapview;
            marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[self.arrVehDetail lastObject]valueForKey:@"icon"]]];
            // marker.title = [[self.arrVehDetail lastObject]valueForKey:@"id"];
            marker.map = self.mapview;
      
        }
        else
        
        {
            NSLog(@"Is Period  Selected");
           
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lat"]doubleValue]longitude:[[[self.arrVehDetail objectAtIndex:0]valueForKey:@"lon"]doubleValue] zoom:11];
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.arrVehDetail lastObject]valueForKey:@"lat"]doubleValue]longitude:[[[self.arrVehDetail lastObject]valueForKey:@"lon"]doubleValue] zoom:11];

                   [self.mapview setCamera:camera];
                    GMSMutablePath *path = [GMSMutablePath path];
            
                    [self.arrVehDetail enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
                        GMSMarker *marker = [[GMSMarker alloc] init];
            
                        marker.position = CLLocationCoordinate2DMake([[obj valueForKey:@"lat"] doubleValue], [[obj valueForKey:@"lon"] doubleValue]);
                        //NSLog(@"Object:%@",obj);
                        marker.userData = obj;
                        marker.appearAnimation = kGMSMarkerAnimationPop;
            
                        //            marker.infoWindowAnchor = CGPointMake(0.3, 0.3);
            
                        marker.infoWindowAnchor =kGMSMarkerDefaultInfoWindowAnchor;
                        marker.groundAnchor =kGMSMarkerDefaultGroundAnchor ;
            
                        marker.map = self.mapview;
            
                        [path addCoordinate:CLLocationCoordinate2DMake([[obj valueForKey:@"lat"] doubleValue], [[obj valueForKey:@"lon"] doubleValue])];
            
                         marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[obj valueForKey:@"icon"]]];
            
                    }];
                
                    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
                    
                    _polyline = polyline;
                    _polyline.strokeWidth = 2;
                    _polyline.strokeColor = [UIColor redColor];
                    _polyline.map = self.mapview;
                    
                
           }
    }
    else{

        strAlertString = @"No Data Found !!";

        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];

//        [CustomAlert showAlert:@"No Data Found !!" Message:nil];


    }
        

}


//-(void)FetchDataFromSeverUsingConnection{
//    
//   // Optional Method
//    
//// This method is used to fetch data from server using NSURLConnection method Asynch Call
//
//    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=mapDetails",LiveURL];
//
//    NSURL *aUrl = [NSURL URLWithString:strURL];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:50.0];
//
//    //  alternative Request Method
//    [request setHTTPMethod:@"POST"];
//    //  [[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]
//    NSString *postString =[NSString stringWithFormat:@"&deviceID=232000&date_fr=2014-07-03&date_to=2014-07-04"];
//    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
//
//    [request setHTTPBody:postData];
//
//
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//    
//
//                // handle response
//        
//                [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];
//                
//                
//                if (error) {
//                    
//                    NSLog(@"--Its error inside  getvehicle list ---");
//                    
//                    strAlertString = @"Please try again later";
//                    
//                    [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//                    
//                    
//                }
//                else{ //1
//                    
//                    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
//                                                                        options: NSJSONReadingMutableContainers
//                                                                          error: &error];
//                    NSLog(@"Return Data Classtype -- %@",[jsonData class]);
//                    NSLog(@"Return Data %@",[jsonData description]);
//                    
//                    if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
//                        
//                        NSLog(@"its Dictionary ");
//                        
//                        NSArray *dicTemp = [jsonData valueForKey:@"mapData"];
//                        
//                        NSLog(@"dicTemp description --> %@",[dicTemp description]);
//                        
//                        [self performSelectorOnMainThread:@selector(ReloadMapwithData:) withObject:dicTemp waitUntilDone:NO];
//                        
//                    }
//                    
//                }
//                
//                
//                }];
//                
//     
//    
//    [hud show:YES];
//    
//    
//}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    GPSMarkerWindow *MarkerWindow = (GPSMarkerWindow*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"GPSMarkerWindow"];
    
    NSLog(@"marker info - %@",[marker.userData  description]);
    
    MarkerWindow.view.frame = CGRectMake(self.view.center.x,self.view.center.y, 300, 300);
    
    MarkerWindow.view.layer.borderColor = [[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:0.9]CGColor ];
    
    MarkerWindow.view.layer.borderWidth = 1.5;
    
    MarkerWindow.view.layer.cornerRadius = 9.0;
    
    MarkerWindow.view.alpha = 9.0;
    
    MarkerWindow.lblAddress.text = [NSString stringWithFormat:@"%@",[marker.userData valueForKey:@"address"]];
    
    MarkerWindow.lblDate.text = [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"date"]];
        
//    MarkerWindow.lblLat.text = [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"lat"]];
    
    MarkerWindow.lblLat.text = [NSString stringWithFormat:@"%.02f",[[marker.userData objectForKey:@"lat"] doubleValue]];

    MarkerWindow.lblLong.text = [NSString stringWithFormat:@"%.02f",[[marker.userData objectForKey:@"lon"] doubleValue]];
    
    MarkerWindow.lblSpeed.text = [NSString stringWithFormat:@"%@ mph",[marker.userData objectForKey:@"speed"]];
    
    MarkerWindow.lblID.text = [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"id"]];
    
    MarkerWindow.lblEngine.text = [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"engine_status"]];
    
    MarkerWindow.lblSatellites.text= [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"satellites"]];
    
    MarkerWindow.lblAltitude.text= [NSString stringWithFormat:@"%@",[marker.userData objectForKey:@"altitude"]];
    

    NSString *strSensorText = [marker.userData objectForKey:@"sensor"];
    
    
    NSLog(@"Sensor string --> %@",strSensorText);

    
    if(strSensorText.length !=0){
        
        
        MarkerWindow.lblSensor.hidden = FALSE;
        MarkerWindow.lblSensorTitle.hidden = FALSE;
        
    MarkerWindow.lblSensor.text =   [strSensorText stringByReplacingOccurrencesOfString:@"," withString:@"\n\n"];
    
    MarkerWindow.lblSensor.numberOfLines = 0;
//    
//    CGSize maximumLabelSize = CGSizeMake(170,9999);
//    
//    CGSize expectedLabelSize = [MarkerWindow.lblSensor.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:11]
//                                               constrainedToSize:maximumLabelSize
//                                                   lineBreakMode:NSLineBreakByWordWrapping];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = MarkerWindow.lblSensor.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    MarkerWindow.lblSensor.frame = newFrame;
    
    [MarkerWindow.lblSensor sizeToFit];
    
    MarkerWindow.view.frame = CGRectMake(self.view.center.x,self.view.center.y, 300, MarkerWindow.lblSensor.frame.size.height + MarkerWindow.lblSensor.frame.origin.y + 5);
        
    }
    
    else {
        
        MarkerWindow.view.frame = CGRectMake(self.view.center.x,self.view.center.y, 300,265);

        
        MarkerWindow.lblSensor.hidden = TRUE;
        MarkerWindow.lblSensorTitle.hidden = TRUE;
        
    
    }
    
    return MarkerWindow.view;
}

-(IBAction)ShowdataforSensor:(id)sender{
    
    
    
    [objDelegate.strSensor stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sensor Data" message:objDelegate.strSensor delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
}
-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    //[self RefreshMap];
    //[self GetVehicleList];
    
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 0){
//    [self GetVehicleList];
//    }
//}

-(void)showHideNavbar:(id) sender
{
    // write code to show/hide nav bar here
    // check if the Navigation Bar is shown
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    // if Navigation Bar is already hidden
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoadMapForCurrentDate" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoadMap" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoadMapForFirstTime" object:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    


}



@end
