//
//  WeatherData.m
//  Zenit
//
//  Created by Jens Andersson on 6/22/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"windSpeed": @"wind.speed",
             @"temp": @"main.temp",
             @"clouds":@"clouds.all"};
}

+ (NSValueTransformer *)weatherJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[WeatherCondition class]];
}

- (NSString*)tempString {
    return [NSString stringWithFormat:@"%0.1f∘", self.temp.intValue - 273.15];
}

@end

@implementation WeatherCondition

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


@end