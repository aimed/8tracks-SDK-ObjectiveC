//
//  ETUser.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETUser.h"
#import <Mantle.h>

@implementation ETUser

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"webPath":@"web_path",
             @"followsCount":@"follows_count",
             @"avatar":@"avatar_urls",
             @"followedBySessionUser":@"followed_by_current_user"
             };
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"avatar"]) {
        return [self avatarJSONValueTransformer];
    }
    return nil;
}

+(NSValueTransformer *)avatarJSONValueTransformer {
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ETUserAvatar class]];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    //_avatar = [MTLJSONAdapter modelOfClass:[ETUserAvatar class] fromJSONDictionary:dictionaryValue[@"avatar_urls"] error:nil];
    return self;
}

-(ETUser *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self && dict) {
        _id = dict[@"id"];
        _login = dict[@"login"];
        _path = dict[@"path"];
        _webPath = dict[@"web_path"];
        _bio = dict[@"bio"];
        _followsCount = dict[@"follows_count"];
        _avatar = [MTLJSONAdapter modelOfClass:ETUserAvatar.class fromJSONDictionary:dict[@"avatar_urls"] error:nil];//dict[@"avatar_urls"];
        _location = dict[@"location"];
        _subscribed = [(NSNumber *)dict[@"subscribed"] boolValue];
        _followedBySessionUser = [(NSNumber *)dict[@"followed_by_current_user"] boolValue];
    }
    return self;
}

@end
