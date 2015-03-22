//
//  ETUser.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETUser.h"
#import "ETSmartID.h"
#import <Mantle/Mantle.h>
#import "ETMixSet.h"
#import "ETRequest.h"

@interface ETUser ()
@end

@implementation ETUser

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"webPath":@"web_path",
             @"followsCount":@"follows_count",
             @"followersCount":@"followers_count",
             @"likedMixesCount":@"liked_mixes_count",
             @"publicMixesCount":@"public_mixes_count",
             @"favoritesCount":@"favorites_count",
             @"memberSince":@"member_since",
             @"topTags":@"top_tags",
             @"recentMixes":@"recent_mixes",
             @"avatar":@"avatar_urls",
             @"followedBySessionUser":@"followed_by_current_user",
             };
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"avatar"]) {
        return [self avatarJSONValueTransformer];
    } else if ([key isEqualToString:@"presetSmartIDs"]) {
        return [self presetSmartIDsValueTransformer];
    } else if ([key isEqualToString:@"collections"]) {
        return [self collectionJSONValueTransformer];
    } else if ([key isEqualToString:@"topTags"]) {
    } else if ([key isEqualTo:@"recentMixes"]) {
        return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[ETMix class]];
    }
    return nil;
}

+(NSValueTransformer *)avatarJSONValueTransformer {
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ETUserAvatar class]];
}

+(NSValueTransformer *)collectionJSONValueTransformer {
    return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:[ETMixSet class]];
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

-(void)updateProperties:(NSString *)includes
     session:(ETSession *)session
    complete:(ETRequestCompletion)handler
{
    NSString *endpoint = [NSString stringWithFormat:@"/users/%@", self.id.stringValue];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"include" toObject:includes];
    ETRequest *request;
    request = [[ETRequest alloc]
               initWithURL:url
               andSession:session
               complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithJSON:result[@"user"]];
        }
        handler(err, result);
    }];
    [request send];
}

- (void)updateWithJSON:(NSDictionary*)json
{
    id model = [MTLJSONAdapter modelOfClass:[self class]
                         fromJSONDictionary:json
                                      error:nil];
    [self mergeValuesForKeysFromModel:model];
}

+(NSString *)includesToString:(ETUserIncludes)includes {
    NSMutableArray *array = [NSMutableArray new];
    if (includes & ETUserIncludesFollowed) {
        [array addObject:@"followed"];
    }
    if (includes & ETUserIncludesCollections) {
        [array addObject:@"collections"];
    }
    if (includes & ETUserIncludesLocation) {
        [array addObject:@"location"];
    }
    if (includes & ETUserIncludesLocationSummary) {
        [array addObject:@"location_summary"];
    }
    if (includes & ETUserIncludesPresets) {
        [array addObject:@"presets"];
    }
    if (includes & ETUserIncludesProfile) {
        [array addObject:@"profile"];
    }
    if (includes & ETUserIncludesProfileCounts) {
        [array addObject:@"profile_counts"];
    }
    if (includes & ETUserIncludesRecentMixes) {
        [array addObject:@"recent_mixes"];
    }
    if (includes & ETUserIncludesTimeLine) {
        [array addObject:@"timeline"];
    }
    if (includes & ETUserIncludesTopTags) {
        [array addObject:@"top_tags"];
    }
    if (includes & ETUserIncludesWebPreferences) {
        [array addObject:@"web_preferences"];
    }
    return [array componentsJoinedByString:@","];
}

-(BOOL)isEqualTo:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToUser:object];
}

-(BOOL)isEqualToUser:(ETUser *)object {
    return [self.id isEqualTo:object.id];
}

@end
