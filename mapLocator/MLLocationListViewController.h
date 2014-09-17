//
//  MLFirstViewController.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface MLLocationListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//-------the following three properties are used to handle core data implementation
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//define a property to hold the location list. Either load from core data
//or other db/remote service, you can still use the same property;
@property (nonatomic, strong) NSMutableArray *locationList;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLocationButton;

@property (nonatomic, strong) IBOutlet UITableView *locationListTableView;

//define a procedure to fill the locationList array with the objects retrieved from core data.
//if in future the storage is from other db or remote service, only need to change code in the
//following procedure; 
-(void)loadAllLocationList;
-(void)saveNewLocationToStorage: (Location *)location;
@end
