//
//  MapViewController.h
//  Zenit
//
//  Created by Jens Andersson on 6/20/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController {
    GMSPolyline *_sunLine;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)sliderChanged:(id)sender;

- (IBAction)addButtonPressed:(id)sender;
@end
