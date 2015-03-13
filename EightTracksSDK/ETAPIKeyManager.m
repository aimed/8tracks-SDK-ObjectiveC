//
//  ETAPIKeyManager.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETAPIKeyManager.h"

static NSString *_APIKey;
NSString *const ETAPIKeyDictKey = @"8tracks_api_key";

@implementation ETAPIKeyManager

+(void)setAPIKey:(NSString *)key {
    if (key != nil) {
        _APIKey = key;
    }
}

+(NSString *)APIKey {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_APIKey) {
            _APIKey = [[NSUserDefaults standardUserDefaults] objectForKey:ETAPIKeyDictKey];
        }
        assert(_APIKey != nil);
    });
    return _APIKey;
}

@end
