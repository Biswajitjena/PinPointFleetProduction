//
//  GPSGroupDetailVC.m
//  PinPoint
//
//  Created by Guest User on 28/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSGroupDetailVC.h"

#import "MBProgressHUD.h"
#import "GPSAppDelegate.h"

@interface GPSGroupDetailVC (){
   
    MBProgressHUD *hud;
    
    NSString *strAlertString;
    
    GPSAppDelegate *objDelegate;

}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@property (nonatomic,retain)NSMutableArray *arrVehicleList,*arrSelectedDevice;

@property(nonatomic,retain)NSArray *Checkeditems;

@end


@implementation GPSGroupDetailVC

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
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.0/256.0 green:98.0/256.0 blue:153.0/256.0 alpha:1]];
    
    if(self.isAdd)
    {
        
        self.navigationItem.title = @"Add Group";
        
    }
    else {
        
        self.navigationItem.title = @"Group Detail";
        
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Palatino" size:18]}];
    
    UIBarButtonItem *Savebutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save:)];
    
    Savebutton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = Savebutton;
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    
    btnBack.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = btnBack;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 170, self.view.frame.size.width-50, self.view.frame.size.height-250) style:UITableViewStylePlain];
            [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.opaque = NO;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor lightGrayColor];
            tableView.separatorInset = UIEdgeInsetsZero;
            tableView.scrollEnabled = YES;
            tableView.scrollsToTop = YES;
            tableView.bounces = NO;
            tableView.layer.borderWidth = 1.0;
            tableView.layer.cornerRadius = 3.0;
            tableView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
            tableView;
        });
    }
    
    else {
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 170, 290, self.view.frame.size.height-180) style:UITableViewStylePlain];
            [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.opaque = NO;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            tableView.separatorColor = [UIColor lightGrayColor];
            
            tableView.separatorInset = UIEdgeInsetsZero;
            tableView.scrollEnabled = YES;
            tableView.scrollsToTop = YES;
            tableView.bounces = NO;
            tableView.layer.borderWidth = 1.0;
            tableView.layer.cornerRadius = 3.0;
            tableView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
            tableView;
        });
        
        
    }

    [self.view addSubview:self.tableView];
    
    self.arrGroupList = [[NSMutableArray alloc]init];
    
    self.arrSelectedDevice = [[NSMutableArray alloc]init];
    
    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
    
    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
    }
    [hud setLabelText:@"Loading Data..."];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [self.view addSubview:hud];
    
    [self getDeviceList];
    
    if(!self.isAdd){
        
        [self CheckNetworkAvailability];
        
    }
}

-(void)Back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Save:(id)sender{
    
    if([objDelegate isNetworkAvailable]) {
        
        for (UIView *subview in [self.view subviews]) {
            if ([subview isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subview;
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSLog(@"Trim string -->%@.",textField.text);
                
            }
        }
        
        if(self.txtGroupName.text.length >0)
        
            [self UploadData];
        
        else
        {
     
            
              strAlertString = @"Enter Group Name";
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        }
        
        
    }
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
}


-(void)CheckNetworkAvailability{
    
    if ([objDelegate isNetworkAvailable]) {
        
     //[hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        [self DisplayData];
        
        
    }
    
    else{
        
        strAlertString = @"Please try again later";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
    }
    
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
                 
                 
                self.arrVehicleList =[jsonData valueForKey:@"vehicleData"];
                     
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                 
             }
             
         }
         
     }];
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
}


-(void)DisplayData{
    
    self.arrGroupList = [objDelegate.arrSelectedGroupData mutableCopy];
    
    NSLog(@"data -- %@ && objdelegate array -- %@",[self.arrGroupList description],[objDelegate.arrSelectedGroupData description]);
    
    self.txtGroupName.text = [objDelegate.arrSelectedGroupData valueForKey:@"groupName"];
    
    NSString *strTemp = [objDelegate.arrSelectedGroupData valueForKey:@"devicelist"] ;
    
      NSLog(@"arrgroup list value -- %@ and strtemp value -- %@",[self.arrGroupList description],strTemp);
    
    self.arrSelectedDevice = [[strTemp componentsSeparatedByString:@","] mutableCopy];
    
    NSLog(@"self.Checkeditems group %@",[self.arrSelectedDevice description]);
}

-(void)UploadData{
    
    NSString *strURL,*postString;
    
    
    NSLog(@"self.arrSelectedDevice %@",[self.arrSelectedDevice description]);
    
    NSString *strSelectedDevice = [self.arrSelectedDevice componentsJoinedByString:@","];
    
    if(self.isAdd){
        
        strURL =[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=newGroupAdmin",LiveURL];
        
        postString =[NSString stringWithFormat:@"&accountID=%@&g_newname=%@&deviceIdlist=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"account_id"],self.txtGroupName.text,strSelectedDevice];
        
    }
    
    else{
        
        strURL =[NSString stringWithFormat:@"%@/PinPointFleet/opengts?reqType=editGroupAdmin",LiveURL];
        
        postString =[NSString stringWithFormat:@"&groupid=%@&groupname=%@&devicelist=%@",[objDelegate.arrSelectedGroupData valueForKey:@"groupID"],self.txtGroupName.text,strSelectedDevice];
    }
    
    NSLog(@"isAdd -> %hhd && strRL -> %@ && postString --> %@",self.isAdd,strURL,postString);
    
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
    
    
    //start the connection
    
    //    NSError *error = nil;
    //    NSURLResponse *response = nil;
    //
    //    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     { //1
         [hud performSelectorOnMainThread:@selector(hide:) withObject:nil waitUntilDone:NO];

         if (error) {
             
             
             strAlertString = @"Please try again later";
             
             [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
             
             
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
    
    [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
    
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


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
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
    NSString *cellIdentifier =[NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    
    cell.textLabel.textColor =[UIColor darkTextColor];
    cell.textLabel.font=[UIFont fontWithName:@"Palatino" size:12];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@", [[self.arrVehicleList objectAtIndex:indexPath.row ]valueForKey:@"device_name"]];
    
    [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"deviceID"]];
    
    
    NSLog(@"self.Checkeditems--> %@ and self.arrVehicleList -- > %@",[self.arrSelectedDevice description],[self.arrVehicleList description]);
        if([self.arrSelectedDevice containsObject:[[self.arrVehicleList objectAtIndex:indexPath.row]valueForKey:@"id"]]){
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    
        else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
    
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    BOOL isequal = YES;
//    
//    if(textField==self.txtGroupName ){
//        
//        
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789 "] invertedSet];
//        
//        //        NSCharacterSet *invalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
//        
//        //        invalidCharSet = [[NSCharacterSet alphanumericCharacterSet]invertedSet];
//        
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
//        isequal =  [string isEqualToString:filtered];
//    }
//    
//    return isequal;
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

@end
