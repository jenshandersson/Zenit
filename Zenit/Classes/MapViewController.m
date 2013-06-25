//
//  MapViewController.m
//  Zenit
//
//  Created by Jens Andersson on 6/20/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "MapViewController.h"
#import "LocationManager.h"
#import "PlacesApiClient.h"
#import "ZenitAPIClient.h"
#import "Place.h"
#import "Venue.h"
#import "WeatherData.h"
#import "AddViewController.h"
#import "CLLocation+LocationExtensions.h"
#import "JASolarPosition.h"

#define deg2rad(degrees) (degrees * 0.01745327)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sunLine = [[GMSPolyline alloc] init];
        _sunLine.strokeColor = UIColorFromRGB(0xFFE545);
        _sunLine.strokeWidth = 3;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [LocationManager shared].updateBlock = ^(CLLocation *newLocation) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude zoom:16];
            
            [self fetchPlaces];
            [self.mapView setCamera:camera];
            [self updateMapDrawings];
        });
    };
    self.mapView.myLocationEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchPlaces)];
    
}

- (void)updateMapDrawings {
    CLLocation *newLocation = [LocationManager shared].currentLocation;
    
    
    CLLocation *sun = [MapViewController sunLocationFromObserver:newLocation];
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:sun.coordinate];
    [path addCoordinate:newLocation.coordinate];
    _sunLine.path = path;
    
    _sunLine.map = self.mapView;
}

- (void)fetchPlaces {
    [self.mapView animateToBearing:0];
    
    [[ZenitAPIClient sharedClient] closeVenues:^(NSArray *venues) {
        for (Venue *venue in venues) {
            venue.marker.map = self.mapView;
        }
    }];
    
    [[ZenitAPIClient sharedClient] currentWeatherData:^(WeatherData *weather) {
        self.title = [NSString stringWithFormat:@"Cloudiness: %d%%", weather.clouds.integerValue];
        UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithTitle:weather.tempString style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.leftBarButtonItem = tempButton;
    }];
    [self updateMapDrawings];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(id)sender {
    [self updateMapDrawings];
}

- (IBAction)addButtonPressed:(id)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:navCon animated:YES completion:nil];
}

+ (CLLocation *)sunLocationFromObserver:(CLLocation *)observer {
    static CLLocationDistance radiusInMeter = 10000;
    
    spa_data spa = [JASolarPosition azimuthAtLocation:observer andDate:[NSDate date]];
    
    CLLocationDegrees azimuth = spa.azimuth;
    
    CGFloat altitude = deg2rad(spa.incidence);
    
    CLLocation *l = [observer locationAtDistance:radiusInMeter andBearing:azimuth];
    
    CLLocationDistance altitudeInMeters = sin(altitude) * radiusInMeter;
    
    
    CLLocation *sunLocation = [[CLLocation alloc] initWithCoordinate:l.coordinate altitude:altitudeInMeters horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
    
    return sunLocation;
}
@end
