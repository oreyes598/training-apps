//
//  DataManager.h
//  QuakeKit
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

/**
 * Initiates service request to get data
 * and store data to persistence storage
 */
- (void)updateData;

/**
 * Retrieve data from persistence storage 
 */
- (NSArray *)fetchData;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
