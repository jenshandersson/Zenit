//
//  MapViewController.h
//  Zenit
//
//  Created by Jens Andersson on 6/20/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

- (IBAction)addButtonPressed:(id)sender;
@end
