//
//  ETUser.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETUser.h"

@implementation ETUser

-(ETUser *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self && dict) {
        _id = dict[@"id"];
        _login = dict[@"login"];
        _path = dict[@"path"];
        _webPath = dict[@"web_path"];
        _bio = dict[@"bio"];
        _followsCount = dict[@"follows_count"];
        _avatar = dict[@"avatar_urls"];
        _location = dict[@"location"];
        _subscribed = [(NSNumber *)dict[@"subscribed"] boolValue];
        _followedBySessionUser = [(NSNumber *)dict[@"followed_by_session_user"] boolValue];
    }
    return self;
}

@end
