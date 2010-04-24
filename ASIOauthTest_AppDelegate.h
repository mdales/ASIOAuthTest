//
//  ASIOauthTest_AppDelegate.h
//  ASIOauthTest
//
//  Created by Michael Dales on 20/04/2010.
//  Copyright Michael Dales 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASIOauthTest_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;

@end
