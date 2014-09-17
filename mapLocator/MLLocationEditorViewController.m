//
//  MLAddLocationViewController.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//





//-----------------Enhancement Ideas -------------
// remove trailing space and leading space for description/address
// force user to enter full address
// use Google's MAP API to get cooridinate

#import "MLLocationEditorViewController.h"
#import "MLAppDelegate.h"

@interface MLLocationEditorViewController ()

@end

@implementation MLLocationEditorViewController

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
    self.hasCalledBack=NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataEntryContentView setHidden:NO];
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



//-------dismiss keyboard if touched outside of any uitextfield;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



//-------save the new location object with the address/description/coordinates-------
- (IBAction)saveData:(id)sender{
    //-----------------------set up restriction, description and address cannot be empty-----------------
    if ([self.tfLocationDescription.text length]==0||([self.tfAddress.text length]==0))
    {
        NSString *hintMessageText=[NSString stringWithFormat:@"Please enter"];
        if ([self.tfLocationDescription.text length]==0)
        {
            hintMessageText=[NSString stringWithFormat:@"%@ --- a description", hintMessageText];
        }
        if ([self.tfAddress.text length]==0)
        {
            hintMessageText=[NSString stringWithFormat:@"%@ --- an address", hintMessageText];
        }
        
        self.lbStatus.text=hintMessageText;
        self.lbStatus.hidden=NO;
        
        //-------------------unit test for it can go to next step ---------------------
        self.hasCalledBack=YES;
    }
    else
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.tfAddress.text completionHandler:^(NSArray* placemarks, NSError* error)
         {
             //----------if cannot parse the street address,show detail error message;
             //----------if no error shows up, show successful saved message, hide the view containing the data entry controls,
             //----------wait for 1 second, and dismiss the current viewcontroller;
             
             //-------------------here indicate the completionBlock start to execute, now the-------------
             //-------------------unit test for it can go to next step ---------------------
             self.hasCalledBack = YES;
             
             if (error!=nil)
             {
                 NSLog(@"error happens during geocodeAddressString, error =%@", error);
                 self.lbStatus.text=[NSString stringWithFormat:@"Please enter a valid address."];
                 self.lbStatus.hidden=NO;
                 
             }
             else
             {
                 if (placemarks && placemarks.count > 0)
                 {
                     //-----------------create a custom Location object, and assigne values to its properties ---------------
                     CLPlacemark *topResult = [placemarks objectAtIndex:0];
                     MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                     
                     self.curLocation=[[Location alloc] initWithLocation:placemark.location.coordinate];
                     //NSLog(@"curLocation now init");
                     self.curLocation.locationAddress=self.tfAddress.text;
                     self.curLocation.locationDesc=self.tfLocationDescription.text;
                     NSUUID  *UUID = [NSUUID UUID];
                     self.curLocation.locationID=[UUID UUIDString];
                     
                 }

                 
                 //---------------------------clear the data entry controls' content and hide them ----------------
                 self.tfLocationDescription.text = @"";
                 self.tfAddress.text = @"";
                 [self.dataEntryContentView setHidden:YES];
                 
                 //---------------------------show success message-----------------------------
                 self.lbStatus.text=[NSString stringWithFormat:@"%@", @"The new location was saved successfully!"];
                 self.lbStatus.hidden=NO;
                 
                 
                 //wait for 1 sec to redirect to the list view controller;
                 [NSTimer scheduledTimerWithTimeInterval:0.0
                                                  target:self
                                                selector:@selector(closeView:)
                                                userInfo:nil
                                                 repeats:YES];
                 
                 if (self.saveBtnObjectHandler)
                     self.saveBtnObjectHandler(self.curLocation);
                 
                 
             }
         }
         ];
    }
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)closeView:(NSTimer*)timer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
