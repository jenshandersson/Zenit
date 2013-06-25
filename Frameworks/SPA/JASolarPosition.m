//
//  JASolarPosition.m
//  Zenit
//
//  Created by Jens Andersson on 2013-06-24.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "JASolarPosition.h"
#import "spa.h"

@implementation JASolarPosition

static NSInteger minHour = 7;
static NSInteger maxHour = 24;

+ (spa_data)azimuthAtLocation:(CLLocation *)location andDate:(NSDate *)date {
    spa_data spa;  //declare the SPA structure
    int result;
    float min, sec;
    
    NSUInteger config = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|
    NSSecondCalendarUnit|NSTimeZoneCalendarUnit;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:config fromDate:date];
    
    spa.year          = components.year;
    spa.month         = components.month;
    spa.day           = components.day;
    spa.hour          = components.hour;
    spa.minute        = components.minute;
    spa.second        = components.second;
    spa.timezone      = [components.timeZone secondsFromGMT] / 3600;
    spa.delta_ut1     = 0;
    spa.delta_t       = 67;
    spa.longitude     = location.coordinate.longitude;
    spa.latitude      = location.coordinate.latitude;
    spa.elevation     = location.altitude;
    spa.pressure      = 820;
    spa.temperature   = 15;
    spa.slope         = 30;
    spa.azm_rotation  = -10;
    spa.atmos_refract = 0.5667;
    spa.function      = SPA_ALL;
    
    //call the SPA calculate function and pass the SPA structure
    
    result = spa_calculate(&spa);
    
    /*
    if (result == 0)  //check for SPA errors
    {
        min = 60.0*(spa.sunrise - (int)(spa.sunrise));
        sec = 60.0*(min - (int)min);
        printf("Sunrise:       %02d:%02d:%02d Local Time\n", (int)(spa.sunrise), (int)min, (int)sec);
        
        min = 60.0*(spa.sunset - (int)(spa.sunset));
        sec = 60.0*(min - (int)min);
        printf("Sunset:        %02d:%02d:%02d Local Time\n", (int)(spa.sunset), (int)min, (int)sec);
        
    }
    */
    return spa;
}

+ (CGFloat)timeAsFloat:(NSDate *)date {
    NSInteger interval = (maxHour - minHour) * 60;
    NSDateComponents *componens = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    NSInteger minutes = (componens.hour - minHour) * 60 + componens.minute;
    CGFloat percent = 1.0f * minutes / interval;
    return percent;
}

+ (NSString *)dateStringFromFloat:(CGFloat)percent {
    
    NSDate *d = [self dateFromFloat:percent];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm";
    return [df stringFromDate:d];
}

+ (NSDate *)dateFromFloat:(CGFloat)percent {
    NSInteger interval = (maxHour - minHour) * 60;
    NSInteger allMinutes = interval * percent;
    NSInteger hour = allMinutes / 60;
    NSInteger minute = allMinutes - 60 * hour;
    
    hour = minHour + hour;
    
    NSDate *date = [NSDate date];
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSTimeZoneCalendarUnit fromDate:date];
    
    c.hour = hour;
    c.minute = minute;
    date = [[NSCalendar currentCalendar] dateFromComponents:c];
    return date;
}

+ (NSString *)timeStringWithInt:(NSInteger)number {
    NSString * s = [NSString stringWithFormat:@"%d", number];
    NSString *prefix = @"";
    if (s.length == 0)
        prefix = @"00";
    else if (s.length == 1)
        prefix = @"0";
    return [prefix stringByAppendingString:s];
}


@end
