//
//  Place.h
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MTLModel.h"
#import <CoreLocation/CoreLocation.h>
#import <Mantle.h>

@class GMSMarker;

@interface Place : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *vicinity;
@property (nonatomic, copy) NSString *id;
@property (nonatomic) NSURL *icon;
@property (nonatomic) NSArray *types;
@property (nonatomic) CLLocation *location;
@property (nonatomic) GMSMarker *marker;

@end
