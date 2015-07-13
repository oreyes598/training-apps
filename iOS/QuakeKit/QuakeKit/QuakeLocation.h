//
//  QuakeLocation.h
//  QuakeKit
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quake, QuakeLink;

@interface QuakeLocation : NSManagedObject

@property (nonatomic, retain) NSNumber * quakeLatitude;
@property (nonatomic, retain) NSNumber * quakeLongitude;
@property (nonatomic, retain) Quake *quake;
@property (nonatomic, retain) QuakeLink *quakeLink;

@end
