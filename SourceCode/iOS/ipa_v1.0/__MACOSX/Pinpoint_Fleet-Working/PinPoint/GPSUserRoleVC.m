//
//  GPSUserRoleVC.m
//  PinPoint
//
//  Created by Sandip Rudani on 04/08/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSUserRoleVC.h"
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

@interface GPSUserRoleVC ()
{
     
    UITextField *txtName;
    
    NSString *strValue;
    MBProgressHUD *hud;
    
    GPSAppDelegate *objDelegate;
    
    NSString *strAlertString;

}

@property(nonatomic,retain)NSMutableArray *arrMain,*arrVehicleList,*arrSelectedDevice;
@property(nonatomic,retain)NSMutableDictionary *dicReport,*dicdevices,*dicNotifiers,*dicGeofence,*dicTrack,*dicCommand,*dicName;
//@property(nonatomic,readwrite)BOOL isAdd;

@end

@implementation GPSUserRoleVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    objDelegate = [[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/256.0 green:98.0/256.0 blue:153.0/256.0 alpha:1]];
    
    if(self.isAdd)
    {
        
        self.navigationItem.title = @"Add User Role";
        
    }
    else {
        
        self.navigationItem.title = @"User Role Detail";
        
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
    
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    
    btnBack.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = btnBack;
    
    UIBarButtonItem *Savebtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    
    Savebtn.enabled = TRUE;
    
    Savebtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = Savebtn;
    
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor darkGrayColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor darkTextColor];
    
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    
    
    txtName= [[UITextField alloc]initWithFrame:CGRectMake(100, 5, 210, 30)];
    txtName.delegate = self;
    txtName.backgroundColor = [UIColor clearColor];
    txtName.borderStyle = UITextBorderStyleRoundedRect;
    txtName.textColor = [UIColor darkGrayColor];
    txtName.font =[UIFont fontWithName:@"Palatino-bold" size:15];
    txtName.keyboardType = UIKeyboardTypeASCIICapable;

        
    if(!self.isAdd){
        strValue = @"false";
        
    }
    else
        strValue = @"true";
    
    if(!self.arrMain){
        self.arrMain = [[NSMutableArray alloc]init];
    }
    
    if(!self.dicGeofence){
        
        self.dicGeofence = [[NSMutableDictionary alloc]init];
        
        [self.dicGeofence setValue:strValue forKey:@"Create geofences"];

        [self.arrMain addObject:self.dicGeofence];

        
    }
    
    if(!self.dicTrack){
        
        self.dicTrack = [[NSMutableDictionary alloc]init];
        
        [self.dicTrack setValue:strValue forKey:@"View Tracks"];

        [self.arrMain addObject:self.dicTrack];

        
    }
    
    if(!self.dicCommand){
        self.dicCommand = [[NSMutableDictionary alloc]init];
        
        
        [self.dicCommand setValue:strValue forKey:@"Send Commands"];
        [self.arrMain addObject:self.dicCommand];

        
    }
    
    if(!self.dicNotifiers){
        
        self.dicNotifiers = [[NSMutableDictionary alloc]init];
        
        [self.dicNotifiers setValue:strValue forKey:@"SOS"];
        [self.dicNotifiers setValue:strValue forKey:@"Connection Loss"];
        [self.dicNotifiers setValue:strValue forKey:@"GPS Loss"];
        [self.dicNotifiers setValue:strValue forKey:@"Overspeed"];
        [self.dicNotifiers setValue:strValue forKey:@"Mileage"];
        [self.dicNotifiers setValue:strValue forKey:@"Ideals"];
        [self.dicNotifiers setValue:strValue forKey:@"Geofence"];
        [self.dicNotifiers setValue:strValue forKey:@"IO act./ de act."];
        [self.dicNotifiers setValue:strValue forKey:@"Low Power"];
        [self.dicNotifiers setValue:strValue forKey:@"Power Cut"];
        [self.dicNotifiers setValue:strValue forKey:@"Restore GPS"];
        [self.dicNotifiers setValue:strValue forKey:@"Wake Up"];
        [self.dicNotifiers setValue:strValue forKey:@"Shake Alarm"];
        [self.dicNotifiers setValue:strValue forKey:@"Hars Acceleration"];
        [self.dicNotifiers setValue:strValue forKey:@"Harsh Break"];
        [self.dicNotifiers setValue:strValue forKey:@"Move"];
        
        [self.arrMain addObject:self.dicNotifiers];

        
    }
    
    if(!self.dicReport){
        
        self.dicReport = [[NSMutableDictionary alloc]init];
        
        [self.dicReport setValue:strValue forKey:@"Trips"];
        [self.dicReport setValue:strValue forKey:@"Geozones"];
        [self.dicReport setValue:strValue forKey:@"Ignition Detail"];
        [self.dicReport setValue:strValue forKey:@"Input Detail"];
        [self.dicReport setValue:strValue forKey:@"Distance"];
        [self.dicReport setValue:strValue forKey:@"Temperature"];
        [self.dicReport setValue:strValue forKey:@"Periodic Service"];
        [self.dicReport setValue:strValue forKey:@"GPS raw data"];
        [self.dicReport setValue:strValue forKey:@"Overspeed"];
        
        [self.arrMain addObject:self.dicReport];

        
    }
    
    self.arrVehicleList = [[NSMutableArray alloc]init];
    
    self.arrSelectedDevice = [[NSMutableArray alloc]init];
    
    
 //   [self getStaticData];
    
    [self getDeviceList];

    
    if(!self.isAdd){
    
        [self CheckNetworkAvailability];

    }
   
//    [self GetUesrRoleData];
 
}

-(void)Back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)CheckNetworkAvailability{

    
    if ([objDelegate isNetworkAvailable]) {
        
        // [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        [self GetUesrRoleData];
        
        
    }
    
    else{
        
        strAlertString = @"No Internet Availble !!";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
 
    }
    
}


-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}

-(void)showAlertForSuccessfullyUpdate:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:Title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}
-(void) getDeviceList {
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=vehicleDetails",LiveURL];
    
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
    
    [self GetList:strURL PostString:postString];
    
}

-(void)GetList:(NSString*)strURL PostString:(NSString*)postString{
    
    NSLog(@"GetList Called strURL -> %@ and PostString -> %@",strURL,postString);
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

         if (error) {
             
             NSLog(@"--Its error inside  getvehicle list ---");
             
             
             
         }
         
         else { //1
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]options: NSJSONReadingMutableContainers
                                                                error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data %@",[jsonData description]);
             
             
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 self.arrVehicleList =[jsonData valueForKey:@"vehicleData"];
                 [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                 
                 
                 if (self.isAdd) {
                     

                     
//                     [jsonData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                         
//                         if([key isEqualToString:@"id"])
//                             [self.arrSelectedDevice addObject:obj];
//                         
//                         
//                     }];
                     
                     [self.arrVehicleList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         
                         [self.arrSelectedDevice addObject:[[self.arrVehicleList objectAtIndex:idx]valueForKey:@"id"]];
                     }];
                     
                     
                     NSLog(@"selected vehicle data for add--> %@",[self.arrSelectedDevice description]);

                 }
             }
             
             NSLog(@"selected vehicle data --> %@",[self.arrSelectedDevice description]);

         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:NO];

    
}



-(void)GetUesrRoleData
{
    
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=getEditRoleDetails",LiveURL ];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&roleID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],objDelegate.strroleID];
    
    NSLog(@"Default user-- %@",postString);
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    //start the connection
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:YES];

         if (error) {
             
             NSLog(@"--Its error inside  default veh detail  ---");
             
             
         }
         else{ //1
             
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data %@",[jsonData description]);
             
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 NSLog(@"its Dictionary");
                 
                 
                 txtName.text = [jsonData valueForKey:@"description"];
                 
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"sos"] forKey:@"SOS"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"connection"] forKey:@"Connection Loss"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"GPSloss"] forKey:@"GPS Loss"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"overspeed"] forKey:@"Overspeed"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"mileage"] forKey:@"Mileage"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"idles"] forKey:@"Ideals"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"notifygeo"] forKey:@"Geofence"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"ioact"] forKey:@"IO act./ de act."];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"lowpower"] forKey:@"Low Power"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"powercut"] forKey:@"Power Cut"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"restoregps"] forKey:@"Restore GPS"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"wakeup"] forKey:@"Wake Up"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"shakealarm"] forKey:@"Shake Alarm"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"acceleration"] forKey:@"Hars Acceleration"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"harshbrake"] forKey:@"Harsh Break"];
                 [self.dicNotifiers setValue:[jsonData valueForKey:@"move"] forKey:@"Move"];
                 
                 [self.dicReport setValue:[jsonData valueForKey:@"trips"] forKey:@"Trips"];
                 [self.dicReport setValue:[jsonData valueForKey:@"reportgeo"] forKey:@"Geozones"];
                 [self.dicReport setValue:[jsonData valueForKey:@"ignition"] forKey:@"Ignition Detail"];
                 [self.dicReport setValue:[jsonData valueForKey:@"input"] forKey:@"Input Detail"];
                 [self.dicReport setValue:[jsonData valueForKey:@"distance"] forKey:@"Distance"];
                 [self.dicReport setValue:[jsonData valueForKey:@"temp"] forKey:@"Temperature"];
                 [self.dicReport setValue:[jsonData valueForKey:@"periSer"] forKey:@"Periodic Service"];
                 [self.dicReport setValue:[jsonData valueForKey:@"gpsrowdata"] forKey:@"GPS raw data"];
                 [self.dicReport setValue:[jsonData valueForKey:@"overspeed"] forKey:@"Overspeed"];
                 
                 [self.dicCommand setValue:[jsonData valueForKey:@"command"] forKey:@"Send Commands"];
                 
                 [self.dicTrack setValue:[jsonData valueForKey:@"track"] forKey:@"View Tracks"];
                 
                 [self.dicGeofence setValue:[jsonData valueForKey:@"geofences"] forKey:@"Create geofences"];
                 
                 
                 NSString *strTemp = [jsonData valueForKey:@"devicelist"] ;
                 
                 self.arrSelectedDevice = [[strTemp componentsSeparatedByString:@","] mutableCopy];
                 
                 [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                 
             }
             
         }
         
     }];
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];

}

-(void)UploadData{
    
    NSString *strURL,*postString;
    
    NSString *strSelectedDevice = [self.arrSelectedDevice componentsJoinedByString:@","];
    
    // Both Edit and Add have same URL & Pass static Action-Type.
    
    strURL =[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=addEditrole",LiveURL];
    
    if(self.isAdd){
        
        postString= [NSString stringWithFormat:@"&accountID=%@&description=%@&sos=%@&connection=%@&GPSloss=%@&overspeed=%@&mileage=%@&idles=%@&ioact=%@&lowpower=%@&powercut=%@&restoregps=%@&wakeup=%@&shakealarm=%@&acceleration=%@&harshbrake=%@&move=%@&notifygeo=%@&trips=%@&reportgeo=%@&ignition=%@&input=%@&distance=%@&temp=%@&periSer=%@&gpsrowdata=%@&overspeedrepo=%@&command=%@&track=%@&geofences=%@&deviceList=%@&roleID=&actiontype=Add",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],txtName.text,[self.dicNotifiers valueForKey:@"SOS"],[self.dicNotifiers valueForKey:@"Connection Loss"],[self.dicNotifiers valueForKey:@"GPS Loss"],[self.dicNotifiers valueForKey:@"Overspeed"],[self.dicNotifiers valueForKey:@"Mileage"],[self.dicNotifiers valueForKey:@"Ideals"],[self.dicNotifiers valueForKey:@"IO act./ de act."],[self.dicNotifiers valueForKey:@"Low Power"],[self.dicNotifiers valueForKey:@"Power Cut"],[self.dicNotifiers valueForKey:@"Restore GPS"],[self.dicNotifiers valueForKey:@"Wake Up"],[self.dicNotifiers valueForKey:@"Shake Alarm"],[self.dicNotifiers valueForKey:@"Hars Acceleration"],[self.dicNotifiers valueForKey:@"Harsh Break"],[self.dicNotifiers valueForKey:@"Move"],[self.dicNotifiers valueForKey:@"Geofence"],[self.dicReport valueForKey:@"Trips"],[self.dicReport valueForKey:@"Geozones"],[self.dicReport valueForKey:@"Ignition Detail"],[self.dicReport valueForKey:@"Input Detail"],[self.dicReport valueForKey:@"Distance"],[self.dicReport valueForKey:@"Temperature"],[self.dicReport valueForKey:@"Periodic Service"],[self.dicReport valueForKey:@"GPS raw data"],[self.dicReport valueForKey:@"Overspeed"],
                     [self.dicCommand valueForKey:@"Send Commands"],[self.dicTrack valueForKey:@"View Tracks"],[self.dicGeofence valueForKey:@"Create geofences"],strSelectedDevice];
    }
    
    else {
        postString =[NSString stringWithFormat:@"&accountID=%@&description=%@&sos=%@&connection=%@&GPSloss=%@&overspeed=%@&mileage=%@&idles=%@&ioact=%@&lowpower=%@&powercut=%@&restoregps=%@&wakeup=%@&shakealarm=%@&acceleration=%@&harshbrake=%@&move=%@&notifygeo=%@&trips=%@&reportgeo=%@&ignition=%@&input=%@&distance=%@&temp=%@&periSer=%@&gpsrowdata=%@&overspeedrepo=%@&command=%@&track=%@&geofences=%@&deviceList=%@&roleID=%@&actiontype=Edit",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],txtName.text,[self.dicNotifiers valueForKey:@"SOS"],[self.dicNotifiers valueForKey:@"Connection Loss"],[self.dicNotifiers valueForKey:@"GPS Loss"],[self.dicNotifiers valueForKey:@"Overspeed"],[self.dicNotifiers valueForKey:@"Mileage"],[self.dicNotifiers valueForKey:@"Ideals"],[self.dicNotifiers valueForKey:@"IO act./ de act."],[self.dicNotifiers valueForKey:@"Low Power"],[self.dicNotifiers valueForKey:@"Power Cut"],[self.dicNotifiers valueForKey:@"Restore GPS"],[self.dicNotifiers valueForKey:@"Wake Up"],[self.dicNotifiers valueForKey:@"Shake Alarm"],[self.dicNotifiers valueForKey:@"Hars Acceleration"],[self.dicNotifiers valueForKey:@"Harsh Break"],[self.dicNotifiers valueForKey:@"Move"],[self.dicNotifiers valueForKey:@"Geofence"],[self.dicReport valueForKey:@"Trips"],[self.dicReport valueForKey:@"Geozones"],[self.dicReport valueForKey:@"Ignition Detail"],[self.dicReport valueForKey:@"Input Detail"],[self.dicReport valueForKey:@"Distance"],[self.dicReport valueForKey:@"Temperature"],[self.dicReport valueForKey:@"Periodic Service"],[self.dicReport valueForKey:@"GPS raw data"],[self.dicReport valueForKey:@"Overspeed"],
                     [self.dicCommand valueForKey:@"Send Commands"],[self.dicTrack valueForKey:@"View Tracks"],[self.dicGeofence valueForKey:@"Create geofences"],strSelectedDevice,objDelegate.strroleID];
        
    }
    
    
    [self UploadData:strURL PostString:postString];
    
}


-(void)UploadData:(NSString*)strURL PostString:(NSString*)postString{
    
    NSLog(@"Upload Data Called !! ");
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

         
         if (error) {
             
             
             NSLog(@"--Its error inside  upload data ---");
             
             
         }
         else{ //1
             
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data %@",[jsonData description]);
             
             
             if ([jsonData isKindOfClass:[NSDictionary class]]){
                 
                 if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                     
                     strAlertString = @"Please try again later !!";
                     
                     [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                 }
                 
                 
                 else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                     
                     strAlertString = @"Data Uploded Successfully !!";
                     
                     [self performSelectorOnMainThread:@selector(showAlertForSuccessfullyUpdate:) withObject:strAlertString waitUntilDone:NO];
                 }
                 
                 
             }
             
             
         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:NO];

    
    
}

-(IBAction)Save:(id)sender{
    
    if([objDelegate isNetworkAvailable]) {
        
//        [self UploadData];
        
//        for (UIView *subview in [self.view subviews]) {
//            if ([subview isKindOfClass:[UITextField class]]) {
//                UITextField *textField = (UITextField *)subview;
                txtName.text = [txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSLog(@"Trim string -->%@.",txtName.text);
                
//            }
//        }
        
        if(txtName.text.length >0)
            
            [self UploadData];
        
        else
        {
            strAlertString = @"Enter User Role !!";
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
        
    }
    else{
        
        strAlertString = @"No internet available. Please try again later.";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Current Section --- %ld",(long)section);

    NSInteger row = 0;
    
    
    if(section == 0)
        row = 1;
    else if(section == 1)
    {
        // self.dicdevices  = [self.arrMain objectAtIndex:section];
        
        row = [self.arrVehicleList count];
        
        
    }
    else if(section == 2)
    {
        self.dicGeofence = [self.arrMain objectAtIndex:section-2];
        
        row = [self.dicGeofence count];
        
        
    }
    else if(section == 3)
    {
        self.dicTrack = [self.arrMain objectAtIndex:section-2];
        
        row = [self.dicTrack count];
        
        
    }
    else if(section == 4)
    {
        self.dicCommand = [self.arrMain objectAtIndex:section-2];
        
        row = [self.dicCommand count];
        
        
    }
    else if(section == 5)
    {
        self.dicNotifiers= [self.arrMain objectAtIndex:section-2];
        
        row = [self.dicNotifiers count];
        
        
    }
    
    else if(section == 6)
    {
        self.dicReport= [self.arrMain objectAtIndex:section-2];
        
        row = [self.dicReport count];
        
        
    }
    
    
    return row;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = @"";
    
    
    if(section ==  0)
        sectionTitle = @"User Role :";
    
    else if(section ==  1)
        sectionTitle = @"Devices To View :";
    
    else if(section ==  2)
        sectionTitle = @"Geofences Restrictions :";
    
    else if(section ==  3)
        sectionTitle = @"Tracks Restrictions :";
    
    else if(section ==  4)
        sectionTitle = @"Commands Restrictions :";
    
    else if(section ==  5)
        sectionTitle = @"Notifiers Restrictions :";
    
    else if(section ==  6)
        sectionTitle = @"Reports Restrictions :";
    
    
    return sectionTitle;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
}


// custom view for header. will be adjusted to default or specified header height



-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    //Set the background color of the View
    //    view.backgroundColor = [UIColor blueColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    [header.textLabel setFont:[UIFont fontWithName:@"Palatino-Bold" size:15]];
    [header.textLabel setTextColor:[UIColor colorWithRed:1.0/256.0 green:98.0/256.0 blue:153.0/256.0 alpha:1]];
    
    [header.backgroundView setBackgroundColor:[UIColor lightTextColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = nil;
    
    //    cell = [tableView dequeueReusableCellWithIdentifier:@"Group Cell"];
    
    //    if(cell ==  nil){
    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Group Cell"];
    //    }
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Group Cell"];
    }
    
    cell.textLabel.textColor =  [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font =[UIFont fontWithName:@"Palatino-bold" size:15];

    if(indexPath.section == 0)
    {
        if(!txtName){
            txtName = [[UITextField alloc]initWithFrame:CGRectMake(100, 5, 210, 30)];
            
        }
        
        [cell addSubview:txtName];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Name :"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    else if(indexPath.section == 1){
        
        cell.textLabel.text =[NSString stringWithFormat:@"%@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if([self.arrSelectedDevice containsObject:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"id"]]){
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
    }
    else{
        
        NSMutableDictionary *dic = [self.arrMain objectAtIndex:indexPath.section-2];
        
        if(dic != NULL){
            
            NSArray *arrKeys =  [dic allKeys];
            
            cell.textLabel.text = [arrKeys objectAtIndex:indexPath.row];
            
            if([[dic valueForKey:[arrKeys objectAtIndex:indexPath.row]] isEqualToString:@"true"]){
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            }
            
            else {
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    
    if(indexPath.section == 1){
        
        if (cell.accessoryType==UITableViewCellAccessoryNone)
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            
            [self.arrSelectedDevice addObject:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"id"]];
            
        }
        
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            
            [self.arrSelectedDevice removeObject:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"id"]];
            
        }
    }
    
    else {
        
        if (cell.accessoryType==UITableViewCellAccessoryNone)
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            
            NSMutableDictionary *dic = [self.arrMain objectAtIndex:indexPath.section-2];
            [dic setValue:@"true" forKey:cell.textLabel.text];
            
        }
        
        else {
            
            cell.accessoryType=UITableViewCellAccessoryNone;
            
            NSMutableDictionary *dic = [self.arrMain objectAtIndex:indexPath.section-2];
            [dic setValue:@"false" forKey:cell.textLabel.text];
            
        }
        
    }
}


#pragma mark -
#pragma mark UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}





@end
