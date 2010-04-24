//
//  ASIOauthRequest.h
//  ASIOauthTest
//
//  Created by Michael Dales on 22/04/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIFormDataRequest.h"

typedef enum _ASIOAuthSignatureMethod {
	ASIPlaintextOAuthSignatureMethod = 0,
	ASIHMAC_SHA1OAuthSignatureMethod = 1
} ASIOauthSignatureMethod;

@interface ASIOauthRequest : ASIFormDataRequest 
{
	// Consumer key/secret
	NSString *consumerKey;
	NSString *consumerSecret;
	
	// Either a request or access token
	NSString *tokenKey;
	NSString *tokenSecret;
	
	// signature method used
	ASIOauthSignatureMethod signatureMethod;
}

- (id)initWithURL: (NSURL*)desturl forConsumerWithKey: (NSString*)key andSecret: (NSString*)secret;
- (void)setTokenWithKey: (NSString*)key andSecret: (NSString*)secret;

@property (retain) NSString *consumerKey;
@property (retain) NSString *consumerSecret;

@property (readonly) NSString *tokenKey;
@property (readonly) NSString *tokenSecret;

@property (assign) ASIOauthSignatureMethod signatureMethod;
@end
