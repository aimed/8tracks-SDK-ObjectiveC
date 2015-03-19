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
- (BOOL)updateWithJSON:(NSDictionary*)json error:(NSError**)error;
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

-(void)fetch:(ETUserIncludes)includes
     session:(ETSession *)session
    complete:(ETRequestCompletion)handler
{
    NSString *endpoint = [NSString stringWithFormat:@"/users/%@", self.id.stringValue];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"include" toObject:[ETUser includesToString:includes]];
    ETRequest *request;
    request = [[ETRequest alloc]
               initWithURL:url
               andSession:session
               complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithJSON:result[@"user"] error:nil];
        }
        handler(err, result);
    }];
    [request send];
}

- (BOOL)updateWithJSON:(NSDictionary*)json error:(NSError**)error
{
    // create a temporary object then merge it by its JSON keys
    ETUser *model = [MTLJSONAdapter modelOfClass:[self class]
                                     fromJSONDictionary:json
                                                  error:error];
    if (error != nil) {
        return NO;
    }
    
    NSArray *keysOfJSONProperties = [[[self class] JSONKeyPathsByPropertyKey] allKeys];
    for (id key in keysOfJSONProperties)
    {
        [self mergeValueForKey:key fromModel: model];
    }
    return YES;
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

@end
