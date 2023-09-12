
//  SMRightMenuVC.m
//  SlideMenu
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSRightMenuVC.h"
#import "MBProgressHUD.h"
#import "GPSMapVC.h"
#import "GPSAppDelegate.h"

//#import "CustomTableViewCell.h"


@interface GPSRightMenuVC (){
    
    UILabel *lblCellTitle;
    
    MBProgressHUD *hud;
    NSString *strAlertString;
    GPSAppDelegate *objDelegate;
    
    UIRefreshControl *refreshControl;
    
    NSDateFormatter *df;
    
    UIImageView *imgvw;
    
    NSArray *arrGroupList;

}

@property(strong,nonatomic) NSArray *titles;
@property (strong, readwrite, nonatomic) UITableView *tableView;

@property(nonatomic,retain)UILabel *lblTitle,*lblSubTitle,*lblImage;
@property(nonatomic,retain)UIImageView *imgview;


@end

@implementation GPSRightMenuVC

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

    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
        tableView.autoresizingMask =UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor lightTextColor];
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.scrollEnabled = YES;
        tableView.scrollsToTop = YES;
        tableView.bounces = YES;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:98.0/255.0 blue:153.0/255.0 alpha:1];
    
    
//    topItems = [[NSMutableArray alloc]init];
//    
//    subItems = [[NSMutableArray alloc]init];
    
    currentExpandedIndex = -1;
    
  //  NSLog(@"Subarray : %@",[subItems description]);
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self CheckNetworkAvailability];
    
    refreshControl = [[UIRefreshControl alloc] init];
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(CheckNetworkAvailability) forControlEvents:UIControlEventValueChanged];
    // Configure View Controller
    
    refreshControl.tintColor = [UIColor whiteColor];
    
    [self.tableView addSubview:refreshControl];
    
    [self.tableView reloadData];
    
    df =[[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    arrDeviceId = [[NSMutableArray alloc]init];
    
//    hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
//    
//    if ([[UIView appearance] respondsToSelector:@selector(setTintColor:)]) {
//        [[UIView appearance] setTintColor:[UIColor lightTextColor]];
//    }
//    [hud setLabelText:@"Loading Data..."];
//    [hud setMode:MBProgressHUDModeIndeterminate];
//    [hud setAnimationType:MBProgressHUDAnimationFade];
//    [self.view addSubview:hud];
    
    
  //  [self getData];
    
    arrGroupList = [[NSArray alloc]init];
}

//    -(void)getData{
//
//    NSError *error = nil;
//
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"response" ofType:@"json"]];
//
//    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSDictionary * jsonData=[[NSDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil] ];
//    NSLog(@"Return Data %@",[jsonData description]);
//
//    self.arrayOriginal=[jsonData valueForKey:@"List"];
//
//    self.arForTable=[[NSMutableArray alloc] init];
//    [self.arForTable addObjectsFromArray:self.arrayOriginal];
//
//    NSLog(@"self.arr %@",[self.arForTable description]);
//
//    }

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)CheckNetworkAvailability {
    
    objDelegate = [[UIApplication sharedApplication]delegate];

    NSLog(@"identifier is --> %@",objDelegate.strId);
    
    if ([objDelegate isNetworkAvailable]) {
        
//        [hud performSelectorOnMainThread:@selector(show:) withObject:nil waitUntilDone:YES];
        
        [self GetVehicleList];
        
        [refreshControl endRefreshing];
        
        [self.tableView reloadData];

        
    }
    else{
        
        strAlertString = @"No network available. Please try again later.";
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:strAlertString waitUntilDone:NO];
        
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
             //NSLog(@"Response:%@",responseBody);
             NSDictionary *jsonData       = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
             NSLog(@"Return Data Classtype -- %@",[jsonData class]);
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
                    //NSLog(@"arr original Count --> %d",[self.arrayOriginal count]);
                    objDelegate.arrDeviceIDName = [[NSMutableArray alloc]init];
                    NSLog(@"get vehicle List ");
                    
                    self.arForTable=[[NSMutableArray alloc] init];
                    
                    //===================== 22 March 2018
                    NSMutableArray* result = [[NSMutableArray alloc] init];
                    for(int i = 0 ; i < self.arrayOriginal.count ; i++){
                        NSMutableArray *groupArray = [[self.arrayOriginal objectAtIndex:i]valueForKey:@"List"];
                        NSLog(@"Group Array:%@",[groupArray description]);
                        NSMutableDictionary *level0 = [[NSMutableDictionary alloc] init];
                        [level0 setValue:[[self.arrayOriginal objectAtIndex:i] objectForKey:@"level"] forKey:@"level"];
                        [level0 setValue:[[self.arrayOriginal objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
                        NSLog(@"level0 Dictionary:%@",level0);
                        NSMutableArray *deviceListForGroup = [[NSMutableArray alloc] init];
                        for(int j = 0 ; j < groupArray.count ; j++){
                            NSString *groupName = [[groupArray objectAtIndex:j]valueForKey:@"name"];
                            NSString *groupLevel = [[groupArray objectAtIndex:j]valueForKey:@"level"];
                            NSMutableArray *deviceArray = [[groupArray objectAtIndex:j]valueForKey:@"List"];
                            NSLog(@"Device Array:%@",[deviceArray description]);
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
                             
                                NSMutableArray *arrNewDic = [dicID objectForKey:@"List"];
                               // NSLog(@"arr NewDic --> %@",[arrNewDic description]);
                                //NSLog(@"arr NewDic count --> %d",[arrNewDic count]);
  
                                
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
                     
//                    NSLog(@"arr DeviceIDANme --> %@",[objDelegate.arrDeviceIDName description]);
//                    NSLog(@"arr DeviceIDANme count --> %d",[objDelegate.arrDeviceIDName count]);
                    NSLog(@"arrDeviceID count --> %lu \n description -->%@ ",(unsigned long)[objDelegate.arrDeviceID count],[objDelegate.arrDeviceID description]);
 
                     
                     objDelegate.arrVehicleList = [self.arrayOriginal mutableCopy];
                     
                     strId = [[NSString alloc]init];
                     
                     strId= [objDelegate.arrDeviceID componentsJoinedByString:@","];
                     
                     [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                     NSDictionary *dic = @{@"Id":strId};
                     //NSLog(@"Dictionary:%@",dic);
                    
                    objDelegate.dicVehSetting = [dic mutableCopy];
                    
                    //NSLog(@"strid count --> %lu && objDelegate.arrDeviceID count --> %lu",(unsigned long)[[strId componentsSeparatedByString:@","]count],(unsigned long)[objDelegate.arrDeviceID count]);
                     

                     objDelegate.isLoadAllData = FALSE;
                    
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMapForFirstTime" object:nil userInfo:dic];
                  
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



#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
//    return [topItems count] + ((currentExpandedIndex > -1) ? [[subItems objectAtIndex:currentExpandedIndex] count] : 0);
    
    return [self.arForTable count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.textColor=[UIColor whiteColor];
    [lblTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    lblTitle.highlightedTextColor = [UIColor lightTextColor];
    lblTitle.text = self.titles[indexPath.row];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.backgroundColor = [UIColor clearColor ];
    [cell addSubview:lblTitle];
	
    
    imgvw = [[UIImageView alloc]init];
    [imgvw setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    UIButton *btnMap = [[UIButton alloc]init];
//    btnMap.backgroundColor = [UIColor yellowColor];
    
    [btnMap setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];

    [btnMap addTarget:self action:@selector(LoadGroup:) forControlEvents:UIControlEventTouchDown];
    btnMap.tag = indexPath.row;
    
    [btnMap setBackgroundImage:[UIImage imageNamed:@"map-icon@2x.png"] forState:UIControlStateNormal];
    [btnMap setTintColor:[UIColor whiteColor]];
//    btnMap.imageView.image = [UIImage imageNamed:@"map-icon@2x.png"];
    
    

    int level =[[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue];
    
    switch (level) {
            
        case 0:{
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
                
            {
                //        lblTitle.font=[UIFont fontWithName:@"HelveticaNeue-bold" size:25];
                lblTitle.font=[UIFont fontWithName:@"Palatino-bold" size:18];
                
                lblTitle.frame = CGRectMake(150, 5, self.view.frame.size.width-140, 30);
                
                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                
                lblTitle.textColor = [UIColor whiteColor];
                
                imgvw.frame = CGRectMake(137, 17, 7, 2);
                imgvw.image =[UIImage imageNamed:@"highfin-5.png"];
                [cell addSubview:imgvw];
                
                
                
            }
            
            else {
                
                lblTitle.font=[UIFont fontWithName:@"Palatino-bold" size:16];
                
                lblTitle.frame = CGRectMake(120, 5, self.view.frame.size.width-100, 30);
                
                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                
                lblTitle.textColor = [UIColor whiteColor];
                
                imgvw.frame = CGRectMake(107, 17, 5, 2);
                imgvw.image =[UIImage imageNamed:@"highfin-5.png"];
                [cell addSubview:imgvw];
                
                
            }

           
            break;
        
        }
        case 1:{
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
                
            {
                
                
                lblTitle.font=[UIFont fontWithName:@"Palatino-bold" size:17];
                
                lblTitle.frame = CGRectMake(170, 5, self.view.frame.size.width-170, 30);
                
//                lblTitle.frame = CGRectMake(170, 5, 100, 30);
                
//                lblTitle.backgroundColor = [UIColor redColor];

                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                if([[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"deviceID"] != NULL){
                    
                    lblTitle.textColor = [UIColor whiteColor];
                    
                    lblTitle.font=[UIFont fontWithName:@"Palatino" size:15];
                    
                }
                
                else {
                    
                    imgvw.frame = CGRectMake(157, 17, 5, 2);
                    imgvw.image =[UIImage imageNamed:@"highfin-5.png"];
                    [cell addSubview:imgvw];
                    
                    
                    btnMap.frame = CGRectMake(285, 6, 27, 27);
                    [cell.contentView addSubview:btnMap];
                    
                    lblTitle.textColor = [UIColor orangeColor];
                }
            }
            
            else{
                
                // iphone
                
                lblTitle.font=[UIFont fontWithName:@"Palatino-bold" size:16];
                
//                lblTitle.frame = CGRectMake(130, 5, self.view.frame.size.width-120, 30);
                
                lblTitle.frame = CGRectMake(130, 5, 160, 30);

                 lblTitle.backgroundColor = [UIColor clearColor];
                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                
                if([[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"deviceID"] != NULL){
                    
                    lblTitle.textColor = [UIColor whiteColor];
                    
                    lblTitle.font=[UIFont fontWithName:@"Palatino" size:15];
                    
                }
                
                else {
                    
                    imgvw.frame = CGRectMake(117, 17, 5, 2);
                    imgvw.image =[UIImage imageNamed:@"highfin-5.png"];
                    
                    [cell addSubview:imgvw];
                    
                    btnMap.frame = CGRectMake(290, 6, 27, 27);

                    [cell.contentView addSubview:btnMap];
                    
                    lblTitle.textColor = [UIColor orangeColor];
                }
                
            }
            

            break;
        }
            
        case 2:{
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
                
            {
                
                lblTitle.font=[UIFont fontWithName:@"Palatino" size:16];
                
                lblTitle.frame = CGRectMake(190, 5, self.view.frame.size.width-190, 30);
                
                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                
                lblTitle.textColor = [UIColor whiteColor];

            }
            
            else {
                
                lblTitle.font=[UIFont fontWithName:@"Palatino" size:15];
                
                lblTitle.frame = CGRectMake(150, 5, self.view.frame.size.width-140, 30);
                
                lblTitle.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
                
                lblTitle.textColor = [UIColor whiteColor];
             

            }
            
           
            break;
        }

        default:
            break;
    }
    
//    cell.lblAssignment.text=[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
	[cell setIndentationLevel:[[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
	
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"device id is --> %@",[[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"]);
    objDelegate.isperiodNotSelected = TRUE;
    
    
//    int level =[[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue];
//
//    NSLog(@"Selected level ---> %d", level);
//    
//    NSLog(@"selected item description --> %@",[[self.arForTable objectAtIndex:indexPath.row]description]);
    
    
	NSDictionary *d=[self.arForTable objectAtIndex:indexPath.row];
    
	if([d valueForKey:@"List"]) {
        

//        if(level == 1){
//            
////          NSArray * arrGroup = [self.arForTable objectAtIndex:indexPath.row];
//            
//            NSArray *arrGroup = [d valueForKey:@"List"];
//
//            [self LoadGroup:arrGroup];
//            
//        }
		NSArray *ar=[d valueForKey:@"List"];
		
		BOOL isAlreadyInserted=NO;
		
		for(NSDictionary *dInner in ar ){
			NSInteger index=[self.arForTable indexOfObjectIdenticalTo:dInner];
			isAlreadyInserted=(index>0 && index!=NSIntegerMax);
			if(isAlreadyInserted) break;
		}
		
		if(isAlreadyInserted) {
            
            NSLog(@"isAlreadyInserted clicked %@",[[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"]);

			[self miniMizeThisRows:ar];
            
		}
        else {
            
            NSLog(@"else clicked %@",[[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"]);

			NSUInteger count=indexPath.row+1;
			NSMutableArray *arCells=[NSMutableArray array];
			for(NSDictionary *dInner in ar ) {
				[arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
				[self.arForTable insertObject:dInner atIndex:count++];
			}
			[tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationAutomatic];

		}
	}
    
    if([[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"] != NULL){
        
        objDelegate.isLoadAllData = FALSE;
        //objDelegate.isperiodNotSelected = TRUE;
        objDelegate.isFromRightSideMenu = TRUE;
        
        objDelegate.strRightSubMenuVehId =[[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"];
        
        NSDictionary *dic = @{@"Fr_Dt":[df stringFromDate:[NSDate date]],@"To_Dt":[df stringFromDate:[NSDate date]],@"VehID":[[self.arForTable objectAtIndex:indexPath.row]valueForKey:@"deviceID"]};
        
        NSLog(@"userinfo %@",[dic description]);
        
        objDelegate.dicVehSetting = [dic mutableCopy];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMapForCurrentDate" object:nil userInfo:dic];
        
        [self.sideMenuViewController hideMenuViewController];

    }
    
}

-(void)miniMizeThisRows:(NSArray*)ar{
        
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.arForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"List"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.arForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.arForTable removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
		}
	}
}

-(void)LoadGroup:(id)sender{
    
    
    UIButton *btn = (UIButton *) sender;
    
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
      NSMutableArray *arrDevice = [[NSMutableArray alloc]init];
    NSMutableArray *arrDeviceName = [[NSMutableArray alloc]init];

    
////    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//    NSMutableArray *arrDevice = [[NSMutableArray alloc]init];
//    
////    NSDictionary *d=[self.arForTable objectAtIndex:indexPath.row];
//    
//    NSArray *arrTmp =[self.arForTable objectAtIndex:indexPath.row];
//
//    NSDictionary *d = [[arrTmp objectAtIndex:indexPath.row ] valueForKey:@"List"];
//
//    NSArray *arrGroup = [d valueForKey:@"List"];
//
//        for (NSDictionary *dicID in arrGroup) {
//            
//                    NSString *strID = [dicID valueForKey:@"deviceID"];
//                    [arrDevice addObject:strID];
//        }
    
    int level =[[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue];
    
    NSLog(@"Selected level ---> %d", level);
    
	NSDictionary *d=[self.arForTable objectAtIndex:indexPath.row];
    
	if([d valueForKey:@"List"]) {
        
        if(level == 1){

            NSArray *arrGroup = [d valueForKey:@"List"];

            NSLog(@"arrgroup description --> %@",[arrGroup description]);
            objDelegate.arrDeviceID = [[NSMutableArray alloc]init];
            for (NSDictionary *dicID in arrGroup) {

                        NSString *strID = [dicID valueForKey:@"deviceID"];
                        [arrDevice addObject:strID];
                        [arrDeviceName addObject:[dicID valueForKey:@"name"]];
                    [objDelegate.arrDeviceID addObject:([dicID valueForKey:@"deviceID"])];
                
                
                
            }
            NSLog(@"OBJ:%@",[objDelegate.arrDeviceID description]);
        }
    }
    
    
  NSString *  TempstrId = [[NSString alloc]init];
    
    TempstrId= [arrDevice componentsJoinedByString:@","];
    
    
    NSDictionary *dic = @{@"Id":TempstrId};
    
    objDelegate.dicVehSetting = [dic mutableCopy];
   
    
    NSLog(@"strid count --> %lu && arrDevice count --> %lu",(unsigned long)[[TempstrId componentsSeparatedByString:@","]count],(unsigned long)[arrDevice count]);
    
                    NSLog(@"userinfo in menu --> %@",[dic description]);
    
    objDelegate.isLoadAllData = FALSE;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadMapForFirstTime" object:nil userInfo:dic];

    [self.sideMenuViewController hideMenuViewController];

}

- (void)expandItemAtIndex:(int)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.imgview.image = [UIImage imageNamed:@"down-arrow.png"];
    
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [subItems objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)collapseSubItemsAtIndex:(int)index {
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForItem:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.imgview.image = [UIImage imageNamed:@"down-arrow.png"];
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
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
