//
//  MLSecondViewController.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MLLocationMapViewController : UIViewController  <MKMapViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (nonatomic, strong) NSMutableArray *locationList;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *currentLocationBarButton;
@property (strong, nonatomic) UIActionSheet *actionSheet;

//-------the following three properties are used to handle core data implementation
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)showShareOptions:(id)sender;
-(void)addAnnotationsFromLocationList;
@end
