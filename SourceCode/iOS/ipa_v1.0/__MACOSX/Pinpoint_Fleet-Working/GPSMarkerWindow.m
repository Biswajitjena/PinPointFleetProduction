//
//  GPSMarkerWindow.m
//  OpenGTS
//
//  Created by Sandip Rudani on 01/07/14.
//  Copyright (c) 2014 Dhara Shah. All rights reserved.
//

#import "GPSMarkerWindow.h"

@interface GPSMarkerWindow ()
    
    

@end

@implementation GPSMarkerWindow

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
    
    self.view.layer.cornerRadius = 6.0;
    
    
    
//    self.lblSensor.numberOfLines = 0;
//    
//    CGSize maximumLabelSize = CGSizeMake(170,9999);
//    
//    CGSize expectedLabelSize = [self.lblSensor.text sizeWithFont:self.lblSensor.font
//                                               constrainedToSize:maximumLabelSize
//                                                   lineBreakMode:NSLineBreakByWordWrapping];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = self.lblSensor.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    self.lblSensor.frame = newFrame;
    
    
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
