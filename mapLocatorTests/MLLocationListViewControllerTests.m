//
//  MLLocationListViewControllerTest.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-26.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLLocationListViewController.h"
#import "MLLocationEditorViewController.h"
#import "MLLocationViewerViewController.h"

@interface MLLocationListViewControllerTests : XCTestCase
@property (strong, nonatomic) MLLocationListViewController *listViewController;
@property (strong, nonatomic) MLLocationEditorViewController *editController;
@property (strong, nonatomic) MLLocationViewerViewController *detailViewController;
@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) UINavigationController *navController;

@end

@implementation MLLocationListViewControllerTests



- (void)setUp
{
    [super setUp];
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //get the initialViewController, which is a UITabBarController;
    self.tabController= [storyboard instantiateInitialViewController];// [storyboard instantiateViewControllerWithIdentifier:@"locationNavigationController"];

    //instantiate MLLocationEditorViewController
    self.editController= [storyboard instantiateViewControllerWithIdentifier:@"addLocationViewController"];
     [self.editController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    //instantiate MLLocationViewerViewController
    self.detailViewController= [storyboard instantiateViewControllerWithIdentifier:@"viewLocationViewController"];
    [self.detailViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    //get the navController from tabController's first view controller;
    self.navController= [self.tabController.viewControllers objectAtIndex:0];
    [self.navController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    //set up root view controller;
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabController;
    
    //now get the the listViewController from the navController's first view controller;
    if ([self.navController.viewControllers count]>0)
        self.listViewController = [self.navController.viewControllers objectAtIndex: 0];
    
    //[self.navController setViewControllers: [NSArray arrayWithObjects:self.controller, self.detailViewController,nil]];
    [self.listViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    //self.navController=(UINavigationController *) self.listViewController.view.window.rootViewController;
    
    [self.navController setViewControllers:[NSArray arrayWithObjects:self.listViewController, self.detailViewController,nil]];



    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//----------------------check if view is initiated---------------
-(void)testView
{
    XCTAssertNotNil(self.listViewController.view, @"the view should not be nil");
}

//----------------------check if view has the addLocationButton outlet set---------------
-(void)testAddButtonIsThere
{
    XCTAssertNotNil(self.listViewController.addLocationButton, @"The 'add location' button should be on the view");
}

//----------------------check if the "locationListTableView" outlet is set -----------------------
- (void)testHasTableViewSubview
{
    NSArray *subviews = self.listViewController.view.subviews;
    XCTAssertTrue([subviews containsObject:self.listViewController.locationListTableView], @"View does not have a table subview");
}
//----------------------check if the locationListTableView initiated -----------------------
-(void)testTableViewLoads
{
    XCTAssertNotNil(self.listViewController.locationListTableView, @"TableView not initiated");
}

//----------------------check if the controller confirms UITableViewDataSource protocol  ---------------
- (void)testViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.listViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}
//----------------------check if the locationListTableView's datasource set --------------------------
- (void)testTableViewHasDataSource
{
    XCTAssertNotNil(self.listViewController.locationListTableView.dataSource, @"Table datasource cannot be nil");
}
//----------------------check if the controller confirms UITableViewDelegate protocol  ---------------
- (void)testViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.listViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}
//----------------------check if the locationListTableView's delegate set --------------------------
- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.listViewController.locationListTableView.delegate, @"Table delegate cannot be nil");
}
//----------------------check numberofSections for locationListTableView----------------------------
- (void)testTableViewNumberOfSections
{
    XCTAssertTrue([self.listViewController.locationListTableView numberOfSections]==1, @"Table should have 1 section");
}

//----------------------check numberofRowsInSection for locationListTableView----------------------------
- (void)testTableViewNumberOfRowsInSection
{
    //--------set up sample datasource array, contains 2 objects only------------
    Location *location1=[[Location alloc] init];
    Location *location2=[[Location alloc] init];
    self.listViewController.locationList=[[NSMutableArray alloc] initWithObjects:location1, location2, nil];
    [self.listViewController.locationListTableView reloadData];
    
    NSInteger expectedRows = 2;
    XCTAssertTrue([self.listViewController.locationListTableView numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.listViewController.locationListTableView numberOfRowsInSection:0], (long)expectedRows);
}

- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    //--------set up sample datasource array, contains 2 objects only------------
    Location *location1=[[Location alloc] init];
    Location *location2=[[Location alloc] init];
    self.listViewController.locationList=[[NSMutableArray alloc] initWithObjects:location1, location2, nil];
    [self.listViewController.locationListTableView reloadData];
    
    //-------get a sample cell and check its reuseIdentifier----------
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.listViewController.locationListTableView cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"LocationListCell"];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
}

//----------------------check if the controller has the "addLocation" segue set -----------------
- (void)testAddLocationSegueConnected
{
    XCTAssertNoThrow([self.listViewController performSegueWithIdentifier:@"addLocation" sender:self.listViewController.addLocationButton], @"Segue 'addLocation' should be set");
}

//----------------------check if the "addLocation" segue executed to show a "MLLocationEditorViewController" instance------------
-(void)testAddLocationSegueDestinationControllerClass
{
    XCTAssertNoThrow([self.listViewController performSegueWithIdentifier:@"addLocation" sender:self.listViewController.addLocationButton], @"Segue 'addLocation' should be set");
    
    XCTAssertTrue([self.listViewController.presentedViewController isMemberOfClass:[MLLocationEditorViewController class]], @"destination controller for addLocation segue should be a class of MLLocationEditorViewController");
    
}


- (void)testShowLocationDetailsSegueConnected
{
    //--------set up sample datasource array, contains 2 objects only------------
    Location *location1=[[Location alloc] init];
    Location *location2=[[Location alloc] init];
    self.listViewController.locationList=[[NSMutableArray alloc] initWithObjects:location1, location2, nil];
    [self.listViewController.locationListTableView reloadData];

    [self.listViewController.locationListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
   
    XCTAssertNoThrow([self.listViewController performSegueWithIdentifier:@"showLocationDetails" sender:self.listViewController], @"Segue 'showLocationDetails' should be set");
}


-(void)testShowLocationDetailsSegueDestinationControllerClass
{
    //--------set up sample datasource array, contains 2 objects only------------
    Location *location1=[[Location alloc] init];
    Location *location2=[[Location alloc] init];
    self.listViewController.locationList=[[NSMutableArray alloc] initWithObjects:location1, location2, nil];
    [self.listViewController.locationListTableView reloadData];
    
    [self.listViewController.locationListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    XCTAssertNoThrow([self.listViewController performSegueWithIdentifier:@"showLocationDetails" sender:self.listViewController], @"Segue 'showLocationDetails' should be set");
    
    //----------------check the first viewController of the navController's stack, if the class is MLLocationViewerViewController--------
    XCTAssertTrue([[self.listViewController.navigationController.viewControllers objectAtIndex:[self.listViewController.navigationController.viewControllers count]-1] isMemberOfClass:[MLLocationViewerViewController class]], @"destination controller for showLocationDetails segue should be a class of 'MLLocationViewerViewController'");
    
}

- (void)testPrepareSegueForAddLocation
{
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"addLocation" source:self.listViewController destination:self.editController performHandler:^{
        // do nothing here
    }];
    
    [self.listViewController prepareForSegue:segue sender:self];
    XCTAssertNotNil(self.editController.saveBtnObjectHandler, @"saveBtnHandler should not be nil after parepare segue for addLocation");
}

- (void)testPrepareSegueForShowLocationDetails
{
    UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:@"showLocationDetails" source:self.listViewController destination:self.detailViewController performHandler:^{
        // do nothing here
    }];
    
    [self.listViewController prepareForSegue:segue sender:self];
    XCTAssertNotNil(self.detailViewController.deleteBtnObjectHandler, @"deleteBtnObjectHandler should not be nil after parepare segue for showLocationDetails");
}
@end
