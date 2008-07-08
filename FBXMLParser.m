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

// All FreshBooks XML responses were originally derived from a simple nested array.
// I don't see a reason that we shouldn't return the favour, using NSArrays and NSDictionaries.
// We _do_ need to know what kinds of things should be arrays, because ... we don't!
// As we walk the stack, we read tags.  If a tag contains other tags, ... ok.  Fine.
// I'm not convinced that we have to, but it will make life a lot easier for this stream parser
// if I know when I hit a tag "Oh, this should be an array" or "Oh, this should be a dictionary".
// "response" is the root element.
	// "clients" => array of its children
	// "client" => dictionary of its children
// OR
	// "invoices" => array of its children
	// "invoice" => dictionary of its children
// OR
	// "invoice" => dictionary of its children
	// "lines" => array of its children
	// "line" => dictionary of its children
// etc

#import "FBXMLParser.h"

@implementation FBXMLParser


- (id)initWithData:(NSData *)data
{
	if (self = [super init])
	{
		xp = [[NSXMLParser alloc] initWithData: data];
		[xp setDelegate: self];
		currentPhase = FBXMLParser_Phase_NOWHERE;
	}
	return self;
}

- (void)parser:(NSXMLParser *)parser 
	didEndElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qName
{
#if DEBUG
	NSLog(@"FBXMLParser leaving element: %@", elementName);
#endif

	switch (currentPhase) {
	case FBXMLParser_Phase_CLIENT:
		if (NSOrderedSame == [elementName compare:@"client"]) {
			NSLog(@"End of client record");
			currentPhase = FBXMLParser_Phase_RESPONSE;
		}
		break;
	case FBXMLParser_Phase_RESPONSE:
		if (NSOrderedSame == [elementName compare:@"response"]) {
			NSLog(@"End of response");
			currentPhase = FBXMLParser_Phase_NOWHERE;
		}
	}
}

- (void)parser:(NSXMLParser *)parser 
	didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{
#if DEBUG
	NSLog(@"FBXMLParser found element: %@\n", elementName);
#endif

	switch (currentPhase) {
	case FBXMLParser_Phase_NOWHERE:
		if (NSOrderedSame == [elementName compare:@"response"]) {
			if (NSOrderedSame != [[attributeDict valueForKey:@"status"] compare:@"ok"]) {
				NSLog(@"Status Failed: '%@'", [attributeDict valueForKey:@"status"]);
				currentPhase = FBXMLParser_Phase_STATUS_FAIL;
			} else {
				NSLog(@"Status Succeeded", [attributeDict valueForKey:@"status"]);
				currentPhase = FBXMLParser_Phase_RESPONSE;
			}
		}
		break;
	case FBXMLParser_Phase_RESPONSE:
		if (NSOrderedSame == [elementName compare:@"client"]) {
			NSLog(@"Found client record");
			currentPhase = FBXMLParser_Phase_CLIENT;
		}
		break;
	}
}

- (BOOL)parse
{
	return [xp parse];
}

@end
