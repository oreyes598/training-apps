//
//  DataManager.m
//  QuakeKit
//
//  Created by Reyes, Oliver on 7/13/15.
//  Copyright (c) 2015 Reyes, Oliver. All rights reserved.
//

#import "DataManager.h"
#import "Quake.h"
#import "QuakeLocation.h"
#import "QuakeLink.h"

#define kURLString @"http://earthquake-report.com/feeds/recent-eq?json"

@interface DataManager()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataManager

- (void)updateData {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURL *url = [[NSURL alloc] initWithString:kURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data.length > 0 && error == nil) {
            
            NSError *jsonError;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
            
            if ([json isKindOfClass:[NSArray class]]) {

                NSArray *jsonArray = (NSArray *)json;
                if ([jsonArray count] > 0 && jsonError == nil) {

                    // Success service request
                    NSLog(@"Response Data: %@", jsonArray);
                    [self storeResponse:jsonArray];
                }
                else {
                    NSLog(@"Json Error: %@, %@", jsonError, [jsonError localizedDescription]);
                }
                
                
            }
            else if ([json isKindOfClass:[NSDictionary class]]) {
                // TODO:
            }
            else {
                // TODO:
            }
            
            
        } else {
            NSLog(@"Error: %@, %@", error, [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)storeResponse:(NSArray *)response {

    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssvvvv"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    for (NSDictionary *element in response) {
        Quake *quake = [NSEntityDescription insertNewObjectForEntityForName:@"Quake" inManagedObjectContext:moc];
        quake.quakeTitle = element[@"title"];
        quake.quakeMagnitude = @([element[@"magnitude"] floatValue]);
        quake.quakeDepth = @([element[@"depth"] floatValue]);
        quake.quakePlace = element[@"location"];
        
        // 2015-07-13T21:28:10+00:00
        NSString *dateString = element[@"date_time"];
        quake.quakeDate = [formatter dateFromString:dateString];
        
        QuakeLocation *quakeLocation = [NSEntityDescription insertNewObjectForEntityForName:@"QuakeLocation" inManagedObjectContext:moc];
        quakeLocation.quakeLatitude = @([element[@"latitude"] doubleValue]);
        quakeLocation.quakeLongitude = @([element[@"longitude"] doubleValue]);
        
        QuakeLink *quakeLink = [NSEntityDescription insertNewObjectForEntityForName:@"QuakeLink" inManagedObjectContext:moc];
        quakeLink.quakeLink = element[@"link"];
        
        quake.quakeLocation = quakeLocation;
        quakeLocation.quakeLink = quakeLink;
    }
    
    NSError *mocError;
    if (![moc save:&mocError]) {
        NSLog(@"ManagedObjectContext save error: %@, %@", mocError, [mocError localizedDescription]);
    }
}


- (NSArray *)fetchData {
    return nil;
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.paypal.ios.sample.PersistenceApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[DataManager class]];
    NSURL *modelURL = [bundle URLForResource:@"QuakeKit" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QuakeKit.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
