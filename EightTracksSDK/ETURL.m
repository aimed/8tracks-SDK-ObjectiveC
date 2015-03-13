//
//  ETURL.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETURL.h"
#import "ETUtils.h"

NSString *const kAPIVersion = @"3";

NSURL *kURI;
NSURL *kURISSL;


@interface ETURL ()

@property (strong, nonatomic) NSString *endpoint;
@property (nonatomic) BOOL useSSL;
@property (nonatomic, strong, readwrite) NSMutableDictionary *data;

@end

@implementation ETURL

+(void)initialize {
    // set the base urls
    kURI = [NSURL URLWithString:@"http://8tracks.com"];
    kURISSL = [NSURL URLWithString:@"https://8tracks.com"];
}

+(ETURL *)URLWithEndpoint:(NSString *)endpoint {
    ETURL *url = [ETURL new];
    url.endpoint = endpoint;
    url.useSSL = NO;
    return url;
}

+(ETURL *)URLWithSSLEndpoint:(NSString *)endpoint {
    ETURL *url = [self URLWithEndpoint:endpoint];
    url.useSSL = YES;
    return url;
}

-(void)setQueryParam:(NSString *)param toObject:(id)object {
    if (_data == nil) {
        _data = [NSMutableDictionary new];
    }
    [_data setObject:object forKey:param];
}

-(NSURL *)toURL {
    NSString *data = [ETUtils serializeDictionary:_data];
    NSString *endpoint = [NSString stringWithFormat:@"%@.json?api_version=%@&%@", _endpoint, kAPIVersion, data];
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:_useSSL ? kURISSL : kURI];
    return url;
}

@end
