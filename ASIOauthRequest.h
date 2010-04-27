//
//  ASIOauthRequest.h
//  ASIOauthTest
//
//  Created by Michael Dales on 22/04/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

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
	
	// Token or secret returned by the server, if found
	NSString *returnedTokenKey;
	NSString *returnedTokenSecret;
	
	// signature method used
	ASIOauthSignatureMethod signatureMethod;
}

- (id)initWithURL: (NSURL*)desturl forConsumerWithKey: (NSString*)key andSecret: (NSString*)secret;
- (void)setTokenWithKey: (NSString*)key andSecret: (NSString*)secret;
- (void)parseReturnedToken;

@property (retain) NSString *consumerKey;
@property (retain) NSString *consumerSecret;

@property (readonly) NSString *tokenKey;
@property (readonly) NSString *tokenSecret;

@property (readonly) NSString *returnedTokenKey;
@property (readonly) NSString *returnedTokenSecret;

@property (assign) ASIOauthSignatureMethod signatureMethod;
@end
