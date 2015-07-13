//
//  QuakeLink.h
//  QuakeKit
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuakeLocation;

@interface QuakeLink : NSManagedObject

@property (nonatomic, retain) NSString * quakeLink;
@property (nonatomic, retain) QuakeLocation *quakeLocation;

@end
