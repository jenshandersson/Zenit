//
//  PlaceViewController.h
//  Zenit
//
//  Created by Jens Andersson on 6/23/13.
//  Copyright (c) 2013 Jens Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Venue;

@protocol PlaceListDelegate <NSObject>

- (void)venueWasSelected:(Venue *)venue;

@end

@interface PlaceViewController : UITableViewController

@property (nonatomic) NSArray *places;
@property (nonatomic, weak) id<PlaceListDelegate> delegate;

@end
