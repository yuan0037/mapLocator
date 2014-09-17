//
//  MLLocationEditorViewControllerTests.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-27.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MLLocationEditorViewController.h"

@interface MLLocationEditorViewControllerTests : XCTestCase
@property (strong, nonatomic) MLLocationEditorViewController *addViewController;
@end

@implementation MLLocationEditorViewControllerTests

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //get the initialViewController, which is a UITabBarController;
    self.addViewController= [storyboard instantiateViewControllerWithIdentifier:@"addLocationViewController"];
    [self.addViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//----------------------check if view is initiated---------------
-(void)testView
{
    XCTAssertNotNil(self.addViewController.view, @"the view should not be nil");
}


//----------------------check if view has the btnSave -------------
-(void)testBtnSaveIsThere
{
    XCTAssertNotNil(self.addViewController.btnSave, @"The 'Save' button should be on the view");
}

//----------------------check if view has the btnSave -------------
-(void)testBtnCancelIsThere
{
    XCTAssertNotNil(self.addViewController.btnCancel, @"The 'Cancel' button should be on the view");
}

//----------------------check if view has the statusLabel -------------
-(void)testLbStatusIsThere
{
    XCTAssertNotNil(self.addViewController.lbStatus, @"The 'Status' label should be on the view");
}

-(void)testLbStatusDefaultText
{
    XCTAssertTrue([self.addViewController.lbStatus.text isEqualToString:@""], @"The 'Status' label text should be empty");
}
//----------------------check if view has the tfLocationDescription is there---------------
-(void)testTfLocationDescriptionIsThere
{
    XCTAssertNotNil(self.addViewController.tfLocationDescription, @"The 'Description' uiTextField should be on the view");
}

//----------------------check if view has the tfAddress is there---------------
-(void)testTfAddressIsThere
{
    XCTAssertNotNil(self.addViewController.tfAddress, @"The 'Address' uiTextField should be on the view");
}

//----------------------check if view has the tfLocationDescription is there---------------
-(void)testTfLocationDescriptionIsEmptyAfterLoad
{
    XCTAssertTrue([self.addViewController.tfLocationDescription.text length]==0, @"The 'Description' uiTextField should be empty on the view after load");
}

//----------------------check if view has the tfAddress is there---------------
-(void)testTfAddressIsEmptyAfterLoad
{
    XCTAssertTrue([self.addViewController.tfAddress.text length]==0, @"The 'Address' uiTextField should be empty on the view after load");
}
//----------------------check if the controller confirms UITableViewDelegate protocol  ---------------
- (void)testViewConformsToUITextFieldDelegate
{
    XCTAssertTrue([self.addViewController conformsToProtocol:@protocol(UITextFieldDelegate) ], @"View does not conform to UITextFieldDelegate delegate protocol");
}

//----------------------check if the dataEntryContentView is there ---------------
- (void)testButtonGroupContentViewNotNil
{
    XCTAssertNotNil(self.addViewController.buttonGroupContentView, @"buttonGroupContentView should not be nil");
}


//----------------------check if the dataEntryContentView is there ---------------
- (void)testDataEntryContentViewNotNil
{
    XCTAssertNotNil(self.addViewController.dataEntryContentView, @"dataEntryContentView should not be nil");
}

//----------------------check if the DataEntryContentView is visible  ---------------
- (void)testDataEntryContentViewVisible
{
    XCTAssertFalse(self.addViewController.dataEntryContentView.hidden, @"DataEntryContentView should not be hidden");
}

-(void)testSaveButtonActionConnected
{
    UIButton *button=self.addViewController.btnSave;
    XCTAssertTrue([[button actionsForTarget:self.addViewController forControlEvent:UIControlEventTouchUpInside] containsObject: @"saveData:"], @"btnSave should be connected with SaveData action");
}

-(void)testCancelButtonActionConnected
{
    UIButton *button=self.addViewController.btnCancel;
    XCTAssertTrue([[button actionsForTarget:self.addViewController forControlEvent:UIControlEventTouchUpInside] containsObject: @"cancel:"], @"btnCancel should be connected with cancel action");
}

-(void)testSaveDataWithNoAddress
{
    NSString *sampleDescription = [NSString stringWithFormat:@"%@", @"Sample Store"];
    self.addViewController.tfAddress.text=@"";
    self.addViewController.tfLocationDescription.text=sampleDescription;
    [self.addViewController performSelectorOnMainThread:@selector(saveData:) withObject:self.addViewController.btnSave waitUntilDone:YES];
    
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (self.addViewController.hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    XCTAssertNil(self.addViewController.curLocation, @"curLocation object should be nil for no address input");
    XCTAssertFalse(self.addViewController.lbStatus.hidden, @"Status lable should not be hidden");
}

-(void)testSaveDataWithNoDescription
{
    NSString *sampleAddress = [NSString stringWithFormat:@"%@",@"59 Bank Street, Ottawa, On"];
    self.addViewController.tfAddress.text=sampleAddress;
    self.addViewController.tfLocationDescription.text=@"";
    [self.addViewController performSelectorOnMainThread:@selector(saveData:) withObject:self.addViewController.btnSave waitUntilDone:YES];
    
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (self.addViewController.hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    XCTAssertNil(self.addViewController.curLocation, @"curLocation object should be nil for no description input");
    XCTAssertFalse(self.addViewController.lbStatus.hidden, @"Status lable should not be hidden");
}

-(void)testSaveDataWithValidAddressAndDescription
{
    NSString *sampleAddress = [NSString stringWithFormat:@"%@",@"59 Bank Street, Ottawa, On"];
    NSString *sampleDescription = [NSString stringWithFormat:@"%@", @"Sample Store"];
    self.addViewController.tfAddress.text=sampleAddress;
    self.addViewController.tfLocationDescription.text=sampleDescription;
    [self.addViewController performSelectorOnMainThread:@selector(saveData:) withObject:self.addViewController.btnSave waitUntilDone:YES];
    
    //-----------------------wait for the completion of the saveData: -------------------------
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (self.addViewController.hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    XCTAssertTrue([self.addViewController.curLocation.locationAddress isEqualToString:sampleAddress] && [self.addViewController.curLocation.locationDesc isEqualToString:sampleDescription], @"Location object should have the same address and description as the controls' input");
    XCTAssertTrue(CLLocationCoordinate2DIsValid(self.addViewController.curLocation.coordinate), @"Location object should have non-nil have a valid coordinate");
    
}
-(void)testCancel
{
    [self.addViewController performSelector:@selector(cancel:) withObject:nil afterDelay:1.0];
    XCTAssertNil(self.addViewController.presentingViewController.presentedViewController, @"addViewController should be dismissed");
}

-(void)testCloseView
{
    [self.addViewController performSelector:@selector(closeView:) withObject:nil afterDelay:1.0];
    XCTAssertNil(self.addViewController.presentingViewController.presentedViewController, @"addViewController should be dismissed");
}
@end
