#import "AFHTTPClient.h"

@class WeatherData;

@interface ZenitAPIClient : AFHTTPClient

+ (ZenitAPIClient *)sharedClient;

- (void)currentWeatherData:(void (^)(WeatherData *weather))block;
- (void)closeVenues:(void (^)(NSArray *venues))block;
@end
