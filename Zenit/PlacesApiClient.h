//
//  PlacesApiClient.h
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "AFHTTPClient.h"


typedef void(^PlacesCallback)(AFHTTPRequestOperation *operation, NSArray *places);

@interface PlacesApiClient : AFHTTPClient

extern NSString* const kGoogleMapsPlacesApiKey;

+ (PlacesApiClient *)sharedClient;

- (void)getNearByPlaces:(PlacesCallback)success;

@end
