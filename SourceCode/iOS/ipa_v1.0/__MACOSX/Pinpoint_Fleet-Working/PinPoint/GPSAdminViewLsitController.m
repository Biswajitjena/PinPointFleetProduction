//
//  GPSAdminViewLsitController.m
//  PinPoint
//
//  Created by Sandip Rudani on 24/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSAdminViewLsitController.h"
#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"
#import "GPSVehDetailVC.h"
#import "GPSUserDetailVC.h"
#import "GPSGroupDetailVC.h"
#import "GPSUserRoleVC.h"

@interface GPSAdminViewLsitController ()

{
    MBProgressHUD *hud;
    
    NSString *strAlertString;
    
    GPSAppDelegate *objDelegate;
    
    BOOL isVehicleAdmin,isGroupAdmin,isUserAdmin,isUserRole;

}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@property(strong,nonatomic) GPSVehDetailVC *objAddEditVehView;

@property(strong,nonatomic) GPSUserDetailVC *objAddEditUserView;

@property(strong,nonatomic)GPSGroupDetailVC *objAddEditGroupView;
@property(strong,nonatomic)GPSUserRoleVC *objAddEditUserRole;

@property(nonatomic,retain) UILabel *lblCellTitle,*lblDetailSubview1,*lbl_img;


@end

@implementation GPSAdminViewLsitController

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
    
    
    objDelegate = [[UIApplication sharedApplication]delegate];
    
    self.navigationController.navigationBarHidden = FALSE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1]];
    
    self.navigationItem.title = @"List View";
    
    if ([objDelegate.strId isEqualToString:@"View Vehicle Admin List"]) {
        
        self.navigationItem.title = @"Vehicle List";


    }
    
    if([objDelegate.strId isEqualToString:@"View User Admin List"])
    {
    
        self.navigationItem.title = @"User List";

    }
    
    if([objDelegate.strId isEqualToString:@"View Group Admin List"]){
        

        self.navigationItem.title = @"Group List";

    }
    
    if([objDelegate.strId isEqualToString:@"View User Roles"]){
    

        self.navigationItem.title = @"User Role List";

        
    }
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino-bold" size:22]}];
        
    }
    
    else {
        
        
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
        
        
    }
    UIBarButtonItem *AddButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(DisplayAddView)];
    
    AddButton.enabled = TRUE;
    
    AddButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = AddButton;
    
    self.tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
         [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        tableView.separatorColor = [UIColor grayColor];
        
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.scrollEnabled = YES;
        //        tableView.scrollsToTop = YES;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    
    self.arrVehicleList = [[NSMutableArray alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    
//    [self CheckNetworkAvailability];
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    [self CheckNetworkAvailability];
    
    [self.tableView reloadData];
    
}
-(void)DisplayAddView{
    
    NSLog(@"Push to add view");
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
   if (isVehicleAdmin) {
    
        self.objAddEditVehView = (GPSVehDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditVehicle"];
    
        self.objAddEditVehView.isAdd =YES;
    
        [self.navigationController pushViewController:self.objAddEditVehView animated:YES];
    }
    
    if(isUserAdmin){
        
        self.objAddEditUserView = (GPSUserDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditUser"];
        
        self.objAddEditUserView.isAdd = YES;
        
        [self.navigationController pushViewController:self.objAddEditUserView animated:YES];
        
    }
    
    if(isGroupAdmin){
        
        self.objAddEditGroupView = (GPSGroupDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditGroup"];
        
        self.objAddEditGroupView.isAdd = YES;
        
        [self.navigationController pushViewController:self.objAddEditGroupView animated:YES];
        
    }
    
    if(isUserRole){
        
        self.objAddEditUserRole = (GPSUserRoleVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditUserRole"];
        
        self.objAddEditUserRole.isAdd = YES;
        
        [self.navigationController pushViewController:self.objAddEditUserRole animated:YES];
        
    }
    
}

-(void)CheckNetworkAvailability {

    
    NSLog(@"identifier is --> %@",objDelegate.strId);
    
    if ([objDelegate isNetworkAvailable]) {
        
//        [hud show:YES];

        
        if([objDelegate.strId isEqualToString:@"View Vehicle Admin List"]){
            
            self.navigationController.title = @"Vehicle List";
            
            isVehicleAdmin = YES;
            
             NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=vehicleDetails",LiveURL];
            
            NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];

            
            [self GetList:strURL PostString:postString];

        }
        
        if([objDelegate.strId isEqualToString:@"View Group Admin List"]){
            
            self.navigationController.title = @"Group List";

            
            isGroupAdmin = YES;
            
            NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=viewGroupAdmin",LiveURL];
            
            NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
            
            
            [self GetList:strURL PostString:postString];
            
        }
        
        if([objDelegate.strId isEqualToString:@"View User Admin List"]){
            
            self.navigationController.title = @"User List";

            
            isUserAdmin = YES;
            
            NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=viewUserAdmin",LiveURL];
            
            NSString *postString =[NSString stringWithFormat:@"&accountID=%@&username=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]];
            
            [self GetList:strURL PostString:postString];
            
        }
        
        if([objDelegate.strId isEqualToString:@"View User Roles"]){
            
            self.navigationController.title = @"Role List";

            
            isUserRole = YES;
//            http://192.168.111.2:7070/PinPointFleet/opengts?reqType=getroleslist&accountID=226825
            NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=getroleslist",LiveURL];
            
            NSString *postString =[NSString stringWithFormat:@"&accountID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"]];
            
            [self GetList:strURL PostString:postString];
            
        }
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
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
             
             strAlertString = @"Please try again later";
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
             
         }
         
         else { //1
             
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
             NSLog(@"Return Data %@",[jsonData description]);
             
          
             
             if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
                 
                 
                 
                 if (isVehicleAdmin) {
                     self.arrVehicleList =[jsonData valueForKey:@"vehicleData"];
                                      }
                 
                 else if(isUserAdmin){
                     
                     self.arrVehicleList =[jsonData valueForKey:@"userAdminInfo"];

                 }
                 
                 else if(isGroupAdmin){
                     
                     self.arrVehicleList =[jsonData valueForKey:@"groupAdminInfo"];

                 }
                 else if(isUserRole){
                     
                     self.arrVehicleList =[jsonData valueForKey:@"RoleList"];
                     
                 }
                 
                 
                 NSLog(@"Vehicle Array %@",[self.arrVehicleList description]);
                 [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                 
             }
             
         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
}


-(void)showAlert:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}


-(BOOL)deleteID:(NSString*)strIdentifier{
    
    NSLog(@"strid delet %@",strIdentifier);
    
    BOOL isSuccess = NO;

    if([objDelegate.strId isEqualToString:@"View Vehicle Admin List"]){
        
        isVehicleAdmin = YES;
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=deleteVehicle",LiveURL];
        
        NSString *postString =[NSString stringWithFormat:@"&id=%@",strIdentifier];
        
        
        isSuccess =  [self DeleteItem:strURL PostString:postString];
        
    }
    
    if([objDelegate.strId isEqualToString:@"View Group Admin List"]){
        
        isGroupAdmin = YES;
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=delGroupAdmin",LiveURL];
        
        NSString *postString =[NSString stringWithFormat:@"&accountID=%@&groupid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],strIdentifier];
        
        
        isSuccess =  [self DeleteItem:strURL PostString:postString];
        
    }
    
    if([objDelegate.strId isEqualToString:@"View User Admin List"]){
        
        isUserAdmin = YES;
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=delUserAdmin",LiveURL];
        
        NSString *postString =[NSString stringWithFormat:@"&accountID=%@&userID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],strIdentifier];

        isSuccess =  [self DeleteItem:strURL PostString:postString];

    }
    
    if([objDelegate.strId isEqualToString:@"View User Roles"]){
        
        isUserRole = YES;
        
        NSString *strURL=[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=deleterole",LiveURL];
        
        NSString *postString =[NSString stringWithFormat:@"&accountID=%@&roleID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],strIdentifier];
        
        isSuccess =  [self DeleteItem:strURL PostString:postString];
        
    }
    
    return isSuccess;
}


-(BOOL)DeleteItem:(NSString*)strURL PostString:(NSString*)postString{
    
    NSLog(@"Delete Item Called strURL -> %@ and PostString -> %@",strURL,postString);
    
    BOOL isSuccess;
    
    NSLog(@"DeleteData Vehicle Called !! ");
    

    
    
    NSURL *aUrl = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:50.0];
    
    //  alternative Request Method
    [request setHTTPMethod:@"POST"];
    
    
//    NSString *postString =[NSString stringWithFormat:@"&accountID=%@&deviceID=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"AccountID"],strDeviceID];
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
    [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

    
    if (error) {
        
        NSLog(@"--Its error inside  getvehicle list ---");
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
        
    }
    else{ //1
        
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: NSJSONReadingMutableContainers
                                                              error: &error];
        NSLog(@"Return Data Classtype -- %@",[jsonData class]);
        NSLog(@"Return Data %@",[jsonData description]);
        
        if ([jsonData isKindOfClass:[NSDictionary class]]) { //1-2
            
            
            if([[jsonData valueForKey:@"success"]isEqualToString:@"false"]){
                
                isSuccess = NO;
                
                strAlertString = @"Please try again later !!";
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
                
            }
            
            
            else if([[jsonData valueForKey:@"success"]isEqualToString:@"true"]){
                
                isSuccess = YES;
                
                strAlertString = @"Data Deleted Successfully !!";
                
                [self performSelectorOnMainThread:@selector(showAlertForSuccessfullyUpdate:) withObject:strAlertString waitUntilDone:NO];
            }
            
            
              [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        }
        
        
    }
    
    //  }];
    
  
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
    return isSuccess;
    
}
    
-(void)showAlertForSuccessfullyUpdate:(NSString*)Title {
    
    NSLog(@"Show AlertView method called !!");
    
    UIAlertView *avalert = [[UIAlertView alloc] initWithTitle:@"Success" message:Title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [avalert show];
    
}
    
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isGroupAdmin)
        return 70;
    
    return 50;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.arrVehicleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //

    NSString *CellIdentifier = @"";
    
    if(isVehicleAdmin)
        CellIdentifier = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"deviceID"];
    else if(isGroupAdmin)
        CellIdentifier = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"groupID"];
    else if(isUserAdmin)
        CellIdentifier = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"username"];
    else if(isUserRole)
        CellIdentifier = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"description"];
    
    UITableViewCell *cell = nil;

    
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    //}
    //
    //    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    //
    self.lblCellTitle=[[UILabel alloc]initWithFrame:CGRectMake(50, 2, 250, 25)];
    self.lblCellTitle.textColor=[UIColor darkTextColor];
    self.lblCellTitle.font=[UIFont fontWithName:@"Palatino" size:15];
    self.lblCellTitle.highlightedTextColor = [UIColor darkTextColor];
 //   lblCellTitle.text = [NSString stringWithFormat:@"Name : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"]];
    self.lblCellTitle.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:self.lblCellTitle];
    [self.lblCellTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    self.lblDetailSubview1=[[UILabel alloc]initWithFrame:CGRectMake(50, 28, 250, 20)];
    self.lblDetailSubview1.textColor=[UIColor darkGrayColor];
    self.lblDetailSubview1.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    self.lblDetailSubview1.highlightedTextColor = [UIColor darkTextColor];
//    lblDetailSubview1.text = [NSString stringWithFormat:@" Description : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"deviceID"]];
    self.lblDetailSubview1.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:self.lblDetailSubview1];
     [self.lblDetailSubview1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    self.lbl_img = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    self.lbl_img.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1];
    self.lbl_img.contentMode = UIViewContentModeCenter;
//    [lbl_img setText:[[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"] substringWithRange:NSMakeRange(0, 1)]];
    self.lbl_img.textAlignment = NSTextAlignmentCenter;
    self.lbl_img.font=[UIFont boldSystemFontOfSize:16];
    self.lbl_img.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:self.lbl_img];
     [self.lbl_img setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];

    if(isGroupAdmin){
        
        self.lbl_img.frame = CGRectMake(10, 20, 30, 30);
        UILabel *lblDetailSubview2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 250, 18)];
        lblDetailSubview2.textColor=[UIColor darkTextColor];
        lblDetailSubview2.font=[UIFont fontWithName:@"Helvetica Neue" size:11];
        lblDetailSubview2.highlightedTextColor = [UIColor darkTextColor];
        lblDetailSubview2.text = [NSString stringWithFormat:@"Device : %@",[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"devicelist"]];
        lblDetailSubview2.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:lblDetailSubview2];
         [lblDetailSubview2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        
        self.lblCellTitle.text = [NSString stringWithFormat:@"Group Name : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"groupName"]];
        
        self.lblDetailSubview1.text = [NSString stringWithFormat:@"Group ID : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"groupID"]];
        
        if([[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"groupName"] length] >0)
            [self.lbl_img setText:[[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"groupName"] substringWithRange:NSMakeRange(0, 1)]];

    }
    
    else if (isUserAdmin){
        
        self.lblCellTitle.text = [NSString stringWithFormat:@"User Name : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"username"]];
        
        self.lblDetailSubview1.text = [NSString stringWithFormat:@"Contact : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"contact_person"]];
        
        if([[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"username"] length] >0)
            [self.lbl_img setText:[[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"username"] substringWithRange:NSMakeRange(0, 1)]];

    }
    
    else if(isVehicleAdmin){
        
        self.lblCellTitle.text = [NSString stringWithFormat:@"Device Name : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"]];
        
        self.lblDetailSubview1.text = [NSString stringWithFormat:@"Device ID : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"deviceID"]];
        
        if([[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"] length] >0)
            [self.lbl_img setText:[[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"] substringWithRange:NSMakeRange(0, 1)]];

    }
    
    else if(isUserRole){
        
        self.lblCellTitle.text = [NSString stringWithFormat:@"Role : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"description"]];
        
        self.lblDetailSubview1.text = [NSString stringWithFormat:@"Role ID : %@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"roleId"]];
        if([[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"description"] length] >0)
            [self.lbl_img setText:[[[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"description"] substringWithRange:NSMakeRange(0, 1)]];
        
    }
    
    return cell;
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
        
            BOOL isSuccess;
            
            if(isVehicleAdmin){
                isSuccess = [self deleteID:[[self.arrVehicleList
                        objectAtIndex:indexPath.row]valueForKey:@"id"]];
                
            }
            else if(isGroupAdmin){
                isSuccess=[self deleteID:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"groupID"]];
            }
            else if(isUserAdmin){
                isSuccess=[self deleteID:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"username"]];
            }
            else if(isUserRole){
                isSuccess=[self deleteID:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"roleId"]];
            }
            
            if(isSuccess){
                
                [self.arrVehicleList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
            [tableView reloadData];
        
    }
    
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    if(isVehicleAdmin) {
    
        self.objAddEditVehView = (GPSVehDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditVehicle"];
        
           [[NSUserDefaults standardUserDefaults]setValue:[[self.arrVehicleList objectAtIndex:indexPath.row] valueForKey:@"Id"] forKey:@"id"];
        
        self.objAddEditVehView.isAdd = NO;
        
        objDelegate.strVehID =[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"id"];

        [self.navigationController pushViewController:self.objAddEditVehView animated:YES];
    }
    
    if(isUserAdmin){
        
        self.objAddEditUserView = (GPSUserDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditUser"];
        
        self.objAddEditUserView.isAdd = NO;
        
        objDelegate.strUserName = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"username"];
        
        [self.navigationController pushViewController:self.objAddEditUserView animated:YES];
        
    }
    
    if(isGroupAdmin){
        
        self.objAddEditGroupView = (GPSGroupDetailVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditGroup"];
        
        self.objAddEditGroupView.isAdd = NO;
        
        objDelegate.arrSelectedGroupData =[self.arrVehicleList objectAtIndex:indexPath.row ];
       
        NSLog(@" self.objAddEditGroupView.arrGroupList Group array -- %@",[ self.objAddEditGroupView.arrGroupList description]);
        
        [self.navigationController pushViewController:self.objAddEditGroupView animated:YES];
        
    }
    
    if(isUserRole){
        
        self.objAddEditUserRole = (GPSUserRoleVC*)[objDelegate.storyboard instantiateViewControllerWithIdentifier:@"AddEditUserRole"];
        
        self.objAddEditUserRole.isAdd = NO;
        
        objDelegate.strroleID = [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"roleId"];
        
        [self.navigationController pushViewController:self.objAddEditUserRole animated:YES];
        
    }
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
