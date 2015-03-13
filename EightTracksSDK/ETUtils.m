//
//  ETUtils.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETUtils.h"

NSString *const kURLComponentsSeparator = @"&";

@implementation ETUtils

/* Credits to http://stackoverflow.com/questions/2590545/urlencoding-a-string-with-objective-c */
+(NSString *)URLEncodeWithString:(NSString*)string
{
	CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
																	NULL,
																	(CFStringRef)string,
																	NULL,
																	(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
	return (NSString *)CFBridgingRelease(urlString);
}

+(NSString *)serializeDictionary:(NSDictionary *)dict {
	
	NSMutableArray *components = [NSMutableArray new];
	
	for (NSString *key in dict) {
		@autoreleasepool {
			NSString *item = [dict objectForKey:key];
			NSString *encodedItem = [self URLEncodeWithString:(NSString *)item];
			NSString *formated =[NSString stringWithFormat:@"%@=%@", key, encodedItem];
			[components addObject:formated];
		}
	}
	
	return [components componentsJoinedByString:kURLComponentsSeparator];
}


@end
