//
//  ASIOauthTestController.h
//  ASIOauthTest
//
//  Created by Michael Dales on 20/04/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ASIOauthTestController : NSObject 
{
	NSTextField *consumerKeyField;
	NSTextField *consumerSecretField;
	
	NSTextField *requestTokenField;
	NSTextField *requestSecretField;
	
	NSTextField *accessTokenField;
	NSTextField *accessSecretField;
	
	NSTextField *testReplyField;
	
	NSPopUpButton *sigTypeButton;
	
}
@property (nonatomic, retain) IBOutlet NSTextField *consumerKeyField;
@property (nonatomic, retain) IBOutlet NSTextField *consumerSecretField;
@property (nonatomic, retain) IBOutlet NSTextField *requestTokenField;
@property (nonatomic, retain) IBOutlet NSTextField *requestSecretField;
@property (nonatomic, retain) IBOutlet NSTextField *accessTokenField;
@property (nonatomic, retain) IBOutlet NSTextField *accessSecretField;
@property (nonatomic, retain) IBOutlet NSTextField *testReplyField;
@property (nonatomic, retain) IBOutlet NSPopUpButton *sigTypeButton;

- (IBAction)fetchRequestToken: (id)sender;
- (IBAction)fetchAccessToken: (id)sender;
- (IBAction)makeTestCall: (id)sender;

@end
