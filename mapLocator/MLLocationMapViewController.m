//
//  MLSecondViewController.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import "MLLocationMapViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MLLocationMapViewController ()

@end

@implementation MLLocationMapViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAllLocationList];
    [self addAnnotationsFromLocationList];
}

#pragma mark - mapView delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Location class]])
    {
        // Try to dequeue an existing pin view first.
        
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
 
            //-----add a button to trigger the share actionsheet ----------
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            UIImage *imageForRightButton = [UIImage imageNamed:@"chat_24x24.png"];

            [rightButton setImage:imageForRightButton forState:UIControlStateNormal];
            //Location *location = (Location *)annotation;
            [rightButton addTarget:self action:@selector(showShareOptions:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add a custom image to the left side of the callout.
            UIImageView *imageViewForLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick_24x24.png"]];
            pinView.leftCalloutAccessoryView = imageViewForLeft;
        }
        else
            pinView.annotation = annotation;
        return pinView;
        
    }
    return nil;
}


#pragma mark - load all locations from the storage
//--------------fill locationList property by objects retrieved from core data storage;-------------
-(void)loadAllLocationList {
    

    NSManagedObjectContext *context =self.managedObjectContext;
    
    NSError *error;
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"MLLocations" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (self.locationList!=nil)
    {
        [self.locationList removeAllObjects];
    }
    else
    {
        self.locationList = [[NSMutableArray alloc] init];
    }
    for (NSManagedObject *info in fetchedObjects) {
        Location *location = [[Location alloc] initWithLocation:CLLocationCoordinate2DMake([[info valueForKey:@"locationLatitude"] doubleValue], [[info valueForKey:@"locationLongitude"] doubleValue])];
        location.locationID=[info valueForKey:@"locationID"];
        location.locationDesc=[info valueForKey:@"locationDesc"];
        location.locationAddress=[info valueForKey:@"locationAddress"];
        
        [self.locationList addObject:location];
    }
    
    // UITabBarController *tabController =(UITabBarController *)appDelegate.window.rootViewController;
    // [[tabController.tabBar.items objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", [self.locationList count]]];
    
    
}

#pragma mark - addAnnotationsFromLocationList

-(void)addAnnotationsFromLocationList{
    //-------------clear all annotations on the mapView first -----------
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if ([self.locationList count]>0)
    {
        for (int i=0; i<=[self.locationList count]-1; i++)
        {
            Location *location = [self.locationList objectAtIndex: i];
            [self.mapView addAnnotation:location];
            
        }
    }
}

#pragma mark - actionsheet
- (IBAction)showShareOptions:(id)sender
{
    

    NSString *actionSheetTitle = @"Share"; //Action Sheet Title
    NSString *destructiveTitle = @"Cancel"; //Action Sheet Button Titles
    NSString *other1 = @"Share by Email";
    NSString *other2 = @"Share by iMessage/SMS";
    NSString *cancelTitle = @"Cancel Button";
    
     self.actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, nil];
    self.actionSheet.tag=1;
    

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [self.actionSheet showInView:self.view];
    } else {
        [self.actionSheet showInView:window];
    }
    

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    
                    break;
                case 1:
                    [self sendEmail];
                    break;
                case 2:
                    [self sendSMS];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - send Email & SMS/iMessage
-(void)sendEmail {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        Location *ann = [self.mapView.selectedAnnotations objectAtIndex:([self.mapView.selectedAnnotations count]-1)];
                         //  Location *location=(Location *)ann;
                           
        [mailCont setSubject:@"I want to share a good location with you"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@""]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"Description: %@\nAddress: %@", ann.locationDesc, ann.locationAddress] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendSMS {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@""];
    Location *ann = [self.mapView.selectedAnnotations objectAtIndex:([self.mapView.selectedAnnotations count]-1)];
    NSString *message = [NSString stringWithFormat:@"I want to share a good location with you. Description: %@ Location: %@", ann.locationDesc, ann.locationAddress];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MLData" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    NSURL *storeUrl =[[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"mapLocator.sqlite"];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                    initWithManagedObjectModel:[self managedObjectModel]];
    if(![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return __persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
