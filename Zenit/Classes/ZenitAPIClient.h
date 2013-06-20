#import "AFHTTPClient.h"

@interface ZenitAPIClient : AFHTTPClient

+ (ZenitAPIClient *)sharedClient;

@end
