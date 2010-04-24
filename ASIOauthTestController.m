//
//  ASIOauthTestController.m
//  ASIOauthTest
//
//  Created by Michael Dales on 20/04/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import "ASIOauthTestController.h"
#import "ASIOauthRequest.h"

#import <openssl/hmac.h>

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
	NSLog(@"fetchRequestTokenDidFinish");
	NSLog(@"body: %@", [request responseString]);
	
	// we now have a reply like: oauth_token_secret=CC2sL93UdYzwpQT9&oauth_token=Nw86rNQ653BnSGSw
	NSString *response = [request responseString];
	NSArray *pairs = [response componentsSeparatedByString: @"&"];
	for (NSString* pair in pairs)
	{
		NSArray* key_value_parts = [pair componentsSeparatedByString: @"="];
		if (key_value_parts.count != 2)
			continue;
		
		NSString *key = [key_value_parts objectAtIndex: 0];
		NSString *value = [key_value_parts objectAtIndex: 1];
		
		if ([key compare: @"oauth_token"] == NSOrderedSame)
			[requestTokenField setStringValue: value];
		else if ([key compare: @"oauth_token_secret"] == NSOrderedSame)
			[requestSecretField setStringValue: value];
	}
	
	
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
	NSLog(@"fetchAccessTokenDidFinish");
	NSLog(@"body: %@", [request responseString]);
	
	// we now have a reply like: oauth_token_secret=CC2sL93UdYzwpQT9&oauth_token=Nw86rNQ653BnSGSw
	NSString *response = [request responseString];
	NSArray *pairs = [response componentsSeparatedByString: @"&"];
	for (NSString* pair in pairs)
	{
		NSArray* key_value_parts = [pair componentsSeparatedByString: @"="];
		if (key_value_parts.count != 2)
			continue;
		
		NSString *key = [key_value_parts objectAtIndex: 0];
		NSString *value = [key_value_parts objectAtIndex: 1];
		
		if ([key compare: @"oauth_token"] == NSOrderedSame)
			[accessTokenField setStringValue: value];
		else if ([key compare: @"oauth_token_secret"] == NSOrderedSame)
			[accessSecretField setStringValue: value];
	}
	
	
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
	
	request.didFinishSelector = @selector(testCallDidFinish:);
	request.didFailSelector = @selector(testCallDidFail:);
	request.delegate = self;
	
	[request startAsynchronous];	
}


@end
