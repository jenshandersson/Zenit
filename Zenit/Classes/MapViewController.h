//
//  MapViewController.h
//  Zenit
//
//  Created by Jens Andersson on 6/20/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <GMSMapViewDelegate> {
    GMSPolyline *_sunLine;
}

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) UIView *pin;
@property (nonatomic) GMSMarker *pinMarker;
@property (nonatomic) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)sliderChanged:(id)sender;

- (IBAction)addButtonPressed:(id)sender;
@end
