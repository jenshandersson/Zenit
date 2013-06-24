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

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [LocationManager shared].updateBlock = ^(CLLocation *newLocation) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude zoom:16];
        
        
        [self fetchPlaces];
        [self.mapView setCamera:camera];
    };
    self.mapView.myLocationEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchPlaces)];
    
}

- (void)fetchPlaces {
    [[PlacesApiClient sharedClient] getNearByPlaces:^(AFHTTPRequestOperation *operation, NSArray *places) {
        for (Place *place in places) {
            place.marker.map = self.mapView;
        }
    }];
    
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(id)sender {
    AddViewController *addVC = [[AddViewController alloc] init];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:navCon animated:YES completion:nil];
}
@end
