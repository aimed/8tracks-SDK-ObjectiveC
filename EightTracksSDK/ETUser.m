//
//  ETUser.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETUser.h"
#import "ETSmartID.h"
#import <Mantle.h>

@implementation ETUser

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"webPath":@"web_path",
             @"followsCount":@"follows_count",
             @"avatar":@"avatar_urls",
             @"followedBySessionUser":@"followed_by_current_user",
             @"presetSmartIDs":@"preset_smart_ids"
             };
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"avatar"]) {
        return [self avatarJSONValueTransformer];
    } else if ([key isEqualToString:@"presetSmartIDs"]) {
        return [self presetSmartIDsValueTransformer];
    }
    return nil;
}

+(NSValueTransformer *)avatarJSONValueTransformer {
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ETUserAvatar class]];
}

+(NSDictionary *)encodingBehaviorsByPropertyKey {
    return @{
             @"presetSmartIDs":[NSNumber numberWithInt:MTLModelEncodingBehaviorExcluded]
             };
}

+(NSValueTransformer *)presetSmartIDsValueTransformer {
    return [MTLValueTransformer transformerWithBlock:^NSArray *(NSArray *presets) {
        NSMutableArray *smartIDs = [NSMutableArray new];
        for (NSString *smartIDString in presets)
        {
            [smartIDs addObject:[ETSmartID smartIDFromString:smartIDString]];
        }
        return smartIDs;
    }];
}

@end
