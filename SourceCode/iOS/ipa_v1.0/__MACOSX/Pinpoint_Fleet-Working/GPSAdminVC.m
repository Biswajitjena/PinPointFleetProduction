//
//  GPSAdminVC.m
//  OpenGTS
//
//  Created by Sandip Rudani on 12/06/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSAdminVC.h"



@interface GPSAdminVC ()

@end

@implementation GPSAdminVC

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
    
    objDelegate = (GPSAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    arrMain = [[NSMutableArray alloc]init];
    
    dicGroupEdit = [[NSMutableDictionary alloc]init];

//    arrMain = [[NSMutableArray alloc]initWithArray:objDelegate.arrDeviceList];
    
 
    
    UIBarButtonItem *AddButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(DisplayAlertViewForAdd:)];
    
    AddButton.enabled = TRUE;
    
    AddButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = AddButton;
    
  //  if ([[UINavigationBar appearance] respondsToSelector:@selector(setBarTintColor:)]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/256.0 green:172.0/256.0 blue:164.0/256.0 alpha:1]];
        
//    }
//    
//    else
//        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0/256.0 green:172.0/256.0 blue:164.0/256.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self CheckSegueIdentifier];
    
    [self PullData];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self.tableView reloadData];
    
}

-(void)CheckSegueIdentifier{
    
    
    if ([self.strSegueIdentifier isEqualToString:@"AccountAdmin"]){
            isAccountAdmin=TRUE;
        
        self.navigationItem.title =@"Account ";
    }
        
    else if([self.strSegueIdentifier isEqualToString:@"UserAdmin"]){
            isUserAdmin=TRUE;
        
        self.navigationItem.title = @"User";
    }
    else if([self.strSegueIdentifier isEqualToString:@"VehicleAdmin"]){
            isVehicleAdmin=TRUE;
        
        self.navigationItem.title = @"Vehicle";
    }
    else if([self.strSegueIdentifier isEqualToString:@"GroupAdmin"]){

            isGroupAdmin=TRUE;
        
        self.navigationItem.title = @"Group";
    
    }
    
}

-(IBAction)DisplayAlertViewForAdd:(id)sender{
    
    
    
    if(!isAddDelAllow){
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You don't have permission to add record!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [avalert show];
    }
    
    else {
    
    NSString *strAlertTitle=@"";
    
    
    if(isGroupAdmin)
        strAlertTitle=@"Add Group";
    
    else if (isVehicleAdmin)
        strAlertTitle=@"Add Vehicle";
    
    else if(isUserAdmin)
        strAlertTitle=@"Add User";
        
    alertview = [[UIAlertView alloc] initWithTitle:@"Add" message:strAlertTitle delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertview.delegate=self;
    alertview.tag=100;
    
    [[alertview textFieldAtIndex:0] setDelegate:self];

    [alertview show];
        
    }
    
}

-(void)DisplayAlertViewForEdit{
    
    if(!isAddDelAllow){
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You don't have permission to edit record!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [avalert show];
    }
    
    else {
    
    alertview = [[UIAlertView alloc] initWithTitle:@"Edit" message:@"Group Name"delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertview.delegate=self;
    alertview.tag=101;
    
    [[alertview textFieldAtIndex:0] setDelegate:self];
    
        [alertview show];
    
   }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==100){
        
        if(buttonIndex == 1){
            
            if(isVehicleAdmin)
                [self AddDeviceOnServer];
            else if (isGroupAdmin)
                [self AddGroupOnServer];
            else if(isUserAdmin)
                [self AddUserOnServer];
            
        [self.tableView reloadData];
        }
    }
    
    else if(alertView.tag==101){
        
        if(buttonIndex==1){
            
            if ([dicGroupEdit count]!=0) {
            
              UITextField *groupname = [alertview textFieldAtIndex:0];
            [self EditGroup:[dicGroupEdit valueForKey:@"groupid"] Name:groupname.text];
                
                [self.tableView reloadData];
            }
        }
        
    }
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];

    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
}

-(void)PullData{
    
    if ([objDelegate isNetworkAvailable]) {
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
 //   [hud setTintColor:[UIColor lightTextColor]];
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    [hud show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        // NSLog(@"From Server !!");
        if(isVehicleAdmin)
            [self GetVehicleList];
        else if(isGroupAdmin)
            [self GetGroupList];
        else if(isUserAdmin)
            [self GetUserList];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            [hud hide:YES];
            [self.tableView reloadData];
            
        });
        
    });
    
}
    
    else{
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Sorry !" message:@"Network is unavailable.Pleae try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [av show];
            
        });
        
        
    }
    
}


-(void)AddDeviceOnServer{
    
    UITextField *username = [alertview textFieldAtIndex:0];
    
    
    NSLog(@"AddDevice Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=addVehicle"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&vehicleID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],username.text];
    
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        NSLog(@"--Its error inside  getvehicle list ---");
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Upload Data Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                [self GetVehicleList];

                
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });;
        
    }
    
    //  }];
    
    [hud show:YES];
    
}


-(void)GetVehicleList{
    
    
    NSLog(@"View Vehicle Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=vehicleDetails"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
  NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]];
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
//           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//            { //1
    
    
    if (error) {
        
                 [hud hide:YES];


                 UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
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
            
            
            arrMain=[jsonData valueForKey:@"vehicleData"];
            
            NSLog(@"arrVehicleData Data %@",[arrMain description]);
            
            
            if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"false"]) {
                
                isAddDelAllow  = FALSE;
                
                
                
            }
            
            else if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"true"]) {
                
                isAddDelAllow = TRUE;
            }
            
            
            if ([[jsonData valueForKey:@"edit"] isEqualToString:@"false"]){
                
                isEdit=FALSE;
            }
            
            else if ([[jsonData valueForKey:@"edit"] isEqualToString:@"true"]){
                
                isEdit=TRUE;
            }
            
            
        }
        
    }
                
  //  }];
    
    [hud show:YES];
    
}


-(BOOL)DeleteVehicle:(NSString*)strDeviceID{
    
    
    BOOL isSuccess;
    
    NSLog(@"DeleteData Vehicle Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=deleteVehicle"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
   

    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&deviceID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],strDeviceID];
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Delete Vehicle Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
//                [self GetVehicleList];
                
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });
        
    }
    
    //  }];
    
    [hud show:YES];
    
    return isSuccess;
    
}

/// Group Admin

-(void)AddGroupOnServer{
    
    UITextField *username = [alertview textFieldAtIndex:0];

    
    
    NSLog(@"AddDevice Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=newGroupAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&g_newname=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],username.text];
    
    NSLog(@"poststring %@ ", postString);
    
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        //  [hud hide:YES];
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        NSLog(@"--Its error inside  getvehicle list ---");
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            // [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Upload Data Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                [self GetGroupList];

                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });
        
    }
    
    //  }];
    
        [hud show:YES];
    
}

-(void)GetGroupList{
    
    NSLog(@"GetGroupList Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=viewGroupAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]];
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
    }
    else{ //1
        
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
        
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            NSLog(@"its Dictionary");
            
            
        arrMain=[jsonData valueForKey:@"groupAdminInfo"];
            
            NSLog(@"arrVehicleData Data %@",[arrMain description]);
            
            
            if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"false"]) {
                
                isAddDelAllow  = FALSE;
            
            }
            
            else if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"true"]) {
                
                isAddDelAllow = TRUE;
            }
            
            if ([[jsonData valueForKey:@"edit"] isEqualToString:@"false"]){
                
                isEdit=FALSE;
            }
            
            else if ([[jsonData valueForKey:@"edit"] isEqualToString:@"true"]){
                
                isEdit=TRUE;
            }
            
        }
        
    }
    
    //  }];
    
      [hud show:YES];
    
}


-(BOOL)DeleteGroup:(NSString*)strDeviceID{
    
    BOOL isSuccess;

    
    
    NSLog(@"Delete Group Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=delGroupAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
  
    
       NSString *postString =[NSString stringWithFormat:@"&accountID=%@&g_group=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],strDeviceID];
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        //   [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                isSuccess = FALSE;
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                
                
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                isSuccess = TRUE;
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Delete Group Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                
                
                
                
                
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });
    }
    
    //  }];
    
     [hud show:YES];
    
    return isSuccess;

}

-(void)EditGroup:(NSString*)GroupID Name:(NSString*)GroupName{
    
   
    
    
    NSLog(@"Edit Group Name Called !! ");
    
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=editGroupAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&g_group=%@&g_desc=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],GroupID,GroupName];
    
    NSLog(@"poststring -- %@",postString);
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
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
                
                [hud hide:YES];
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                [hud hide:YES];
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Group Updated Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                [self GetGroupList];

            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            
            [self.tableView reloadData];
            
            
        });
        
    }
    
    //  }];
    
    [hud show:YES];
    
    

}


// User Admin


-(void)AddUserOnServer{
    
    UITextField *username = [alertview textFieldAtIndex:0];
    
    
    NSLog(@"AddUserOnServer Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=newUserAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&u_newname=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],username.text];
    
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
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        NSLog(@"--Its error inside  addUserOnServer list ---");
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Upload Data Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                
                [self GetUserList];
                
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });
    }
    
    //  }];
    
    [hud show:YES];
    
}


-(void)GetUserList{
    
    
    NSLog(@"GetUSerList Information Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=viewUserAdmin"];
    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //start the connection
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getUSer list ---");
        
        
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
            
            
            arrMain=[jsonData valueForKey:@"userAdminInfo"];
            
            NSLog(@"arrVehicleData Data %@",[arrMain description]);
            
            if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"false"]) {
                
                isAddDelAllow  = FALSE;
                
            
                
            }
            
            else if ([[jsonData valueForKey:@"add-delete"] isEqualToString:@"true"]) {
                
                isAddDelAllow = TRUE;
            }
            
            
           if ([[jsonData valueForKey:@"edit"] isEqualToString:@"false"]){
              
              isEdit=FALSE;
          }
            
           else if ([[jsonData valueForKey:@"edit"] isEqualToString:@"true"]){
               
               isEdit=TRUE;
           }

        } //if dictionary

    }//main if-else
    
    
    //  }];
    
    [hud show:YES];
    
}


-(BOOL)DeleteUser:(NSString*)strUserID{
    
    BOOL isSuccess;
    
    
    NSLog(@"NSUserDefaults standardUserDefaults == %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"]);
    
    NSLog(@"DeleteData Vehicle Called !! ");
    
    NSString *strURL=[NSString stringWithFormat:@"http://192.168.111.2:7070/OpenGTS/opengts?reqType=delUserAdmin"];
    
  
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    
    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],strUserID];
    
    NSLog(@"Poststring -- >  %@",postString);
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //start the connection
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //           [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    //            { //1
    
    
    if (error) {
        
        [hud hide:YES];
        
        
        UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Show alert here
            [avalert show];
            
        });
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            [hud hide:YES];
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
            }
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                
                
                UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Delete User Successfully !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Show alert here
                    [avalert show];
                    
                });
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [hud hide:YES];
            
            [self.tableView reloadData];
            
            
        });
        
    }
    
    //  }];
    
    [hud show:YES];
    
    return isSuccess;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arrMain count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(isGroupAdmin)
        return 70;
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
      NSString *CellIdentifier = @"";
    if(isVehicleAdmin)
      CellIdentifier = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"deviceID"];
   else if(isGroupAdmin)
       CellIdentifier = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupID"];
    else if(isUserAdmin)
        CellIdentifier = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"userID"];
            
            
//    NSString *CellIdentifier = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"deviceID"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(27, 3, cell.frame.size.width - 35, 21)];
//    lblTitle.backgroundColor = [UIColor lightGrayColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    lblTitle.textColor = [UIColor darkTextColor];
    [cell addSubview:lblTitle];
    
    UILabel *lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(27, lblTitle.frame.size.height + 3, 250, 20)];
//    lblDescription.backgroundColor = [UIColor yellowColor];
    lblDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    
    lblDescription.textColor = [UIColor darkGrayColor];
    
    [cell addSubview:lblDescription];

    
    UILabel *lblSubDetail = [[UILabel alloc]initWithFrame:CGRectMake(27, lblTitle.frame.size.height + lblDescription.frame.size.height + 3, 270, 20)];
    lblSubDetail.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
//    lblSubDetail.backgroundColor = [UIColor redColor];
    lblSubDetail.textColor = [UIColor darkGrayColor];
    [cell addSubview:lblSubDetail];
    
    
    UIImageView *imgvw = [[UIImageView alloc ]initWithFrame:CGRectMake(5, 17, 15, 15)];
    
  //  Helvetica Neue Medium 14.0
    
    if(isVehicleAdmin){
        lblTitle.text= [NSString stringWithFormat:@"%@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"deviceID"] ];
        
       lblDescription.text= [NSString stringWithFormat:@"Desc : %@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"description"]];
        
        lblSubDetail.hidden = YES;
        
        if([[[arrMain objectAtIndex:indexPath.row]valueForKey:@"active"]boolValue ]== YES)
        {
            imgvw.image = [UIImage imageNamed:@"green_icon.png"];
            
        }
        
        else {
            
            imgvw.image = [UIImage imageNamed:@"red_icon.png"];
        }
        [cell addSubview:imgvw];

    }
    else if(isGroupAdmin){
        
        NSLog(@"Group id is - %@--",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupID"]);
        
        imgvw.hidden = YES;
        
        lblTitle.frame =  CGRectMake(20, 3, cell.frame.size.width - 35, 21);
        
        lblDescription.frame =CGRectMake(20, lblTitle.frame.size.height + 3, 200, 20);
//        
        lblSubDetail.frame = CGRectMake(20, lblTitle.frame.size.height + lblDescription.frame.size.height + 3, 270, 20);
        
       
      lblTitle.text= [NSString stringWithFormat:@"%@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupID"]];
 
        
        if([[[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupName"] isEqual:[NSNull null]]){
            
             lblDescription.text = @"";
        }
        
        else {
            
            lblDescription.text = [NSString stringWithFormat:@"Name : %@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupName"] ];
  
        }
        
        lblSubDetail.text  = [NSString stringWithFormat:@"Vehicle Count : %@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"vehicleCnt"] ];
        
    }
    else if(isUserAdmin){
//        lblTitle.text= [[arrMain objectAtIndex:indexPath.row]valueForKey:@"userID"];
        
      
        
        lblSubDetail.hidden = YES;
        
        lblTitle.text=[NSString stringWithFormat:@"%@", [[arrMain objectAtIndex:indexPath.row]valueForKey:@"userID"]];
        
        
        lblDescription.text= [NSString stringWithFormat:@"Desc : %@",[[arrMain objectAtIndex:indexPath.row]valueForKey:@"a_desc"]];
        
        if([[[arrMain objectAtIndex:indexPath.row]valueForKey:@"active"]boolValue ]== YES)
        {
              imgvw.image = [UIImage imageNamed:@"green_icon.png"];
            
        }
        
        else {
            
              imgvw.image = [UIImage imageNamed:@"red_icon.png"];
        }
        
        [cell addSubview:imgvw];
    
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    if(isVehicleAdmin){
        
        
//        [self performSegueWithIdentifier:@"DetailVC" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];

        GPSVehInfoDEtailVC *destinationVC = (GPSVehInfoDEtailVC*)[storyboard instantiateViewControllerWithIdentifier:@"VehicleAdminDetail"];
       
        destinationVC.strVehicleID = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"deviceID"];
        destinationVC.isEditable = isEdit;
       // [destinationVC PullData];


        [self.navigationController pushViewController:destinationVC animated:YES];
        
    }
    
    else if(isGroupAdmin){
        
        [self DisplayAlertViewForEdit];
        
        [dicGroupEdit setValue:[[arrMain objectAtIndex:indexPath.row] valueForKey:@"groupID"] forKey:@"groupid"];
        
        [dicGroupEdit setValue:[[arrMain objectAtIndex:indexPath.row] valueForKey:@"groupName"] forKey:@"groupdesc"];
        
//        [self EditGroup:[[arrMain objectAtIndex:0] valueForKey:@""] Name:[[arrMain objectAtIndex:0] valueForKey:@""]];
        
        
    }
//     [self performSegueWithIdentifier:@"DetailVC" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    
    else if(isUserAdmin)
    {
//        [self performSegueWithIdentifier:@"DetailVC" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        
        GPSUserAdminEditVC *destinationVC = (GPSUserAdminEditVC*)[storyboard instantiateViewControllerWithIdentifier:@"UserAdminDetail"];
        
        
        destinationVC.strVehicleID = [[arrMain objectAtIndex:indexPath.row]valueForKey:@"userID"];
        destinationVC.isEditable = isEdit;

        
       // [destinationVC PullData];
        
        
        [self.navigationController pushViewController:destinationVC animated:YES];
    
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        // Delete the row from the data source
        
       if(isAddDelAllow) {
            
            BOOL isSuccess;
        
            if(isVehicleAdmin){
               isSuccess = [self DeleteVehicle:[[arrMain objectAtIndex:indexPath.row]valueForKey:@"deviceID"]];
            }
            else if(isGroupAdmin){
               isSuccess=[self DeleteGroup:[[arrMain objectAtIndex:indexPath.row]valueForKey:@"groupID"]];
            }
            else if(isUserAdmin){
                isSuccess=[self DeleteUser:[[arrMain objectAtIndex:indexPath.row]valueForKey:@"userID"]];
            }
        
        
        if(isSuccess){
        
            [arrMain removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        [tableView reloadData];

        
        }
        
        else{
            
            UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You don't have permission to delete record!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [avalert show];
            
        }
    

        
    }
    
    
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"DetailVC"]){
        
        GPSVehInfoDEtailVC *destinationVC = (GPSVehInfoDEtailVC*)segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSString *text = cell.textLabel.text;
        destinationVC.strVehicleID = text;
        
        [destinationVC PullData];
        
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [alertview dismissWithClickedButtonIndex:alertview.firstOtherButtonIndex animated:YES];
    
    return YES;
}


@end
