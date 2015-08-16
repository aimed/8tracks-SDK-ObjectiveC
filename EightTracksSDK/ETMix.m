//
//  ETMix.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETMix.h"
#import "ETUser.h"
#import "ETRequest.h"
#import "ETSmartID.h"
#import "ETSession.h"

@interface ETMix ()
@end


@implementation ETMix

# pragma mark - Mantle

/**
 *  Mantle JSON Keypaths
 *
 *  @return Keypaths
 */
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"name":@"name",
             @"user":@"user",
             @"webPath":@"web_path",
             @"playsCount":@"plays_count",
             @"tagListCache":@"tag_list_cache",
             @"trackCount":@"track_count",
             @"likesCount":@"likes_count",
             @"likedBySessionUser":@"liked_by_current_user",
             @"cover":@"cover_urls",
             @"mixDescription":@"description"
             };
}

/**
 *  Mantle Value Transformers
 *
 *  @param key the key
 *
 *  @return The value transformer
 */
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"user"]) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ETUser class]];
    } else if ([key isEqualToString:@"cover"]) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ETMixCover class]];
    } else if ([key isEqualToString:@"likedBySessionUser"]) {
        return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
    } else if ([key isEqualToString:@"tagListCache"]) {
        return [self tagListCacheJSONValueTransformer];
    }
    return nil;
}

/**
 *  A value transformer that splits a string at ",".
 *  Hanldes tag lists.
 *
 *  @return The value transformer
 */
+(NSValueTransformer *)tagListCacheJSONValueTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [value componentsSeparatedByString:@", "];
    } reverseBlock:^id(NSArray *value, BOOL *success, NSError *__autoreleasing *error) {
        return [value componentsJoinedByString:@", "];
    }];
}

# pragma mark - API

/**
 *  Gets a mix set for a given smart it
 *
 *  @param smartID   The smartID.
 *  @param includes  Properties that should be inclueded in the response.
 *  @param paginator A paginator. The paginator will be added to the request.
 *                   If no paginator is given, a new one will be created.
 *  @param session   A session.
 *  @param handler   A response handler.
 */
+(void)mixSetBySmartID:(ETSmartID *)smartID
              includes:(NSString *)includes
             paginator:(ETPaginator *)paginator
               session:(ETSession *)session
              complete:(ETRequestCompletion)handler
{
    
    if (paginator == nil)
    {
        paginator = [ETPaginator new];
    }
    
    ETURL *url = [ETURL URLWithEndpoint:[NSString stringWithFormat:@"mix_sets/%@", smartID]];
    [url setQueryParam:@"include" toObject:[includes stringByAppendingString:@",pagination"]];
    [url setQueryParam:paginator];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url
                                             andSession:session
                                               complete:^(NSError *err, id result)
    {
        NSMutableArray *mixes = nil;
        if (!err)
        {
            NSDictionary *mixSet = result[@"mix_set"];
            mixes = [NSMutableArray new];
            NSArray *mixesJSON = mixSet[@"mixes"];
            
            for (NSDictionary* mix in mixesJSON)
            {
                @autoreleasepool {
                    ETMix *mixObj = [MTLJSONAdapter modelOfClass:[ETMix class] fromJSONDictionary:mix error:&err];
                    if (err) break;
                    [mixes addObject:mixObj];
                    [mixObj setRequestedWithSession: session != nil];
                }
            }
            
            // update pagination
            if (!err)
            {
                NSNumber *totalEntries = mixSet[@"pagination"][@"total_entries"];
                [paginator setTotalEntries:totalEntries];
            } else {
                NSLog(@"Error transforming JSON to model: %@", err);
            }
        }
        handler(err, mixes);
    }];
    
    [request send];
}

/**
 *  Likes or unlikes a mix. The properties will update immediately.
 *
 *  @param yesOrNo If true the mix will be liked, otherwise it will be unliked.
 *  @param session A session.
 *  @param handler A response handler.
 */
-(void)like:(BOOL)yesOrNo
    session:(ETSession *)session
   complete:(ETRequestCompletion)handler
{
    NSMutableString *endpoint;
    endpoint = [NSMutableString stringWithFormat:@"mixes/%@/%@",
                [self.id stringValue],
                (yesOrNo == true) ? @"like" : @"unlike"];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    ETRequest *request;
    request = [[ETRequest alloc] initWithURL:url
                                  andSession:session
                                    complete:^(NSError *err, id result)
    {
        if (!err) {
            _likedBySessionUser = yesOrNo;
        }
        handler(err, result);
    }];
    [request send];
}

/**
 *  Updates the properties of the object from the server
 *
 *  @param includes List of properties to update and incluse.
 *  @param session  A session.
 *  @param handler  A response handler.
 */
-(void)updateProperties:(NSString *)includes
                session:(ETSession *)session
               complete:(ETRequestCompletion)handler
{
    NSString *endpoint = [NSString stringWithFormat:@"/mixes/%@",self.id.stringValue];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"include" toObject:includes];
    ETRequest *request;
    request = [[ETRequest alloc] initWithURL:url
                                  andSession:session
                                    complete:^(NSError *err, id result)
    {
        if (!err)
        {
            // create a temporary object then merge it by its JSON keys
            id temp = [MTLJSONAdapter modelOfClass:[ETMix class]
                                fromJSONDictionary:result[@"mix"]
                                             error:nil];
            id tmpTracks = _tracksPlayed;
            [self mergeValuesForKeysFromModel:temp];
            _tracksPlayed = tmpTracks;
        }
        handler(err, result);
    }];
    [request send];
}

# pragma mark - Object

/**
 *  Checks the mix id to determine if a mix is equal.
 *
 *  @param object An object.
 *
 *  @return True if the mix ids are equal.
 */
-(BOOL)isEqual:(id)object {
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:[ETMix class]])
    {
        return NO;
    }
    
    return [self isEqualToETMix:object];
}


/**
 *  Checks the mix id to determine if a mix is equal.
 *
 *  @param object A mix.
 *
 *  @return True if the mix ids are equal.
 */
-(BOOL)isEqualToETMix:(ETMix *)object {
    return self.id == object.id;
}

@end
