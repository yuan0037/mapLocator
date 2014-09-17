//
//  MLLocationViewerViewControllerTests.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-28.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLLocationViewerViewController.h"

@interface MLLocationViewerViewControllerTests : XCTestCase
@property (strong, nonatomic) MLLocationViewerViewController *detailViewController;
@end

@implementation MLLocationViewerViewControllerTests

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //get the initialViewController, which is a UITabBarController;
    self.detailViewController= [storyboard instantiateViewControllerWithIdentifier:@"viewLocationViewController"];
    [self.detailViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//----------------------check if view is initiated---------------
-(void)testView
{
    XCTAssertNotNil(self.detailViewController.view, @"the view should not be nil");
}

//----------------------check if the controller confirms UIActionSheetDelegate protocol  ---------------
- (void)testViewConformsToUIActionSheetDelegate
{
    XCTAssertTrue([self.detailViewController conformsToProtocol:@protocol(UIActionSheetDelegate)], @"View does not conform to UIActionSheetDelegate protocol");
}

//----------------------check if view has the btnDelete -------------
-(void)testBtnDeleteIsThere
{
    XCTAssertNotNil(self.detailViewController.btnDelete, @"The 'Delete' button should be on the view");
}

//----------------------check if view has the btnDelete -------------
-(void)testlbLocationAddressIsThere
{
    XCTAssertNotNil(self.detailViewController.lbLocationAddress, @"The 'lbLocationAddress' label should be on the view");
}

//----------------------check if view has the btnDelete -------------
-(void)testlbLocationDescriptionIsThere
{
    XCTAssertNotNil(self.detailViewController.lbLocationDescription, @"The 'lbLocationDescription' label should be on the view");
}

//----------------------check if view has the btnDelete -------------
-(void)testlbLocationAddressEmpty
{
    XCTAssertTrue([self.detailViewController.lbLocationAddress.text length]==0, @"The 'lbLocationAddress' label should be empty on the view");
}

//----------------------check if view has the btnDelete -------------
-(void)testlbLocationDescriptionEmpty
{
    XCTAssertTrue([self.detailViewController.lbLocationDescription.text length]==0, @"The 'lbLocationDescription' label should be   empty on the view");
}

-(void)testDeleteBtnObjectHandler
{
    XCTAssertNil(self.detailViewController.deleteBtnObjectHandler, @"deleteBtnObjectHandler should be nil after load by itself");
}

-(void)testdeleteDataConfirmWithActionSheetConnected
{
    UIButton *button=self.detailViewController.btnDelete;
    XCTAssertTrue([[button actionsForTarget:self.detailViewController forControlEvent:UIControlEventTouchUpInside] containsObject: @"deleteDataConfirmWithActionSheet:"], @"btnDelete should be connected with deleteDataConfirmWithActionSheet action");
}

-(void)testIfTheActionSheetShowsAndDelegate {
    [self.detailViewController performSelectorOnMainThread:@selector(deleteDataConfirmWithActionSheet:) withObject:nil waitUntilDone:YES];
    XCTAssertEqualObjects(self.detailViewController.actionSheet.delegate, self.detailViewController, @"The Action Sheet delegate should be detailViewController");
    XCTAssertTrue(self.detailViewController.actionSheet.isVisible, @"The actionsheet should be visible");
    XCTAssertTrue([self.detailViewController.actionSheet.title isEqualToString:@"Do you really want to delete?"], @"The actionsheet's title should be 'Do you really want to delete?'");
    XCTAssertTrue([[self.detailViewController.actionSheet buttonTitleAtIndex:0] isEqualToString: @"Delete"] , @"The actionsheet's button title for index 0 should be 'Delete'.");
        XCTAssertTrue([[self.detailViewController.actionSheet buttonTitleAtIndex:self.detailViewController.actionSheet.cancelButtonIndex] isEqualToString: @"Cancel"] , @"The actionsheet's cancel button title should be 'Cancel'.");
    XCTAssertTrue((self.detailViewController.actionSheet.tag==1), "The actionsheet's tag should be 1");
    
}

-(void)testLoadLocationValues {
    //
    NSString *sampleAddress = [NSString stringWithFormat:@"%@",@"59 Bank Street, Ottawa, On"];
    NSString *sampleDescription = [NSString stringWithFormat:@"%@", @"Sample Store"];
    Location *location = [[Location alloc] init];
    location.locationAddress=sampleAddress;
    location.locationDesc=sampleDescription;
    [self.detailViewController setCurLocation:location];
    [self.detailViewController performSelector:@selector(loadLocationValues) withObject:nil];
    
    XCTAssertTrue([self.detailViewController.lbLocationDescription.text isEqualToString:self.detailViewController.curLocation.locationDesc], @"the lable for lbLocationDescription should be set with the correct value from the curLocation object");
    XCTAssertTrue([self.detailViewController.lbLocationAddress.text isEqualToString:self.detailViewController.curLocation.locationAddress], @"the lable for lbLocationAddress should be set with the correct value from the curLocation object");
}

@end
