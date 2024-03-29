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
#import <Foundation/Foundation.h>

typedef enum FBXMLParser_Type {
	FBXMLParser_Type_DICTIONARY,
	FBXMLParser_Type_ARRAY
} FBXMLParser_Type;

typedef enum FBXMLParser_Phase {
	FBXMLParser_Phase_NOWHERE,
	FBXMLParser_Phase_RESPONSE,
	FBXMLParser_Phase_CLIENT,
	FBXMLParser_Phase_CLIENT_ID,
	FBXMLParser_Phase_CLIENT_USERNAME,
	FBXMLParser_Phase_CLIENT_FIRST_NAME,
	FBXMLParser_Phase_CLIENT_LAST_NAME,
	FBXMLParser_Phase_CLIENT_ORGANIZATION,
	FBXMLParser_Phase_CLIENT_EMAIL,
	FBXMLParser_Phase_STATUS_FAIL,
	FBXMLParser_Phase_BAD
} FBXMLParser_Phase;

@interface FBXMLParser : NSObject
{
	NSXMLParser *xp;
	FBXMLParser_Phase currentPhase;
	NSDictionary *FBDefs;
}
- (id)initWithData:(NSData *)data;
- (BOOL)parse;
@end
