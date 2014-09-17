//
//  LocationTest.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-26.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Location.h"


@interface LocationTests : XCTestCase

@end

@implementation LocationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//----------------------check if the controller confirms UITableViewDataSource protocol  ---------------
- (void)testConformsToMKAnnotation
{
    Location *location = [[Location alloc] init];
    XCTAssertTrue([location conformsToProtocol:@protocol(MKAnnotation) ], @"Location object should conform to MKAnnotation protocol");
}

- (void)testInitWithLocationNotNil
{
    //Simulator's location is stubbed to be in San Francisco, at this lat/lon
    CLLocationDegrees expectedLatitude = 37.787359f;
    CLLocationDegrees expectedLongitude = -122.408227f;
    
    Location *location = [[Location alloc] initWithLocation:CLLocationCoordinate2DMake(expectedLatitude, expectedLongitude)];
    XCTAssertNotNil(location, @"initWithLocation should initialize a Location object.");

}

-(void)testtestInitWithLocationCoordinateValue{
    CLLocationDegrees expectedLatitude = 37.787359f;
    CLLocationDegrees expectedLongitude = -122.408227f;
    
    Location *location = [[Location alloc] initWithLocation:CLLocationCoordinate2DMake(expectedLatitude, expectedLongitude)];

    XCTAssertTrue(((location.coordinate.latitude==expectedLatitude) && (location.coordinate.longitude==expectedLongitude)), @"initWithLocation should set up the correct cooridinate values.");
}


@end
