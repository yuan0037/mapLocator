//
//  MLFirstViewController.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//



#import "MLLocationListViewController.h"
#import "MLLocations.h"

#import "Location.h"
#import "MLLocationViewerViewController.h"
#import "MLLocationEditorViewController.h"



@interface MLLocationListViewController ()

@end

@implementation MLLocationListViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
   	// Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAllLocationList];
    [self.locationListTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (NSManagedObject *info in fetchedObjects)
    {
        Location *newLocation = [[Location alloc] init];
        newLocation.locationID=[info valueForKey:@"locationID"];
        newLocation.locationDesc=[info valueForKey:@"locationDesc"];
        newLocation.locationAddress=[info valueForKey:@"locationAddress"];
        [self.locationList addObject:newLocation];
    }  
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //use the prototype cell we defined in the storyboard;
    static NSString *simpleTableIdentifier = @"LocationListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Location *location=[self.locationList objectAtIndex:indexPath.row];
    cell.textLabel.text = location.locationDesc;
    return cell;
}

#pragma mark - Save New/Delete location with Storage;

-(void)saveNewLocationToStorage: (Location *)location
{
    // MLAppDelegate *appDelegate =
    // [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =self.managedObjectContext;
    NSManagedObject *newLocation;
    newLocation = [NSEntityDescription
                   insertNewObjectForEntityForName:@"MLLocations"
                   inManagedObjectContext:context];
    [newLocation setValue: location.locationDesc forKey:@"locationDesc"];
    [newLocation setValue: location.locationAddress forKey:@"locationAddress"];
    [newLocation setValue:[NSNumber numberWithDouble: location.coordinate.latitude] forKeyPath:@"locationLatitude"];
    [newLocation setValue:[NSNumber numberWithDouble: location.coordinate.longitude] forKeyPath:@"locationLongitude"];
    [newLocation setValue: location.locationID forKey:@"locationID"];
    
    NSError *error;
    [context save:&error];
    
}

-(void)deleteLocationFromStorage: (Location *)location
{
    NSManagedObjectContext *context =self.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"MLLocations" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationID = %@", location.locationID];
   
    [fetchRequest setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error==nil)
    {
        //the deleted location object's locationID property is GUID, so only 1 object should be found
        //in the context if use locationID to locate the object ;
        if ([array count]==1)
        {
            [context deleteObject:[array objectAtIndex:0]];
            [context save:&error];
        }
    }
    else
    {
        NSLog(@"cannot delete, error=%@", error.description);
    }
}

#pragma mark - prepareForSegue
//---------------------tap on add button; tap on cell;--------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addLocation"])
    {
        MLLocationEditorViewController *locationEditorController = segue.destinationViewController;
        
        //----------------------permanent data to storage for add action---------------------------
        locationEditorController.saveBtnObjectHandler= ^(Location* location)
        {
            [self saveNewLocationToStorage:location];
        };
    }
    if ([segue.identifier isEqualToString:@"showLocationDetails"])
    {
        //---------get selected row in the tableview -------------
        NSIndexPath *indexPath = [self.locationListTableView indexPathForSelectedRow];
        
        //---------get destinationviewcontroller-----------------------
        MLLocationViewerViewController *detailLocationViewController = segue.destinationViewController;
        
        //----------assign the  custom Location object to the detailviewer controller; ---------
        detailLocationViewController.curLocation = [self.locationList objectAtIndex:indexPath.row];
        
        //----------set up the detailviewer controller's delete button handler ---------------------
        //-----------use a Location object to handle value passing and handle the delete process-----------
        detailLocationViewController.deleteBtnObjectHandler= ^(Location* location)
        {
            //---------------------delete from storage---------------
            [self deleteLocationFromStorage:location];
            //-------------handing the locationList array, remove the deleted Location object from it-------------
            [self.locationList removeObjectAtIndex:[self.locationListTableView indexPathForSelectedRow].row];
            //-------------reload the uitableview to reflect the latest changes -------------------------
            [self.locationListTableView reloadData];
        };
        
        
    }
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
