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

- (IBAction)selectPlace:(id)sender;

@end
