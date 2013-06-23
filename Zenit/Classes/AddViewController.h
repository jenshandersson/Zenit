//
//  AddViewController.h
//  Zenit
//
//  Created by Jens Andersson on 6/23/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceViewController.h"

@interface AddViewController : UIViewController <PlaceListDelegate>

@property (nonatomic) NSArray *places;
@property (weak, nonatomic) IBOutlet UIButton *placeButton;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)selectPlace:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
