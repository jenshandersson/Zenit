//
//  PlacesApiClient.m
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "PlacesApiClient.h"
#import <AFNetworking.h>
#import "LocationManager.h"
#import "Place.h"

@implementation PlacesApiClient

NSString* const kGoogleMapsPlacesApiKey = @"AIzaSyCIzcA8VGcvVqTyL1XWbTGCHUuqXxAXe4A";

+ (PlacesApiClient *)sharedClient {
    static PlacesApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/"]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


- (void)getNearByPlaces:(PlacesCallback)success {
    NSMutableDictionary *parameters = @{@"sensor":@"true"}.mutableCopy;
    [parameters setObject:kGoogleMapsPlacesApiKey forKey:@"key"];
    
    CLLocation *location = [LocationManager shared].currentLocation;
    
    NSAssert(location, @"No location was given yet, waaaait for it");
    
    NSString *locationString = [NSString stringWithFormat:@"%.05f,%.05f", location.coordinate.latitude, location.coordinate.longitude];
    [parameters setObject:locationString forKey:@"location"];
    [parameters setObject:@"100" forKey:@"radius"];
    [parameters setObject:@"cafe|restaurant|bar" forKey:@"types"];
    
    
    [self getPath:@"nearbysearch/json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *results = [responseObject objectForKey:@"results"];
        NSValueTransformer *transform = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Place class]];
        NSArray *places = [transform transformedValue:results];
        if (success)
            success(operation, places);
        ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
