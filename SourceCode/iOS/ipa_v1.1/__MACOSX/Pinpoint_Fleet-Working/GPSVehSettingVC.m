//
//  GPSVehSettingVC.m
//  OpenGTS
//
//  Created by Sandip Rudani on 04/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSVehSettingVC.h"

#import "GPSAppDelegate.h"

#import "MBProgressHUD.h"

#import "GPSMapVC.h"

@interface GPSVehSettingVC (){
    
    GPSAppDelegate *objAppDelegate;

    MBProgressHUD *hud;
    
    UIDatePicker *MyDatePicker;
    
    UIActionSheet *ac;
    
    NSDateFormatter *df,*dfDisplay;
    
    UIPickerView *pickerView;
    
    int i;
    
    IBOutlet  UIScrollView *scroll;
    
    NSString *strAlertString;
    NSString *strVehID;
    
    IBOutlet UIImageView *imagvw;
    
    NSMutableDictionary *dicMain;
    
    BOOL keyboardVisible;

    UIPopoverController *popoverController;
    
    NSArray *arrSorting;


}

@property(nonatomic,retain)NSMutableArray *arrVehicleList,*arrTimezone,*arrDeviceName,*arrDeviceID;
@property(nonatomic,retain)NSMutableDictionary *dicDevice;

@end

@implementation GPSVehSettingVC

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
    // Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:[UIColor blueColor]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
//												 name: UIKeyboardDidShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
//												 name: UIKeyboardDidHideNotification object:nil];
//    
//	//Initially the keyboard is hidden
//	keyboardVisible = NO;
    
    objAppDelegate = (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    imagvw.layer.cornerRadius = 4.0;
    
    imagvw.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    imagvw.layer.borderWidth = 2.0;
    
    df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.navigationItem.title = @"Map View";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
    }
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];

    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    //[hud show:YES];
    
    _arrVehicleList =[[NSMutableArray alloc]init];
    
    _arrDeviceName = [[NSMutableArray alloc]init];
    _arrDeviceID = [[NSMutableArray alloc]init];
    
    dicMain = [[NSMutableDictionary alloc]init];
    
    self.dicDevice = [[NSMutableDictionary alloc]init];

    [self CheckForVehicleDevice];
    
    //Start Day for current Date
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];

    NSDate *midnightOfToday = [cal dateFromComponents:comps];
    //====
    self.txtStartDate.text = [df stringFromDate:midnightOfToday];
    self.txtEndDate.text = [df stringFromDate:[NSDate date]];
    
    if([objAppDelegate.arrVehicleList count]>0){
        if(self.txtVehIDList){
        
//            self.txtVehIDList.text=[self.arrDeviceName objectAtIndex:0];
//            strVehID =[self.arrDeviceID objectAtIndex:0];
            
            NSArray* foo = [[self.arrDeviceName objectAtIndex:0]componentsSeparatedByString:@"+"];
            self.txtVehIDList.text= [foo objectAtIndex: 0];
            strVehID = [foo objectAtIndex:1];
        }
        
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

}
-(void)CheckForVehicleDevice{
    
    if([objAppDelegate.arrVehicleList count] > 0){
        
//        for (NSDictionary *dicList in objAppDelegate.arrVehicleList) {
//            
//            NSArray *arrDeviceList = [dicList objectForKey:@"DeviceList"];
//            
//            for (NSDictionary *dicDevice in arrDeviceList ) {
////                NSString *account_id = [dicDevice valueForKey:@"account_id"];
////                NSString *deviceDesc = [dicDevice valueForKey:@"deviceDesc"];
//                NSString *deviceID = [dicDevice valueForKey:@"deviceID"];
//                NSString *name = [dicDevice valueForKey:@"name"];
//                [self.arrDeviceName addObject:name];
//                [self.arrDeviceID addObject:deviceID];
//            }
//        }
        
        for (NSDictionary *dic in objAppDelegate.arrVehicleList){
            
            NSArray *arrList = [dic valueForKey:@"List"];
            
            for (NSDictionary *dicID in arrList) {
                
                if([dicID objectForKey:@"List"]){
                    
                    NSArray *arrNewDic = [dicID objectForKey:@"List"];
                    for (NSDictionary *newDic in arrNewDic) {
                        
                        
                        
                        NSString *deviceID = [newDic valueForKey:@"deviceID"];
                        NSString *name = [newDic valueForKey:@"name"];
//                        [self.arrDeviceName addObject:name];
//                        [self.arrDeviceID addObject:deviceID];
                        
                        [self.arrDeviceName addObject:[NSString stringWithFormat:@"%@+%@",name,deviceID]];
                        
                        
                    }
                    
                }
                
                else {
                    NSString *deviceID = [dicID valueForKey:@"deviceID"];
                    NSString *name = [dicID valueForKey:@"name"];
//                    [self.arrDeviceName addObject:name];
//                    [self.arrDeviceID addObject:deviceID];
                    
                    
                    [self.arrDeviceName addObject:[NSString stringWithFormat:@"%@+%@",name,deviceID]];


             
                }
            }
        }
         //Remove duplicate
        self.arrDeviceName = [[NSSet setWithArray:self.arrDeviceName] allObjects];
        self.arrDeviceName = [[self.arrDeviceName sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]mutableCopy];
       
      
        NSLog(@"arr device count --> %d",self.arrDeviceName.count);
        NSLog(@"arr device name --> %@",[self.arrDeviceName description]);
        
        [self performSelectorOnMainThread:@selector(DisplayData) withObject:nil waitUntilDone:NO];
    }
}

-(void)CheckNetworkAvailability {
    
    
    if ([objAppDelegate isNetworkAvailable]) {
        
//        [hud show:YES];
        
        [self GetVehicleList];
        
        
    }
    else{
        
        strAlertString = @"Fail to Load Device List . Please try again later !!";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
    
}

-(void)viewDidLayoutSubviews{
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height );
    
    
    int type = [UIApplication sharedApplication].statusBarOrientation;
    
    if (type == 1 || type == 2 ) {
        NSLog(@"portrait default");
        
        MyDatePicker.transform = CGAffineTransformIdentity;
        MyDatePicker.frame =CGRectMake(0,40, 300, 400);
        
        pickerView.transform = CGAffineTransformIdentity;
        pickerView.frame =CGRectMake(0,40, 300, 300);    }
    
    else if(type ==3 || type ==4){
        NSLog(@"Landscape right");
        MyDatePicker.transform = CGAffineTransformMakeScale(0.65, 0.65);
        MyDatePicker.frame =CGRectMake(0,40, 300, 400);
        
        pickerView.transform = CGAffineTransformMakeScale(0.65, 0.65);
        pickerView.frame =CGRectMake(0,40, 300, 300);
        
    }
    
}

-(IBAction)Cancel:(id)sender{
    
    objAppDelegate.isLoadAllData = FALSE;
    objAppDelegate.notTopController = TRUE;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)Save:(id)sender
{
    
    [self CompareDate];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        strAlertString = @"Back to Map View !!";
//        
//        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
//    }];
    
}
- (IBAction)btnLast24HourClicked:(UIButton *)sender {
    //Start Day for current Date
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [comps setHour:-24];
    [comps setMinute:0];
    [comps setSecond:0];

    NSDate *midnightOfToday = [cal dateFromComponents:comps];
    //====
    self.txtStartDate.text = [df stringFromDate:midnightOfToday];
    self.txtEndDate.text = [df stringFromDate:[NSDate date]];
}
- (IBAction)last3DaysButtonClicked:(UIButton *)sender {
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [comps setHour:-72];
    [comps setMinute:0];
    [comps setSecond:0];

    NSDate *midnightOfToday = [cal dateFromComponents:comps];
    //====
    self.txtStartDate.text = [df stringFromDate:midnightOfToday];
    self.txtEndDate.text = [df stringFromDate:[NSDate date]];
}

-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}

-(void)CompareDate{
    
    NSDate *StartDate = [df dateFromString:self.txtStartDate.text];
    NSDate *EndDate = [df dateFromString:self.txtEndDate.text];
    
    NSLog(@"StartDate-1:%@",StartDate);
    NSLog(@"EndDate-1:%@",EndDate);
    if ([StartDate compare:EndDate] == NSOrderedDescending) {
        NSLog(@"StartDate is later than EndDate");
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select proper date !!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        
    } else if ([StartDate compare:EndDate] == NSOrderedAscending) {
        NSLog(@"SatrtDate is earlier than EndDate");
        
        [self UploadData];
        
    } else {
        NSLog(@"dates are the same");
        [self UploadData];
        
    }
    
}

-(void)UploadData{
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
//    GPSMapVC *screen = (GPSMapVC*)[storyboard instantiateViewControllerWithIdentifier:@"GPSMapVC"];
    objAppDelegate.isFromRightSideMenu = FALSE;
    
    NSLog(@"vehicle id : %@",strVehID);
    
    if(strVehID.length == 0){
        
        strAlertString = @"Please select device !!";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:YES];
    }
    
    else {
//        df = [[NSDateFormatter alloc]init];
//        [df setDateFormat:@"yyyy-MM-dd"];
        
         NSDate *dateStart = [df dateFromString:self.txtStartDate.text];
         NSDate *dateEnd = [df dateFromString:self.txtEndDate.text];
         //NSLog(@"StartDate:%@",dateStart);
         //NSLog(@"EndDate:%@",dateEnd);
        //[df setDateFormat:@"yyyy-MM-dd"];
       
        [df setDateFormat:@"MM/dd/yyyy HH:mm"];
        // df.timeZone = [NSTimeZone timeZoneWithName:@"IST"] ;
        
        
//        NSDictionary *dic = @{@"Fr_Dt":self.txtStartDate.text,@"To_Dt":self.txtEndDate.text,@"VehID":strVehID};
        
         NSLog(@"textfield strat date --> %@ && End Date --> %@ \n strdate -- %@  EndDate -- %@",self.txtStartDate.text,self.txtEndDate.text,dateStart,dateEnd);
        
            NSDictionary *dic = @{@"Fr_Dt":[df stringFromDate:dateStart],@"To_Dt":[df stringFromDate:dateEnd],@"VehID":strVehID};
        
        NSLog(@"textfield strat date --> %@ && End Date --> %@ \n dic --> %@",self.txtStartDate.text,self.txtEndDate.text,[dic description]);

        objAppDelegate.dicVehSetting = [dic mutableCopy];
            
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMapForCurrentDate" object:nil userInfo:dic];

        NSLog(@"dic description -- %@ && objAppDelegate.dicVehSetting --> %@",[dic description],[objAppDelegate.dicVehSetting description]);
    
        objAppDelegate.isLoadAllData = FALSE;
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }     //[self GetVehicleDetail];
    
//    objAppDelegate.isLoadAllData = FALSE;
  
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)GetVehicleList{
    
    
    NSLog(@"GetVehicleListFromServer Called !! ");
    
    
    NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=deviceList",LiveURL];
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    //  [[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
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
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data %@",[jsonData description]);
             
             
             if ([jsonData isKindOfClass:[NSArray class]]) { //1-2
                 
                 NSLog(@"its Array");

                 
//                 NSMutableArray *topItems = jsonData;
 
//                 for (NSDictionary *dicList in topItems) {
//                     
//                     NSArray *arrDeviceList = [dicList objectForKey:@"DeviceList"];
//                     
//                     for (NSDictionary *dicDevice in arrDeviceList ) {
////                         NSString *account_id = [dicDevice valueForKey:@"account_id"];
////                         NSString *deviceDesc = [dicDevice valueForKey:@"deviceDesc"];
//                         NSString *deviceID = [dicDevice valueForKey:@"deviceID"];
//                         NSString *name = [dicDevice valueForKey:@"name"];
//                         [self.arrDeviceName addObject:name];
//                         [self.arrDeviceID addObject:deviceID];
//                     }
//                 }
//                   NSLog(@"sub array list Name -- %@ && Id --%@",[self.arrDeviceName description],[self.arrDeviceID description]);
                 
                 [self performSelectorOnMainThread:@selector(DisplayData) withObject:nil waitUntilDone:NO];
                        
             }
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                if([jsonData valueForKey:@"success"]){
                    
                    if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                    
                        NSLog(@"its Dictionary for success = FALSE");

                        strAlertString = @"No Data Found";

                        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                
                    }
                }
                 
                else {
                 
                 objAppDelegate.arrVehicleList = [jsonData valueForKey:@"List"];
                 
                 for (NSDictionary *dic in objAppDelegate.arrVehicleList){
                     
                     NSArray *arrList = [dic valueForKey:@"List"];
                     
                     for (NSDictionary *dicID in arrList) {
                         
                         if([dicID objectForKey:@"List"]){
                             
                             NSArray *arrNewDic = [dicID objectForKey:@"List"];
                             for (NSDictionary *newDic in arrNewDic) {
                                 
                                 NSString *deviceID = [newDic valueForKey:@"deviceID"];
                                 NSString *name = [newDic valueForKey:@"name"];
                                 //                        [self.arrDeviceName addObject:name];
                                 //                        [self.arrDeviceID addObject:deviceID];
                                 
                                 [self.arrDeviceName addObject:[NSString stringWithFormat:@"%@+%@",name,deviceID]];
                                 NSLog(@"NAME",[self.arrDeviceName description]);
                                 
                             }
                             
                         }
                         
                         else {
                             NSString *deviceID = [dicID valueForKey:@"deviceID"];
                             NSString *name = [dicID valueForKey:@"name"];
                             //                    [self.arrDeviceName addObject:name];
                             //                    [self.arrDeviceID addObject:deviceID];
                             
                             [self.arrDeviceName addObject:[NSString stringWithFormat:@"%@+%@",name,deviceID]];
                             
                         }
                     }
                 }
                       
            }
                 
//                 NSLog(@"its Dictionary for success = FALSE");
//                 
//                 strAlertString = @"Please try again later";
//                 
//                 [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                 
             }
             
         }
         
     }];
    
    self.arrDeviceName = [[self.arrDeviceName sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]mutableCopy];
    
    NSLog(@"arr device name --> %@",[self.arrDeviceName description]);

    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
}

-(void)DisplayData{
    
    if ([self.arrDeviceName count]>0) {
        NSArray* foo = [[self.arrDeviceName objectAtIndex:0] componentsSeparatedByString: @"+"];
        self.txtVehIDList.text= [foo objectAtIndex: 0];
        strVehID = [foo objectAtIndex:1];
    }
    
   
}

-(void)GetVehicleDetail{
    
    NSLog(@"GetVehicleDetailFromServer Called !! ");
    
    
    NSString *strURL=[NSString stringWithFormat:@"%@/OpenGTS/opengts?reqType=mapDetails",LiveURL];
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];

    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&deviceID=%@&date_fr=%@&date_to=%@&tmz=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],self.txtVehIDList.text,self.txtStartDate.text,self.txtEndDate.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"timezone"]];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //start the connection
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//    { //1
    
    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

    if (error) {
        


             UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"Its error inside  getvehicledetail --");
        
    }
    else{ //1
        

        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            NSLog(@"its dictionary");
            
        }
        
        
    }
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];

//      }];
    
    
}

#pragma mark -
#pragma mark pickerview method

-(void)cancelPicker:(id)sender{
	
//    [self textFieldShouldReturn:self.txtVehIDList];
//    
//    [self textFieldShouldReturn:self.txtStartDate];
//    
//    [self textFieldShouldReturn:self.txtEndDate];


    
   if(pickerView.window){
        [pickerView resignFirstResponder];
       
        if([objAppDelegate.arrVehicleList count]>0){
        
        NSInteger row = [pickerView selectedRowInComponent:0];
        
        if(i==0){
            
//            self.txtVehIDList.text=[self.arrDeviceName objectAtIndex:row];
//            strVehID =[self.arrDeviceID objectAtIndex:row];
            
            NSArray* foo = [[self.arrDeviceName objectAtIndex:row] componentsSeparatedByString: @"+"];
            self.txtVehIDList.text= [foo objectAtIndex: 0];
            strVehID = [foo objectAtIndex:1];
            
            [self textFieldShouldReturn:self.txtVehIDList];
            
        }
            

        }
       
       [self textFieldShouldReturn:self.txtVehIDList];

       
    }
    
    if(i==1){
        [df setDateFormat:@"MM/dd/yyyy HH:mm"];

        
        self.txtStartDate.text= [NSString stringWithFormat:@"%@",
                                 [df stringFromDate:MyDatePicker.date]];
        
        
        [self textFieldShouldReturn:self.txtStartDate];
        
    }
    
    if(i==2){
        
        [df setDateFormat:@"MM/dd/yyyy HH:mm"];

        
        self.txtEndDate.text= [NSString stringWithFormat:@"%@",
                               [df stringFromDate:MyDatePicker.date]];
        
        
        [self textFieldShouldReturn:self.txtEndDate];
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    } else {
        return NO;
    }
}

//-(IBAction)showPickerView:(UITextField*)sender{
//	
//	ac=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
////	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,50,self.view.frame.size.width,350)];
//    pickerView = [[UIPickerView alloc] init];
//	pickerView.hidden=NO;
//	pickerView.delegate = self;
//	pickerView.showsSelectionIndicator = YES;
//	[pickerView selectRow:0 inComponent:0 animated:NO];
//    
//    
//    if(i==0){
//        
//        self.txtVehIDList.text=[self.arrDeviceName objectAtIndex:0];
//        strVehID =[self.arrDeviceID objectAtIndex:0];
//    }
////    if(i==3){
////        
////        self.txtTimeZone.text=[self.arrTimezone objectAtIndex:0];
////    }
//    
//    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,300, 40)];
//    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//	
//	UIButton*btndone = [UIButton buttonWithType:UIButtonTypeCustom];
//	btndone.frame = CGRectMake(250, 5, 60, 30);
//    [[btndone titleLabel] setFont:[UIFont fontWithName:@"Helvetica Bold " size:15]];
//    [btndone setTitle:@"Done" forState:UIControlStateNormal];
//    [btndone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btndone setBackgroundImage:[UIImage imageNamed:@"search-criteria.png"] forState:UIControlStateNormal];
//	[btndone addTarget:self action:@selector(cancelDiscountPickerView:) forControlEvents:UIControlEventTouchDown];
//	
//	[ac addSubview:toolbar];
//	[toolbar addSubview:btndone];
//	
//	[ac addSubview:pickerView];
//	
//	[ac showInView:self.view];
//   	[ac setBounds:CGRectMake(0,0,300,400)];
//    
//    [pickerView sizeToFit];
////    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//
//
//}
//
//-(void)cancelDiscountPickerView:(id)sender{
//	
//	[ac dismissWithClickedButtonIndex:0 animated:YES];
//    
//    
//    if(i==0){
//        
//        [self textFieldShouldReturn:self.txtVehIDList];
//        
//	}
////    if (i==3){
////        
////        [self textFieldShouldReturn:self.txtTimeZone];
////            
////	}
//	
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	
	int sectionWidth = 320;
	
	return sectionWidth;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strTitle;
  
    if (i==0) {
       // strTitle= [self.arrVehicleList objectAtIndex:row];
        
         if([objAppDelegate.arrVehicleList count]>0){
             
//        strTitle= [self.arrDeviceName objectAtIndex:row];
       
             NSArray* foo = [[self.arrDeviceName objectAtIndex:row] componentsSeparatedByString: @"+"];
             strTitle= [foo objectAtIndex: 0];
             NSLog(@" Title --> %@", strTitle);
           
             
         }

    }
    
//     if(i==3){
//        
//        strTitle= [self.arrTimezone objectAtIndex:row];
//
//    }
    
    return strTitle;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(i==0){
        
         if([objAppDelegate.arrVehicleList count]>0){
        
//          self.txtVehIDList.text = [self.arrDeviceName objectAtIndex:row];
//        
//          strVehID = [self.arrDeviceID objectAtIndex:row];
             
//             NSArray* values = [self.dicDevice allValues];
//             NSArray* sortedValues = [values sortedArrayUsingSelector:@selector(comparator)];
             
             NSArray* foo = [[self.arrDeviceName objectAtIndex:row] componentsSeparatedByString: @"+"];
             self.txtVehIDList.text= [foo objectAtIndex: 0];
             strVehID = [foo objectAtIndex:1];
             
             
         }

	}
   
//	 if (i==3){
//        
//        self.txtTimeZone.text = [self.arrTimezone objectAtIndex:row];
//        
//	}
 
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
    
    if(i==0){
		return [self.arrDeviceName count];
        
    }
    
//     if(i==3){
//		return [self.arrTimezone count];
//        
//    }
//    
    
	return 0;
	
}

#pragma mark -
#pragma mark datePickerMode method


-(IBAction)showDatePicker:(id)sender{

    
    
    // for iPad
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
  
        [sender resignFirstResponder];
        df = [[NSDateFormatter alloc] init];
      
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelDatePicker:)];
        doneBtn.tintColor = [UIColor whiteColor];
        [barItems addObject:doneBtn];
        [pickerToolbar setItems:barItems animated:YES];
        
        MyDatePicker = [[UIDatePicker alloc] init];
        MyDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        if (@available(iOS 13.4, *)) {
            MyDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        [df setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        MyDatePicker.date = [NSDate date];
        MyDatePicker.maximumDate = [NSDate date];
        
        if(i==1){
            //Start Day for current Date
            NSCalendar *cal = [NSCalendar currentCalendar];

            NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
            [comps setHour:0];
            [comps setMinute:0];
            [comps setSecond:0];

            NSDate *midnightOfToday = [cal dateFromComponents:comps];
            //====
            MyDatePicker.date = midnightOfToday;
            self.txtStartDate.text = [df stringFromDate:MyDatePicker.date];
        }
        
        if(i==2){
            
            self.txtEndDate.text = [df stringFromDate:MyDatePicker.date];
        }

        
        CGRect pickerRect = MyDatePicker.bounds;
        MyDatePicker.bounds = pickerRect;
        
        UIViewController* popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 344)];
        popoverView.backgroundColor = [UIColor whiteColor];
        
        MyDatePicker.frame = CGRectMake(0, 44, 320, 300);
        [MyDatePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
        [popoverView addSubview:pickerToolbar];
        [popoverView addSubview:MyDatePicker];
        popoverContent.view = popoverView;
        
        //resize the popover view shown
        //in the current view to the view's size
        popoverContent.preferredContentSize = CGSizeMake(320, 244);
        
        //create a popover controller
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        CGRect popoverRect = [self.view convertRect:[sender frame]
                                           fromView:[sender superview]];
        
        popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
        popoverRect.origin.x  = popoverRect.origin.x;
        // popoverRect.size.height  = ;
        [popoverController
         presentPopoverFromRect:popoverRect
         inView:self.view
         permittedArrowDirections:UIPopoverArrowDirectionAny  animated:YES];
        
    }
    
    else {
        
        
        MyDatePicker = [[UIDatePicker alloc] init];
        MyDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        if (@available(iOS 13.4, *)) {
            MyDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        [df setDateFormat:@"MM/dd/yyyy HH:mm"];
        
        MyDatePicker.date = [NSDate date];
        MyDatePicker.maximumDate = [NSDate date];
        
//        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
//        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker:)];
//        [toolbar setItems:[NSArray arrayWithObjects:btnDone, nil]];
        
        
        if(i==1){
            //Start Day for current Date
            NSCalendar *cal = [NSCalendar currentCalendar];

            NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
            [comps setHour:0];
            [comps setMinute:0];
            [comps setSecond:0];

            NSDate *midnightOfToday = [cal dateFromComponents:comps];
            //====
            MyDatePicker.date = midnightOfToday;
            self.txtStartDate.inputView = MyDatePicker;
            
            self.txtStartDate.text = [df stringFromDate:MyDatePicker.date];
        }
        
        if(i==2){
            self.txtEndDate.inputView = MyDatePicker;

            self.txtEndDate.text = [df stringFromDate:MyDatePicker.date];
        }
        [MyDatePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];

        
        
//        ac=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//        
//        MyDatePicker = [[UIDatePicker alloc] init];
//        
//        MyDatePicker.datePickerMode = UIDatePickerModeDate;
//        [MyDatePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
//        MyDatePicker.hidden = NO;
//        
//        [df setDateFormat:@"MM/dd/yyyy"];
//        
//        MyDatePicker.date = [NSDate date];
//        MyDatePicker.maximumDate = [NSDate date];
//        //  MyDatePicker.minimumDate=[NSDate date];
//        
//        //    [df setDateFormat:@"yyyy-MM-dd"];
//        
//        if(i==1){
//            
//            self.txtStartDate.text = [df stringFromDate:MyDatePicker.date];
//        }
//        
//        if(i==2){
//            
//            self.txtEndDate.text = [df stringFromDate:MyDatePicker.date];
//        }
//        
//        UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
//        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
//        
//        UIButton *btndone = [UIButton buttonWithType:UIButtonTypeCustom];
//        btndone.frame = CGRectMake(230, 5, 50, 20);
//        [[btndone titleLabel] setFont:[UIFont fontWithName:@"Helvetica Bold " size:14]];
//        [btndone setTitle:@"Done" forState:UIControlStateNormal];
//        [btndone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btndone setBackgroundImage:[UIImage imageNamed:@"search-criteria.png"] forState:UIControlStateNormal];
//        [btndone addTarget:self action:@selector(cancelDatePicker:) forControlEvents:UIControlEventTouchDown];
//        
//        [ac addSubview:toolbar];
//        [toolbar addSubview:btndone];
//        
//        [ac addSubview:MyDatePicker];
//        
//        [ac showInView:self.view];
//        [ac setBounds:CGRectMake(0,0,300,330)];
    }
   
}

- (void)updateDateField:(UITextField*)sender
{
    UIDatePicker *picker = (UIDatePicker*)sender.inputView;
	if(i==1){
        
        self.txtStartDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]];
    }
    
    if(i==2){
        
        
        self.txtEndDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]];
    }

    [sender resignFirstResponder];
}


-(void)cancelDatePicker:(id)sender{
    
	[ac dismissWithClickedButtonIndex:0 animated:YES];
    
    if(i==1){
        
        self.txtStartDate.text= [NSString stringWithFormat:@"%@",
                            [df stringFromDate:MyDatePicker.date]];

        
        [self textFieldShouldReturn:self.txtStartDate];
     
    }
    
    if(i==2){
        
        self.txtEndDate.text= [NSString stringWithFormat:@"%@",
                            [df stringFromDate:MyDatePicker.date]];

        
        [self textFieldShouldReturn:self.txtEndDate];

    }
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
        popoverController=nil;
    }
	
}

-(void)changeDate{
    
	if(i==1){
        
        	self.txtStartDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:MyDatePicker.date]];
    }
    
    if(i==2){
        
        
        self.txtEndDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:MyDatePicker.date]];
    }

	
}


//-(void) keyboardDidShow: (NSNotification *)notif
//{
//	// If keyboard is visible, return
//	if (keyboardVisible)
//    {
//		NSLog(@"Keyboard is already visible. Ignore notification.");
//		return;
//	}
//    
//	// Get the size of the keyboard.
//	NSDictionary* info = [notif userInfo];
//	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
//	CGSize keyboardSize = [aValue CGRectValue].size;
//	
//    // Save the current location so we can restore
//    // when keyboard is dismissed
//    offset = scrollview.contentOffset;
//    
//	// Resize the scroll view to make room for the keyboard
//	CGRect viewFrame = scrollview.frame;
//	viewFrame.size.height -= keyboardSize.height;
//	scrollview.frame = viewFrame;
//    
//	// Keyboard is now visible
//	keyboardVisible = YES;
//}
//
//-(void) keyboardDidHide: (NSNotification *)notif
//{
//	// Is the keyboard already shown
//	if (!keyboardVisible)
//    {
//		NSLog(@"Keyboard is already hidden. Ignore notification.");
//		return;
//	}
//	
//	// Reset the frame scroll view to its original value
//    scrollview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//	// Reset the scrollview to previous location
//    scrollview.contentOffset = offset;
//    
//	// Keyboard is no longer visible
//	keyboardVisible = NO;
//	
//}
#pragma mark -
#pragma mark textField method




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
	
    if(textField==self.txtVehIDList){
        
//        if([objAppDelegate.arrVehicleList count]>0){
        
            i=0;
        
            pickerView = [[UIPickerView alloc] init];
            pickerView.dataSource = self;
            pickerView.delegate = self;
            self.txtVehIDList.inputView = pickerView;
        
        
     //   }
        
//        return NO;
	}
    
    
    else if(textField==self.txtStartDate){
        
         i=1;
         
                [self showDatePicker:self.txtStartDate];

        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
            return NO;

//         if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad){
//             
//             [self showDatePicker:self.txtStartDate];
//             return NO;
//         }
//         
//         else {
//             
//             UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//             datePicker.datePickerMode = UIDatePickerModeDate;
//             
//             //  MyDatePicker.minimumDate=[NSDate date];
//             
//             [df setDateFormat:@"MM/dd/yyyy"];
//             
//             MyDatePicker.date = [NSDate date];
//             MyDatePicker.maximumDate = [NSDate date];
//             //  MyDatePicker.minimumDate=[NSDate date];
//             
//             //    [df setDateFormat:@"yyyy-MM-dd"];
//             
//             self.txtStartDate.inputView = datePicker;
//
//             
//             self.txtStartDate.text = [df stringFromDate:MyDatePicker.date];
//            
//            
//             [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
//         }
       

	}
    
    else if(textField==self.txtEndDate){
        
        i=2;
		
        [self showDatePicker:self.txtEndDate];
       
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
            return NO;

	}
    
//    else if(textField==self.txtTimeZone){
//        
//        i=3;
//		
//        [self showPickerView:self.txtTimeZone];
//        return NO;
//
//	}
	
	
	return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
//{
//    if([textField isEqual:self.txtVehIDList])
//        return NO;
//    return YES;
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [textField resignFirstResponder]; // hides keyboard
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
	[textField resignFirstResponder];
	return YES;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
