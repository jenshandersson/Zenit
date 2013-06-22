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
#import "Place.h"

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
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude zoom:14];
        [self.mapView setCamera:camera];
    };
    self.mapView.myLocationEnabled = YES;
    
}

- (void)fetchPlaces {
    [[PlacesApiClient sharedClient] getNearByPlaces:^(AFHTTPRequestOperation *operation, NSArray *places) {
        for (Place *place in places) {
            place.marker.map = self.mapView;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(fetchPlaces) withObject:nil afterDelay:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
