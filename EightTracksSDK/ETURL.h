//
//  ETURL.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETURLQueryParam.h"

@interface ETURL : NSObject

+(ETURL *)URLWithEndpoint:(NSString *)endpoint;
+(ETURL *)URLWithSSLEndpoint:(NSString *)endpoint;

-(void)setQueryParam:(id<ETURLQueryParam>)param;
-(void)setQueryParam:(NSString *)param toObject:(id)object;
-(void)setQueryParams:(NSDictionary *)dictionary;
-(NSURL *)toURL;

@end