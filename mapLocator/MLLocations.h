//
//  MLLocations.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-28.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MLLocations : NSManagedObject

@property (nonatomic, retain) NSString * locationAddress;
@property (nonatomic, retain) NSString * locationDesc;
@property (nonatomic, retain) NSString * locationID;
@property (nonatomic, retain) NSNumber * locationLatitude;
@property (nonatomic, retain) NSNumber * locationLongitude;

@end
