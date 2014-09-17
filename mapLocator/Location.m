//
//  Location.m
//  mapLocator
//
//  Created by bobyuaniMac on 2014-07-24.
//  Copyright (c) 2014 boyuan. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    
    self = [super init];
    
    if (self) {
        
        coordinate = coord;
        
    }
    
    return self;
    
}



- (NSString *)title{
    return self.locationDesc;
}

@end
