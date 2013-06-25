//
//  AddViewController.m
//  Zenit
//
//  Created by Jens Andersson on 6/23/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "AddViewController.h"
#import "PlaceViewController.h"
#import "ZenitAPIClient.h"
#import "Venue.h"
#import "JASolarPosition.h"

@interface AddViewController ()

@end



@implementation AddViewController

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
    [[ZenitAPIClient sharedClient] closeVenues:^(NSArray *venues) {
        self.places = venues.copy;
        Venue *closest = self.places[0];
        [self.placeButton setTitle:closest.name forState:UIControlStateNormal];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)viewWillAppear:(BOOL)animated {
    self.timeSlider.value = [JASolarPosition timeAsFloat:[NSDate date]];
    self.timeLabel.text = [JASolarPosition dateStringFromFloat:self.timeSlider.value];
}


- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPlace:(id)sender {
    PlaceViewController *placeVC = [[PlaceViewController alloc] init];
    placeVC.places = self.places;
    placeVC.delegate = self;
    [self presentViewController:placeVC animated:YES completion:nil];
}

- (IBAction)sliderChanged:(id)sender {
    self.timeLabel.text = [JASolarPosition dateStringFromFloat:self.timeSlider.value];
}

- (void)venueWasSelected:(Venue *)venue {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.placeButton setTitle:venue.name forState:UIControlStateNormal];
}


@end
