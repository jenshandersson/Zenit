//
//  WeatherData.h
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>
@interface WeatherData : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *temp;
@property (nonatomic) NSNumber *windSpeed;
@property (nonatomic) NSNumber *sunrise;
@property (nonatomic) NSNumber *sunset;
@property (nonatomic) NSNumber *clouds;
@property (nonatomic) NSArray *weather;

- (NSString*)tempString;

@end


@interface WeatherCondition : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *main;
@property (nonatomic, copy) NSString *description;

@end
