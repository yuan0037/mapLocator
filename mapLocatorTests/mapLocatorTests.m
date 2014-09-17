//
//  mapLocatorTests.m
//  mapLocatorTests
//
//  Created by bobyuaniMac on 2014-07-26.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface mapLocatorTests : XCTestCase

@end

@implementation mapLocatorTests

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

- (void)testStoryboardShouldBeInitialized
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[self class]]];
    XCTAssertNotNil(storyboard, @"storyboard should be initialized");
}


@end
