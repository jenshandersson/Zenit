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
    
    if (result == 0)  //check for SPA errors
    {
        //display the results inside the SPA structure
        
        printf("Julian Day:    %.6f\n",spa.jd);
        printf("L:             %.6e degrees\n",spa.l);
        printf("B:             %.6e degrees\n",spa.b);
        printf("R:             %.6f AU\n",spa.r);
        printf("H:             %.6f degrees\n",spa.h);
        printf("Delta Psi:     %.6e degrees\n",spa.del_psi);
        printf("Delta Epsilon: %.6e degrees\n",spa.del_epsilon);
        printf("Epsilon:       %.6f degrees\n",spa.epsilon);
        printf("Zenith:        %.6f degrees\n",spa.zenith);
        printf("Azimuth:       %.6f degrees\n",spa.azimuth);
        printf("Incidence:     %.6f degrees\n",spa.incidence);
        
        min = 60.0*(spa.sunrise - (int)(spa.sunrise));
        sec = 60.0*(min - (int)min);
        printf("Sunrise:       %02d:%02d:%02d Local Time\n", (int)(spa.sunrise), (int)min, (int)sec);
        
        min = 60.0*(spa.sunset - (int)(spa.sunset));
        sec = 60.0*(min - (int)min);
        printf("Sunset:        %02d:%02d:%02d Local Time\n", (int)(spa.sunset), (int)min, (int)sec);
        
    }
    
    return spa;
}


@end
