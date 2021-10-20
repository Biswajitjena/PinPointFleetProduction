//
//  SMLeftMenuVC.m
//  SlideMenu
//
//  Created by Sandip Rudani on 21/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSLeftMenuVC.h"
#import "UIViewController+RESideMenu.h"
#import "GPSAdminViewLsitController.h"
#import "GPSAccountAdminVC.h"
#import "GPSAppDelegate.h"
#import "GPSSMSViewController.h"

@interface GPSLeftMenuVC ()
{
    
    GPSAppDelegate *objDelegate;
}
// private instance variable

@property(nonatomic,strong)  NSArray *titles,*images;

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation GPSLeftMenuVC

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
    
    NSLog(@"user defaults description -- %@",[[NSUserDefaults standardUserDefaults]description]);
    
    objDelegate = [[UIApplication sharedApplication]delegate];
// 16/03/2018---Remove left panel Data
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userole"]isEqualToString:@"ROLE_ADMIN"]){
//
//        _titles = @[@"Mapping",@"Map View",@"Send Command",@"Administration",@"Account",@"Vehicle",@"Groups",@"User",@"Roles",@"Log Out"];
//
//        _images = @[@"administration@2x.png",@"mapping@2x.png",@"logout@2x.png"];
//
//
//        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
//        {
//
//            self.tableView = ({
//                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//                tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//                tableView.delegate = self;
//                tableView.dataSource = self;
//                tableView.opaque = NO;
//                tableView.backgroundColor = [UIColor clearColor];
//                tableView.backgroundView = nil;
//                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                //        tableView.separatorInset = UIEdgeInsetsZero;
//                tableView.bounces = NO;
//                tableView.scrollsToTop = YES;
//
//                tableView.scrollEnabled = YES;
//
//                tableView;
//            });
//        }
//
//        else {
//
//            self.tableView = ({
//                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width, 40 *10) style:UITableViewStylePlain];
//                tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//                tableView.delegate = self;
//                tableView.dataSource = self;
//                tableView.opaque = NO;
//                tableView.backgroundColor = [UIColor clearColor];
//                tableView.backgroundView = nil;
//                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                //        tableView.separatorInset = UIEdgeInsetsZero;
//                tableView.bounces = NO;
//                tableView.scrollsToTop = YES;
//
//                tableView.scrollEnabled = YES;
//
//                tableView;
//            });
//
//        }
//
//    }
//
//    else {
//
//        _titles = @[@"Mapping",@"Map View",@"Send Command",@"Log Out"];
//       _images = @[@"mapping@2x.png", @"logout@2x.png"];
//
//
//
//        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
//
//        {
//            //(self.view.frame.size.height - 45 * 5) / 2.0f
//            self.tableView = ({
//                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
//                tableView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//                tableView.delegate = self;
//                tableView.dataSource = self;
//                tableView.opaque = NO;
//                tableView.backgroundColor = [UIColor clearColor];
//                tableView.backgroundView = nil;
//                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                //        tableView.separatorInset = UIEdgeInsetsZero;
//                tableView.bounces = NO;
//                //            tableView.scrollsToTop = NO;
//                tableView;
//            });
//        }
//
//        else {
//
//            self.tableView = ({
//                UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height/2 - 100,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//                tableView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//                tableView.delegate = self;
//                tableView.dataSource = self;
//                tableView.opaque = NO;
//                tableView.backgroundColor = [UIColor clearColor];
//                tableView.backgroundView = nil;
//                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//                //        tableView.separatorInset = UIEdgeInsetsZero;
//                tableView.bounces = NO;
//                //            tableView.scrollsToTop = NO;
//                tableView;
//            });
//        }
//
//
//
//    }

    // 16/03/2018---Remove left panel Data
            _titles = @[@"Mapping",@"Map View",@"Send Command",@"Log Out"];
           _images = @[@"mapping@2x.png", @"logout@2x.png"];
    
    
    
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    
            {
                //(self.view.frame.size.height - 45 * 5) / 2.0f
                self.tableView = ({
                    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
                    tableView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                    tableView.delegate = self;
                    tableView.dataSource = self;
                    tableView.opaque = NO;
                    tableView.backgroundColor = [UIColor clearColor];
                    tableView.backgroundView = nil;
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    //        tableView.separatorInset = UIEdgeInsetsZero;
                    tableView.bounces = NO;
                    //            tableView.scrollsToTop = NO;
                    tableView;
                });
            }
    
            else {
    
                self.tableView = ({
                    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height/2 - 100,self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
                    tableView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
                    tableView.delegate = self;
                    tableView.dataSource = self;
                    tableView.opaque = NO;
                    tableView.backgroundColor = [UIColor clearColor];
                    tableView.backgroundView = nil;
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    //        tableView.separatorInset = UIEdgeInsetsZero;
                    tableView.bounces = NO;
                    //            tableView.scrollsToTop = NO;
                    tableView;
                });
            }
    NSLog(@"self.view frame size --> %f && %f",self.view.frame.size.width,self.view.frame.size.height);
    
    NSLog(@"tableview frame size --> %f && %f && y--> %f",self.tableView.frame.size.width,self.tableView.frame.size.height,self.tableView.frame.origin.y);

    [self.view addSubview:self.tableView];
}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = 45;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
        
    {
        
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userole"]isEqualToString:@"ROLE_ADMIN"]){
            
            row = 60;
        }
        else{
           
            row = 70;
            
        }
        
    }
    
    else {
        
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userole"]isEqualToString:@"ROLE_ADMIN"]){
            
            row = 40;
        
        }
        
        else {
            
            row = 45;

        }
        
    }
    
    return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.titles objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *lblTitle = [[UILabel alloc]init];
    
    lblTitle.textColor=[UIColor whiteColor];
    [lblTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    lblTitle.highlightedTextColor = [UIColor lightTextColor];
    lblTitle.text = self.titles[indexPath.row];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    
    lblTitle.backgroundColor = [UIColor clearColor];

    [cell addSubview:lblTitle];
    
    UIImageView *imgvw = [[UIImageView alloc]init];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
        
    {
        //        lblTitle.font=[UIFont fontWithName:@"HelveticaNeue-bold" size:25];
        
        lblTitle.font=[UIFont fontWithName:@"Helvetica Neue" size:25];
        
       imgvw.frame = CGRectMake(25, 15, 30, 30);

        
        
    }
    
    else {
        
        lblTitle.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
        
        imgvw.frame = CGRectMake(10, 15, 20, 20);

        
    }

    int row = (int)indexPath.row;
    switch (row) {
        case 0:
            
            
            imgvw.image =[UIImage imageNamed:[self.images objectAtIndex:0]];
            
            [cell addSubview:imgvw];
            
            lblTitle.frame = CGRectMake(40, 5, self.view.frame.size.width-60, cell.frame.size.height);
            
            break;
        case 1:
            
            lblTitle.frame = CGRectMake(55, 5, self.view.frame.size.width-60, cell.frame.size.height);
            break;
            
        case 2:
            lblTitle.frame = CGRectMake(55, 5, self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 3:
            imgvw.image =[UIImage imageNamed:[self.images objectAtIndex:1]];
            [cell addSubview:imgvw];
            lblTitle.frame = CGRectMake(40, 5, self.view.frame.size.width-60, cell.frame.size.height);
            
            break;
        case 4:
            lblTitle.frame = CGRectMake(55, 5,self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 5:
            lblTitle.frame = CGRectMake(55, 5, self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 6:
            lblTitle.frame = CGRectMake(55, 5, self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 7:
            lblTitle.frame = CGRectMake(55, 5,self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 8:
            lblTitle.frame = CGRectMake(55, 5, self.view.frame.size.width-60, cell.frame.size.height);
            break;
        case 9:
           imgvw.image = [UIImage imageNamed:[self.images objectAtIndex:2]];
            [cell addSubview:imgvw];
            lblTitle.frame = CGRectMake(40, 5, self.view.frame.size.width-60, cell.frame.size.height);
            
            break;
           
        default:
            break;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 0, 3, 8 not selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    GPSVehicleListVC *objVehView =(GPSVehicleListVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"GPSVehicleListVC"];
    
//    GPSAdminViewLsitController *objListView =(GPSAdminViewLsitController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewList"];
    
//    GPSAccountAdminVC *objAccountView =(GPSAccountAdminVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountAdmin"];
    
       // "Mapping",@"Live Fleet",@"POI",@"Administration",@"Account",@"User",@"Vehicle",@"Groups",@"Log Out"]
    
    
    // 16/03/2018---Remove left panel Data
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userole"]isEqualToString:@"ROLE_ADMIN"]){
//
//    switch (indexPath.row) {
//        case 1: {
//
//
////            objVehView.strIdentifier = @"Vehicle List";
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSMapVC"]]
//                                                             animated:YES];
//
//
//
//            objDelegate.isLoadAllData = TRUE;
//           [self.sideMenuViewController hideMenuViewController];
//
//            break;
//        }
//        case 2:
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSSMSViewController"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//            break;
//
//        case 4:
////            objDelegate.strId =@"Account Admin List";
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AccountAdmin"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//            break;
//        case 5:
//        {
//
//            objDelegate.strId =@"View Vehicle Admin List";
//
////            objListView.strIdentifier =@"View Vehicle Admin List";
////            NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObject:@"View Vehicle Admin List" forKey:@"Identifier"];
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChengeIdentifier" object:nil userInfo:dicUserInfo];
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewList"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//
//            break;
//
//        }
//        case 6:
//
//        {
////            objListView.strIdentifier = @"View Group Admin List";
//            objDelegate.strId =@"View Group Admin List";
//
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewList"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//            break;
//
//        }
//        case 7:
//
//        {
////            objListView.strIdentifier = @"View User Admin List";
//            objDelegate.strId =@"View User Admin List";
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewList"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//            break;
//
//        }
//
//        case 8:
//
//        {
//            //            objListView.strIdentifier = @"View User Admin List";
//            objDelegate.strId =@"View User Roles";
//
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewList"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//
//            break;
//
//        }
//
//        case 9:
//
//        {
//
//            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
//
//            [self.sideMenuViewController hideMenuViewController];
//
//            [objDelegate.window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSLoginVC"]];
//
//            NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//            NSDictionary * dict = [defs dictionaryRepresentation];
//            for (id key in dict) {
//                [defs removeObjectForKey:key];
//            }
//            [defs synchronize];
//            [[NSOperationQueue mainQueue]cancelAllOperations];
//
//            [objDelegate.window makeKeyAndVisible];
//
//            break;
//
//        }
//        default:
//            break;
//    }
//    }
//
//    else {
//
//        switch (indexPath.row) {
//            case 1: {
//
//
//                //            objVehView.strIdentifier = @"Vehicle List";
//                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSMapVC"]]
//                                                             animated:YES];
//
//
//
//                objDelegate.isLoadAllData = TRUE;
//                [self.sideMenuViewController hideMenuViewController];
//
//                break;
//            }
//            case 2:{
//
//                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSSMSViewController"]]
//                                                             animated:YES];
//                [self.sideMenuViewController hideMenuViewController];
//
//                break;
//
//            }
//
//            case 3:
//
//                {
//
//                    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
//
//                    objDelegate.arrDeviceID = nil;
//                    objDelegate.arrSelectedGroupData = nil;
//                    objDelegate.arrVehicleList = nil;
//                    objDelegate.dicVehSetting = nil;
//                    objDelegate.strId = nil;
//                    objDelegate.strRightSubMenuVehId = nil;
//                    objDelegate.strroleID = nil;
//                    objDelegate.strUserName = nil;
//                    objDelegate.strVehID = nil;
//
//
//                    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//                    NSDictionary * dict = [defs dictionaryRepresentation];
//                    for (id key in dict) {
//                        [defs removeObjectForKey:key];
//                    }
//                    [defs synchronize];
//
//
//                    [self.sideMenuViewController hideMenuViewController];
//
//                    [objDelegate.window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSLoginVC"]];
//
//                    [objDelegate.window makeKeyAndVisible];
//
//                    break;
//
//                }
//            default:
//                break;
//            }
//
//    }
   // 16/03/2018---Remove left panel Data
    switch (indexPath.row) {
        case 1: {
            
            
            //            objVehView.strIdentifier = @"Vehicle List";
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSMapVC"]]
                                                         animated:YES];
            
            
            
            objDelegate.isLoadAllData = TRUE;
            [self.sideMenuViewController hideMenuViewController];
            
            break;
        }
        case 2:{
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSSMSViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            break;
            
        }
            
        case 3:
            
        {
            
            [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"Login"];
            
            [objDelegate.arrDeviceID removeAllObjects];
            objDelegate.arrSelectedGroupData = nil;
            objDelegate.arrVehicleList = nil;
            objDelegate.dicVehSetting = nil;
            objDelegate.strId = nil;
            objDelegate.strRightSubMenuVehId = nil;
            objDelegate.strroleID = nil;
            objDelegate.strUserName = nil;
            objDelegate.strVehID = nil;
            objDelegate.arrDeviceIDName = nil;
            
            
            NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
            NSDictionary * dict = [defs dictionaryRepresentation];
            for (id key in dict) {
                [defs removeObjectForKey:key];
            }
            [defs synchronize];
            
            
            [self.sideMenuViewController hideMenuViewController];
            
            [objDelegate.window setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GPSLoginVC"]];
            
            [objDelegate.window makeKeyAndVisible];
            
            break;
            
        }
        default:
            break;
    }

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
