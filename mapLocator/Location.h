//
//  Location.h
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, copy) NSString * locationID;
@property (nonatomic, copy) NSString * locationDesc;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * locationLatitude;
@property (nonatomic, copy) NSString * locationLongitude;
@property (nonatomic, copy) NSDate * createdOn;
@property (nonatomic, copy) NSString * locationAddress;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

//- (id)initWithCoordinates:(CLLocationCoordinate2D)location address: (NSString *)address description:(NSString *)description;


@end
