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
#import <Foundation/Foundation.h>

@interface geturl : NSObject
{
}
@end

@implementation geturl
- (id)init
{
	if(self = [super init])
	{
	}
	return self;
}
- (NSString*)dorequest
{
	// create the request
	NSURLRequest *theRequest=[NSURLRequest
		requestWithURL:[NSURL URLWithString:@"https://API_TOKEN:whatever@YOURSYSTEM.freshbooks.com/api/2.1/xml-in"]
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
		timeoutInterval:60.0];
	// create the connection with the request and start loading the data
	NSURLResponse *response = [[NSURLResponse alloc] init];
	NSError *err = [[NSError alloc] init];
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
		@" * reply: %@\n",
		[response expectedContentLength],
		[response suggestedFilename],
		[response MIMEType],
		[response textEncodingName],
		[response URL],
		rstr
		);

	return @"Whee!";
}
@end


int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];

	NSLog([[[geturl alloc] init] dorequest]);

	[pool release];
	return 0;
}