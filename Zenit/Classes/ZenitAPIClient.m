#import "ZenitAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "WeatherData.h"
#import "LocationManager.h"

static NSString * const kZenitAPIBaseURLString = @"";

@implementation ZenitAPIClient

+ (ZenitAPIClient *)sharedClient {
    static ZenitAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kZenitAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (void)currentWeatherData:(void (^)(WeatherData *weather))block {
    CLLocation *location = [LocationManager shared].currentLocation;
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [parameters setObject:[self stringWith5Digits:location.coordinate.longitude] forKey:@"lon"];
    [parameters setObject:[self stringWith5Digits:location.coordinate.latitude] forKey:@"lat"];
    
    [self getPath:@"http://api.openweathermap.org/data/2.5/weather" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WeatherData *weather = [MTLJSONAdapter modelOfClass:[WeatherData class] fromJSONDictionary:responseObject error:nil];
        if (block)
            block(weather);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];

}

- (NSString *)stringWith5Digits:(CLLocationDegrees)degrees {
    return [NSString stringWithFormat:@"%.05f", degrees];
}


@end
