//
//  ViewController.h
//  EarthquakeApp
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuakeKit/QuakeKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

