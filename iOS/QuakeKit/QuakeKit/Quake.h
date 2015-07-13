//
//  Quake.h
//  QuakeKit
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuakeLocation;

@interface Quake : NSManagedObject

@property (nonatomic, retain) NSString * quakeTitle;
@property (nonatomic, retain) NSNumber * quakeMagnitude;
@property (nonatomic, retain) NSString * quakePlace;
@property (nonatomic, retain) NSNumber * quakeDepth;
@property (nonatomic, retain) NSDate * quakeDate;
@property (nonatomic, retain) QuakeLocation *quakeLocation;

@end
