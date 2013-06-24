//
//  RALocationManager.m
//  Rabble
//
//  Created by Micke Lisinge on 11/5/12.
//  Copyright (c) 2012 Rabble Communications AB. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

@end

@implementation LocationManager

+ (LocationManager *)shared {
    static dispatch_once_t onceToken;
    static LocationManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[LocationManager alloc] init];
        shared.delegate = shared;
        shared.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        shared.distanceFilter = 10;
    });
    return shared;
}

#pragma mark - Delegates

// Method used in iOS < 6.0
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self locationManager:manager didUpdateLocations:[NSArray arrayWithObject:[manager location]]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self willChangeValueForKey:@"currentLocation"];
    _currentLocation = [locations lastObject];
    [self didChangeValueForKey:@"currentLocation"];
    if (self.updateBlock)
        self.updateBlock(_currentLocation.copy);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch ([error code]) {
        case kCLErrorDenied:
            NSLog(@"CLLocationManager Error Denied");
            break;
        case kCLErrorLocationUnknown:
            NSLog(@"CLLocationManager Error Location Unknown: %@", error);
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            break;
        case kCLAuthorizationStatusDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktivera positioneringstjänster"
                                                            message:@"För att kunna utnyttja platsbundna erbjudanden så måste du ha platstjänster aktiverade och tillåta Rabble under positioneringstjänster"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

@end
