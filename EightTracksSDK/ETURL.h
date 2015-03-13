//
//  ETURL.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETURL : NSObject

+(ETURL *)URLWithEndpoint:(NSString *)endpoint;
+(ETURL *)URLWithSSLEndpoint:(NSString *)endpoint;

-(void)setQueryParam:(NSString *)param toObject:(id)object;
-(NSURL *)toURL;

@end