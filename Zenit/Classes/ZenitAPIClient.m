#import "ZenitAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "WeatherData.h"
#import "LocationManager.h"
#import "Venue.h"

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


- (void)closeVenues:(void (^)(NSArray *venues))block {
    CLLocation *location = [LocationManager shared].currentLocation;
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSString *locationString = [NSString stringWithFormat:@"%.05f,%.05f", location.coordinate.latitude, location.coordinate.longitude];
    parameters[@"ll"] = locationString;
    parameters[@"client_id"] = @"AIRHGHOYRJBZSPX0BIVPNUVH0DHCAMUUTFMZ4PEA4OMKXD43";
    parameters[@"client_secret"] = @"FFAPJNFGFQJ0VZTWG00GAEJ3HTHU1NANEXGDBTNA1IH1WIFQ";
    parameters[@"radius"] = @(100);
    parameters[@"categoryId"] = @"4d4b7105d754a06374d81259,4d4b7105d754a06376d81259";
    
    
    [self getPath:@"https://api.foursquare.com/v2/venues/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *groups = [responseObject valueForKeyPath:@"response.groups"];
        NSArray *jsonVenues = [[groups lastObject] objectForKey:@"items"];
        
        NSValueTransformer *transform = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Venue class]];
        NSArray *venues = [transform transformedValue:jsonVenues];
        if (block)
            block(venues);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];

}


@end
