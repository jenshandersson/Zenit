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
        self.currentDate = [NSDate date];
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
            
            [self updatePinFromCoordinate:newLocation.coordinate];
            [self fetchPlaces];
            [self.mapView setCamera:camera];
            [self updateMapDrawings];
        });
    };
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchPlaces)];
    
    
    self.pin = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
    self.pin.layer.cornerRadius = 10;
    self.pin.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.pin];
    [self.pin addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)]];
    
    self.pinMarker = [[GMSMarker alloc] init];
}

- (void)tapped:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self.view];
    CLLocationCoordinate2D coordinate = [self.mapView.projection coordinateForPoint:point];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self drawSunLineAt:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.pin.center = point;
        [self updatePinFromCoordinate:coordinate];
    }
}


- (void)updatePinFromCoordinate:(CLLocationCoordinate2D)coordinate {
    self.pinMarker.position = coordinate;
    self.pinMarker.map = self.mapView;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    CGPoint p = [mapView.projection pointForCoordinate:self.pinMarker.position];
    self.pin.center = p;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self updatePinFromCoordinate:coordinate];
    [self drawSunLineAt:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
}

- (void)drawSunLineAt:(CLLocation *)location {
    CLLocation *sun = [MapViewController sunLocationFromObserver:location atDate:self.currentDate];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:sun.coordinate];
    [path addCoordinate:location.coordinate];
    _sunLine.path = path;
    
    _sunLine.map = self.mapView;

}

- (void)updateMapDrawings {
    CLLocation *newLocation = [LocationManager shared].currentLocation;
    
    [self drawSunLineAt:newLocation];
}

- (void)fetchPlaces {
    [self.mapView animateToBearing:0];
    
    /*
    [[ZenitAPIClient sharedClient] closeVenues:^(NSArray *venues) {
        for (Venue *venue in venues) {
            venue.marker.map = self.mapView;
        }
    }];
     */
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat p = [JASolarPosition timeAsFloat:[NSDate date]];
    self.slider.value = p;
    self.timeLabel.text = [JASolarPosition dateStringFromFloat:p];
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.currentDate = [JASolarPosition dateFromFloat:slider.value];
    self.timeLabel.text = [JASolarPosition dateStringFromFloat:slider.value];
    CLLocationCoordinate2D coordinate = self.pinMarker.position;
    [self drawSunLineAt:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]];
}

- (IBAction)addButtonPressed:(id)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:navCon animated:YES completion:nil];
}

+ (CLLocation *)sunLocationFromObserver:(CLLocation *)observer atDate:(NSDate *)date {
    static CLLocationDistance radiusInMeter = 10000;
    
    spa_data spa = [JASolarPosition azimuthAtLocation:observer andDate:date];
    
    CLLocationDegrees azimuth = spa.azimuth;
    
    CGFloat altitude = deg2rad(spa.incidence);
    
    CLLocation *l = [observer locationAtDistance:radiusInMeter andBearing:azimuth];
    
    CLLocationDistance altitudeInMeters = sin(altitude) * radiusInMeter;
    
    
    CLLocation *sunLocation = [[CLLocation alloc] initWithCoordinate:l.coordinate altitude:altitudeInMeters horizontalAccuracy:1 verticalAccuracy:1 timestamp:[NSDate date]];
    
    return sunLocation;
}
@end
