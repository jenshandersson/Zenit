//
//  JASolarPosition.h
//  Zenit
//
//  Created by Jens Andersson on 2013-06-24.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "spa.h"

@interface JASolarPosition : NSObject

+ (spa_data)azimuthAtLocation:(CLLocation *)location andDate:(NSDate *)date;

@end
