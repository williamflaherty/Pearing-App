//
//  BrowseMatchesViewController.h
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PearingClient.h"

@interface BrowseMatchesViewController : UITableViewController 

@property (nonatomic) PearingClient *pearingClient;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@end
