//
//  MLLocationMapViewControllerTests.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-27.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLLocationMapViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MLLocationMapViewControllerTests : XCTestCase
@property (strong, nonatomic) MLLocationMapViewController *mapViewController;


@end

@implementation MLLocationMapViewControllerTests

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //get the initialViewController, which is a UITabBarController;
    self.mapViewController= [storyboard instantiateViewControllerWithIdentifier:@"locationMapViewController"];
    [self.mapViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//----------------------check if view is initiated---------------
-(void)testView
{
    XCTAssertNotNil(self.mapViewController.view, @"the view should not be nil");
}



//----------------------check if the "mapView" outlet is set -----------------------
- (void)testParentViewHasMapViewSubview
{
    NSArray *subviews = self.mapViewController.view.subviews;
    XCTAssertTrue([subviews containsObject:self.mapViewController.mapView], @"View does not have a map subview");
}

//----------------------check if the locationListTableView initiated -----------------------
-(void)testTableViewLoads
{
    XCTAssertNotNil(self.mapViewController.mapView, @"Mapview not initiated");
}
//----------------------check if the controller confirms UITableViewDataSource protocol  ---------------
- (void)testViewConformsToUIMapViewDelegate
{
    XCTAssertTrue([self.mapViewController conformsToProtocol:@protocol(MKMapViewDelegate)], @"View does not conform to UIMapViewDelegate protocol");
}
//----------------------check if the controller confirms UIActionSheetDelegate protocol  ---------------
- (void)testViewConformsToUIActionSheetDelegate
{
    XCTAssertTrue([self.mapViewController conformsToProtocol:@protocol(UIActionSheetDelegate)], @"View does not conform to UIActionSheetDelegate protocol");
}
//----------------------check if the controller confirms MFMailComposeViewControllerDelegate protocol  ---------------
- (void)testViewConformsToMFMailComposeViewControllerDelegate
{
    XCTAssertTrue([self.mapViewController conformsToProtocol:@protocol(MFMailComposeViewControllerDelegate)], @"View does not conform to MFMailComposeViewControllerDelegate protocol");
}
//----------------------check if the controller confirms MFMessageComposeViewControllerDelegate protocol  ---------------
- (void)testViewConformsToMFMessageComposeViewControllerDelegate
{
    XCTAssertTrue([self.mapViewController conformsToProtocol:@protocol(MFMessageComposeViewControllerDelegate)], @"View does not conform to MFMessageComposeViewControllerDelegate protocol");
}
//----------------------check if the mapView's delegate set --------------------------
- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.mapViewController.mapView.delegate, @"mapView's delegate cannot be nil");
}

-(void)testAddAnnotationsFromLocationList
{
    XCTAssertTrue(self.mapViewController.locationList.count==self.mapViewController.mapView.annotations.count, @"locationList count should equal annotaions count.");
    if (self.mapViewController.mapView.annotations.count>0)
    {
        for (int i=0; i<=self.mapViewController.mapView.annotations.count-1; i++)
        {
            XCTAssertEqualObjects([self.mapViewController.locationList objectAtIndex:i], [self.mapViewController.mapView.annotations objectAtIndex:i], @"location object should equal annotation object");
        }
    }
}


-(void)testIfTheActionSheetShowsAndDelegate {
    [self.mapViewController performSelectorOnMainThread:@selector(showShareOptions:) withObject:nil waitUntilDone:YES];
    XCTAssertEqualObjects(self.mapViewController.actionSheet.delegate, self.mapViewController, @"The Action Sheet delegate should be mapViewController");
    XCTAssertTrue(self.mapViewController.actionSheet.isVisible, @"The actionsheet should be visible");
    XCTAssertTrue([self.mapViewController.actionSheet.title isEqualToString:@"Share"], @"The actionsheet's title should be Share");
    XCTAssertTrue([[self.mapViewController.actionSheet buttonTitleAtIndex:0] isEqualToString: @"Cancel"] , @"The actionsheet's button title for index 0 should be 'Cancel'.");
    XCTAssertTrue([[self.mapViewController.actionSheet buttonTitleAtIndex:1] isEqualToString: @"Share by Email"] , @"The actionsheet's button title for index 1 should be 'Share by Email'.");
    XCTAssertTrue([[self.mapViewController.actionSheet buttonTitleAtIndex:2] isEqualToString: @"Share by iMessage/SMS"] , @"The actionsheet's button title for index 2 should be 'Share by iMessage/SMS'.");
    
    XCTAssertTrue((self.mapViewController.actionSheet.tag==1), "The actionsheet's tag should be 1");
    
}

-(void)testViewForAnnotationWithReuseIdentifier{
    
    //--------set up sample location list, contains 2 objects only------------
    CLLocationDegrees expectedLatitude1 = 37.787359f;
    CLLocationDegrees expectedLongitude1 = -122.408227f;
    
    Location *location1 = [[Location alloc] initWithLocation:CLLocationCoordinate2DMake(expectedLatitude1, expectedLongitude1)];
    
    CLLocationDegrees expectedLatitude2 = 45.787359f;
    CLLocationDegrees expectedLongitude2 = -102.408227f;
    
    Location *location2 = [[Location alloc] initWithLocation:CLLocationCoordinate2DMake(expectedLatitude2, expectedLongitude2)];
    self.mapViewController.locationList=[[NSMutableArray alloc] initWithObjects:location1, location2, nil];
    
    [self.mapViewController performSelectorOnMainThread:@selector(addAnnotationsFromLocationList) withObject:nil waitUntilDone:YES];
    
    
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"CustomPinAnnotationView"];
    
    for (id<MKAnnotation> annotation in self.mapViewController.mapView.annotations){
        if ([annotation isKindOfClass:[Location class]])
        {
            MKAnnotationView* anView = [self.mapViewController.mapView viewForAnnotation: annotation];
            if (anView){
                XCTAssertTrue([anView.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Annotation view should use CustomPinAnnotationView as the reuse identifier");
            }
        }
    }
}
@end
