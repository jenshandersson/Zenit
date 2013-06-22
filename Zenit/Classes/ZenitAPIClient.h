#import "AFHTTPClient.h"

@class WeatherData;

@interface ZenitAPIClient : AFHTTPClient

+ (ZenitAPIClient *)sharedClient;

- (void)currentWeatherData:(void (^)(WeatherData *weather))block;

@end
