//
//  ASIOauthTestController.m
//  ASIOauthTest
//
//  Created by Michael Dales on 20/04/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import "ASIOauthTestController.h"
#import "ASIOauthRequest.h"

#define SERVER @"http://172.16.235.128:1234"
#define DEFAULT_CONSUMER_KEY @"kd94hf93k423kf45"
#define DEFAULT_CONSUMER_SECRET @"dpf43f3p2l4k3l04"

@implementation ASIOauthTestController

@synthesize consumerKeyField;
@synthesize consumerSecretField;
@synthesize requestTokenField;
@synthesize requestSecretField;
@synthesize accessTokenField;
@synthesize accessSecretField;
@synthesize testReplyField;
@synthesize sigTypeButton;


#pragma mark - 
#pragma mark generic controller stuff

- (void)awakeFromNib
{
	[consumerKeyField setStringValue: DEFAULT_CONSUMER_KEY];
	[consumerSecretField setStringValue: DEFAULT_CONSUMER_SECRET];
}
	


#pragma mark -
#pragma mark Request token code

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)fetchRequestTokenDidFinish: (ASIOauthRequest*)request
{	
	[request parseReturnedToken];
	[requestTokenField setStringValue: request.returnedTokenKey];
	[requestSecretField setStringValue: request.returnedTokenSecret];
	
	[[NSWorkspace sharedWorkspace] openURL: 
	 [NSURL URLWithString: [NSString stringWithFormat: @"%@/oauth/authorize/?oauth_token=%@", SERVER,
							[requestTokenField stringValue]]]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)fetchRequestTokenDidFail: (ASIOauthRequest*)request
{
	NSError *error = request.error;
	NSLog(@"fetchRequestTokenDidFail: %@", [error localizedDescription]);
	NSLog(@"body: %@", [request responseString]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (IBAction)fetchRequestToken: (id)sender
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/oauth/request_token/", SERVER]];
	
	ASIOauthRequest *request = [[ASIOauthRequest alloc] initWithURL: url
												 forConsumerWithKey: [consumerKeyField stringValue]
														  andSecret: [consumerSecretField stringValue]];

	// get the sig type to use - order matches the enumator we use to make things simple
	ASIOauthSignatureMethod sigMethod = (ASIOauthSignatureMethod)[sigTypeButton indexOfSelectedItem];
	request.signatureMethod = sigMethod;
	
	request.didFinishSelector = @selector(fetchRequestTokenDidFinish:);
	request.didFailSelector = @selector(fetchRequestTokenDidFail:);
	request.delegate = self;
	
	[request startAsynchronous];	
}



#pragma mark -
#pragma mark Access token code


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)fetchAccessTokenDidFinish: (ASIOauthRequest*)request
{
	[request parseReturnedToken];
	[accessTokenField setStringValue: request.returnedTokenKey];
	[accessSecretField setStringValue: request.returnedTokenSecret];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)fetchAccessTokenDidFail: (ASIOauthRequest*)request
{
	NSError *error = request.error;
	NSLog(@"fetchAccessTokenDidFail: %@", [error localizedDescription]);
	NSLog(@"body: %@", [request responseString]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (IBAction)fetchAccessToken: (id)sender
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/oauth/access_token/", SERVER]];
	
	ASIOauthRequest *request = [[ASIOauthRequest alloc] initWithURL: url
												 forConsumerWithKey: [consumerKeyField stringValue]
														  andSecret: [consumerSecretField stringValue]];
	[request setTokenWithKey: [requestTokenField stringValue]
				   andSecret: [requestSecretField stringValue]];	
		
	// get the sig type to use - order matches the enumator we use to make things simple
	ASIOauthSignatureMethod sigMethod = (ASIOauthSignatureMethod)[sigTypeButton indexOfSelectedItem];
	request.signatureMethod = sigMethod;
	
	request.didFinishSelector = @selector(fetchAccessTokenDidFinish:);
	request.didFailSelector = @selector(fetchAccessTokenDidFail:);
	request.delegate = self;
	
	[request startAsynchronous];	
}

#pragma mark -
#pragma mark Test request




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)testCallDidFinish: (ASIOauthRequest*)request
{
	NSLog(@"testCallDidFinish");
	NSLog(@"body: %@", [request responseString]);
	
	[testReplyField setStringValue: [request responseString]];	
	
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (void)testCallDidFail: (ASIOauthRequest*)request
{
	NSError *error = request.error;
	NSLog(@"testCallDidFail: %@", [error localizedDescription]);
	NSLog(@"body: %@", [request responseString]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//
- (IBAction)makeTestCall: (id)sender
{
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/api/oauth/test/", SERVER]];
	
	ASIOauthRequest *request = [[ASIOauthRequest alloc] initWithURL: url
												 forConsumerWithKey: [consumerKeyField stringValue]
														  andSecret: [consumerSecretField stringValue]];
	[request setTokenWithKey: [accessTokenField stringValue]
				   andSecret: [accessSecretField stringValue]];	
	
	
	// get the sig type to use - order matches the enumator we use to make things simple
	ASIOauthSignatureMethod sigMethod = (ASIOauthSignatureMethod)[sigTypeButton indexOfSelectedItem];
	request.signatureMethod = sigMethod;
	
	
	request.didFinishSelector = @selector(testCallDidFinish:);
	request.didFailSelector = @selector(testCallDidFail:);
	request.delegate = self;
	
	[request startAsynchronous];	
}


@end
