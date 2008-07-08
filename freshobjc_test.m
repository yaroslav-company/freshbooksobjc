/*
Copyright (c) 2008, 2ndSite Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <ORGANIZATION> nor the names of its
      contributors may be used to endorse or promote products derived from this
      software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 

#import "freshobjc_test.h"
#import "FBXMLParser.h"
#import <Foundation/Foundation.h>

// This should contain #defines for FRESHBOOKS_API_TOKEN (32 hex digits) and
// FRESHBOOKS_ADDRESS (like myaccount.freshbooks.com)
#import "test_account.h"

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *pd = @"<?xml version='1.0' encoding='utf-8'?><request method='invoice.list'></request>";
	NSData *postdata = [NSData dataWithBytes:[pd UTF8String] length:[pd length]];

	// create the request
	NSMutableURLRequest *theRequest=[NSMutableURLRequest
		requestWithURL:[NSURL URLWithString:@"https://" FRESHBOOKS_API_TOKEN @":whatever@" FRESHBOOKS_ADDRESS @"/api/2.1/xml-in"]
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
		timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:postdata];
	// create the connection with the request and start loading the data
	NSURLResponse *response = NULL;
	NSError *err = NULL;
	NSData *reply=[NSURLConnection
		sendSynchronousRequest:theRequest
		returningResponse:&response
		error:&err];

	NSString *rstr = [[NSString alloc] initWithData: reply encoding: NSUTF8StringEncoding];

	NSLog(@"Response:\n"
		@" * expectedContentLength: %ld\n"
		@" * suggestedFilename: %@\n"
		@" * MIMEType: %@\n"
		@" * textEncodingName: %@ / %@\n"
		@" * URL: %@\n"
		@" * reply: \n***\n%@\n***\n",
		[response expectedContentLength],
		[response suggestedFilename],
		[response MIMEType],
		[response textEncodingName],
		[response URL],
		rstr
		);

	NSXMLParser *parser = [[FBXMLParser alloc] initWithData: reply];

	if ([parser parse])
		NSLog(@"Parsed successfully\n");
	else
		NSLog(@"Did not parse\n");

	// Something in here is corrupting the pool free in main().
	// [postdata release];
	// [theRequest release];
	// if (response) [response release];
	// if (err) [err release];
	// [reply release];
	// [rstr release];
	// [parser release];

	NSLog(@"WHEE");

	[pool release];
	return 0;
}
