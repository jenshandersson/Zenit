//
//  PlaceViewController.m
//  Zenit
//
//  Created by Jens Andersson on 6/23/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import "PlaceViewController.h"
#import "ZenitAPIClient.h"
#import "Venue.h"
#import <KoaPullToRefresh.h>
@interface PlaceViewController ()

@end

@implementation PlaceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPlaces];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchPlaces];
    } withBackgroundColor:[UIColor colorWithRed:65/255.0 green:131/255.0 blue:196/255.0 alpha:1]];
}

- (void)fetchPlaces {
    [[ZenitAPIClient sharedClient] closeVenues:^(NSArray *venues) {
        self.places = venues.copy;
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    Venue *venue = self.places[indexPath.row];
    
    cell.textLabel.text = venue.name;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = self.places[indexPath.row];
    [self.delegate venueWasSelected:venue];
}

@end
