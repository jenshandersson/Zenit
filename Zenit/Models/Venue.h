//
//  Venue.h
//  Zenit
//
//  Created by Jens Andersson on 6/23/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@class GMSMarker;

@interface Venue : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic) NSArray *categories;
@property (nonatomic) CLLocation *location;
@property (nonatomic) GMSMarker *marker;

@end
