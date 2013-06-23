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

@interface AddViewController ()

@end

static NSInteger minHour = 8;
static NSInteger maxHour = 22;

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
    self.timeSlider.value = [self timeAsFloat:[NSDate date]];
    self.timeLabel.text = [self dateFromFloat:self.timeSlider.value];
}

- (CGFloat)timeAsFloat:(NSDate *)date {
    NSInteger interval = (maxHour - minHour) * 60;
    NSDateComponents *componens = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    NSInteger minutes = (componens.hour - minHour) * 60 + componens.minute;
    CGFloat percent = 1.0f * minutes / interval;
    return percent;
}

- (NSString *)dateFromFloat:(CGFloat)percent {
    NSInteger interval = (maxHour - minHour) * 60;
    NSInteger allMinutes = interval * percent;
    NSInteger hour = allMinutes / 60;
    NSInteger minute = allMinutes - 60 * hour;
    
    NSString *hourString = [self timeStringWithInt:(minHour + hour)];
    NSString *minuteString = [self timeStringWithInt:minute];
    return [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
    
}

- (NSString *)timeStringWithInt:(NSInteger)number {
    NSString * s = [NSString stringWithFormat:@"%d", number];
    NSString *prefix = @"";
    if (s.length == 0)
        prefix = @"00";
    else if (s.length == 1)
        prefix = @"0";
    return [prefix stringByAppendingString:s];
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
    self.timeLabel.text = [self dateFromFloat:self.timeSlider.value];
}

- (void)venueWasSelected:(Venue *)venue {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.placeButton setTitle:venue.name forState:UIControlStateNormal];
}


@end
