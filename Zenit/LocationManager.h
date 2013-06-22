//
//  RALocationManager.h
//  Rabble
//
//  Created by Micke Lisinge on 11/5/12.
//  Copyright (c) 2012 Rabble Communications AB. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^LocationUpdateBLock)(CLLocation *newLocation);

@interface LocationManager : CLLocationManager <CLLocationManagerDelegate>

@property (strong, nonatomic, readonly) CLLocation *currentLocation;
@property (strong, nonatomic, readonly) CLGeocoder *sharedGeocoder;
@property (nonatomic, copy) LocationUpdateBLock updateBlock;

+ (LocationManager *)shared;

@end
