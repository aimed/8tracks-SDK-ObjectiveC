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
-(void)updateWithDict:(NSDictionary *)dict;
@end


@implementation ETMix

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"webPath":@"web_path",
             @"playsCount":@"plays_count",
             @"tagList":@"tag_list",
             @"trackCount":@"track_count",
             @"likedBySessionUser":@"liked_by_current_user",
             @"cover":@"cover_urls"
             };
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"user"]) {
        return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ETUser class]];
    } else if ([key isEqualToString:@"cover"]) {
        return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[ETMixCover class]];
    }
    return nil;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    _tracksPlayed = [NSMutableArray new];
    return self;
}

-(ETMix *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self updateWithDict:dict];
    }
    return self;
}
-(void)updateWithDict:(NSDictionary *)dict {
    [self setValuesForKeysWithDictionary:dict];
    if (dict[@"user"])
    {
        _user = [[ETUser alloc] initWithDict:dict[@"user"]];
    }
    _webPath = dict[@"web_path"];
    _playsCount = dict[@"plays_count"];
    _likesCount = dict[@"likes_count"];
    _tagList = dict[@"tag_list"];
    _trackCount = dict[@"track_count"];
    _likedBySessionUser = [(NSNumber *)dict[@"liked_by_current_user"] boolValue];
    _cover = dict[@"cover_urls"];
    if (!_tracksPlayed) {
        _tracksPlayed = [NSMutableArray new];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
+(void)mixSetBySmartID:(ETSmartID *)smartID
         withPaginator:(ETPaginator *)paginator
               session:(ETSession *)session
              complete:(ETRequestCompletion)handler
{
    
    if (paginator == nil)
    {
        paginator = [ETPaginator new];
    }
    
    ETURL *url = [ETURL URLWithEndpoint:[NSString stringWithFormat:@"mix_sets/%@", smartID]];
    [url setQueryParam:@"include" toObject:@"mixes[user,cover_images,liked,user_with_followed],pagination"];
    [url setQueryParam:paginator];
    ETRequest *request = [[ETRequest alloc] initWithURL:url
                                             andSession:session
                                               complete:^(NSError *err, id result) {
        NSMutableArray *mixes = nil;
        if (!err)
        {
            NSDictionary *mixSet = result[@"mix_set"];
            mixes = [NSMutableArray new];
            NSArray *mixesJSON = mixSet[@"mixes"];
            
            for (NSDictionary* mix in mixesJSON)
            {
                ETMix *mixObj = [MTLJSONAdapter modelOfClass:[ETMix class] fromJSONDictionary:mix error:nil];
                [mixes addObject:mixObj];
                [mixObj setRequestedWithSession: session != nil];
            }
            
            // update pagination
            [paginator setTotalEntries:mixSet[@"total_entries"]];
        }
        handler(err, mixes);
    }];
    [request send];
}
-(void)like:(BOOL)yesOrNo
    session:(ETSession *)session
   complete:(ETRequestCompletion)handler
{
    NSMutableString *endpoint;
    endpoint = [NSMutableString stringWithFormat:@"mixes/%@/",[self.id stringValue]];
    [endpoint appendString:(yesOrNo == true) ? @"like" : @"unlike"];
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
-(void)getForID:(NSNumber *)mixID
        session:(ETSession *)session
        complete:(ETRequestCompletion)handler
{
    NSString *endpoint;
    endpoint = [NSMutableString stringWithFormat:@"mixes/%@",[mixID stringValue]];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"include" toObject:@"liked,user,user_with_followed,cover_images"];
    ETRequest *request;
    request = [[ETRequest alloc] initWithURL:url
                                  andSession:session
                                    complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithDict:result[@"mix"]];
            [self setRequestedWithSession: session != nil];
        }
        handler(err, result);
    }];
}

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ETMix class]]) {
        return NO;
    }
    
    return [self isEqualToETMix:object];
}

-(BOOL)isEqualToETMix:(ETMix *)object {
    return self.id == object.id;
}

#pragma mark NSCoding


@end
