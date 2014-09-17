//
//  MLDataTests.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-27.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "MLLocations.h"

@interface MLCoreDataTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation MLCoreDataTests

- (void)setUp
{
    [super setUp];

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MLData" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    XCTAssertTrue([persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    
    

    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateNew
{
    MLLocations *mlLocation = [NSEntityDescription insertNewObjectForEntityForName:@"MLLocations" inManagedObjectContext:self.managedObjectContext];
    mlLocation.locationDesc=@"Test Description";
    mlLocation.locationAddress=@"Test Address";
    double expectedLatitude = 37.787359f;
    double expectedLongitude = -122.408227f;
    
    mlLocation.locationLatitude=[NSNumber numberWithDouble: expectedLatitude];
    mlLocation.locationLongitude=[NSNumber numberWithDouble:expectedLongitude];
    
    
    NSUUID  *UUID = [NSUUID UUID];
    mlLocation.locationID=[UUID UUIDString];
        // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        XCTFail(@"Error saving in \"%@\" : %@, %@", @"createNew", error, [error userInfo]);
    }
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved");
}

- (void)testDelete
{
    MLLocations *mlLocation = [NSEntityDescription insertNewObjectForEntityForName:@"MLLocations" inManagedObjectContext:self.managedObjectContext];
    mlLocation.locationDesc=@"Test Description";
    mlLocation.locationAddress=@"Test Address";
    double expectedLatitude = 37.787359f;
    double expectedLongitude = -122.408227f;
    
    mlLocation.locationLatitude=[NSNumber numberWithDouble: expectedLatitude];
    mlLocation.locationLongitude=[NSNumber numberWithDouble:expectedLongitude];
    
    
    NSUUID  *UUID = [NSUUID UUID];
    mlLocation.locationID=[UUID UUIDString];
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        XCTFail(@"Error saving in \"%@\" : %@, %@", @"createNew", error, [error userInfo]);
    }
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved");
    
    //---------------now start to delete ---------------
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"MLLocations" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationID = %@",[UUID UUIDString]];
    //NSLog(@"predicate=%@", predicate.description);
    [fetchRequest setPredicate:predicate];
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error==nil)
    {
        //the deleted location object's locationID property is GUID, so only 1 object should be found
        //in the context if use locationID to locate the object ;
        if ([array count]==1)
        {
            [self.managedObjectContext deleteObject:[array objectAtIndex:0]];
            if (![self.managedObjectContext save:&error]) {
            XCTFail(@"Error deleting in \"%@\" : %@, %@", @"testDelete", error, [error userInfo]);
            }
        }
    }
    else
    {
       XCTFail(@"Error locate the new inserted object, error %@", [error userInfo]);
    }
 
}
@end
