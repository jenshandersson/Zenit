//
//  Place.m
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "Place.h"
#import <GoogleMaps.h>

@implementation Place

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"location":@"geometry.location"};
}

+ (NSValueTransformer *)iconURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)locationJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *dict) {
        NSNumber *lat = [dict objectForKey:@"lat"];
        NSNumber *lon = [dict objectForKey:@"lng"];
        return [[CLLocation alloc] initWithLatitude:lat.floatValue longitude:lon.floatValue];
    } reverseBlock:^(CLLocation *location) {
        return @{@"lat":@(location.coordinate.latitude),
                 @"lng":@(location.coordinate.longitude)};
    }];
}

- (GMSMarker *)marker {
    if (!_marker) {
        _marker = [[GMSMarker alloc] init];
    }
    _marker.position = self.location.coordinate;
    _marker.title = self.name;
    return _marker;
}

@end
