//
//  ETSmartID.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 01/03/15.
//  Copyright (c) 2015 Norocketlab. All rights reserved.
//

#import "ETSmartID.h"

#import "ETUser.h"
#import "ETMix.h"
#import "ETUtils.h"

NSString *const SmartIDTypeAll = @"all";
NSString *const SmartIDTypeLikedBy = @"liked";
NSString *const SmartIDTypeListened = @"listened";
NSString *const SmartIDTypeSimilarTo = @"similar";
NSString *const SmartIDTypeKeyword = @"keyword";
NSString *const SmartIDTypeRecommended = @"recommended";

@interface ETSmartID ()
@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic, strong) NSString *smartID;
@property (nonatomic) ETSmartIDSorting sorting;
+(NSString *)encodeSlug:(NSString *)input;
+(NSString *)sortingToString:(ETSmartIDSorting)sorting;
@end

@implementation ETSmartID

-(instancetype)init {
    self = [super init];
    if (self) {
        _components = [NSMutableArray new];
    }
    return self;
}

+(instancetype)smartIDFromString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@":"];
    ETSmartID *smartID = [ETSmartID new];
    smartID.components = [NSMutableArray arrayWithArray:components];
    return smartID;
}

+(instancetype) smartIDAllSortBy:(ETSmartIDSorting)sorting {
    ETSmartID *smartID = [ETSmartID new];
    [smartID.components addObject:SmartIDTypeAll];
    smartID.sorting = sorting;
    return smartID;
}

+(instancetype) smartIDWithTags:(NSArray *)tags sortBy:(ETSmartIDSorting)sorting {
    ETSmartID *smartID = [ETSmartID new];
    return smartID;
}

+(instancetype) smartIDWithArtist:(NSString *)artist {
    ETSmartID *smartID = [ETSmartID new];
    return smartID;
}

+(instancetype) smartIDWithKeyword:(NSString *)keyword sortBy:(ETSmartIDSorting)sorting {
    ETSmartID *smartID = [ETSmartID new];
    smartID.components = [NSMutableArray arrayWithObjects:
                            SmartIDTypeKeyword,
                            [self encodeSlug:keyword],
                            nil
                          ];
    smartID.sorting = sorting;
    return smartID;
}

+(instancetype) smartIDWithDJ:(ETUser *)user {
    ETSmartID *smartID = [ETSmartID new];
    return smartID;
}

+(instancetype) smartIDWithLikedBy:(ETUser *)user {
    ETSmartID *smartID = [ETSmartID new];
    [smartID.components addObject:SmartIDTypeLikedBy];
    [smartID.components addObject:[user.id stringValue]];
    return smartID;
}

+(instancetype) smartIDWithSimiliarTo:(ETMix *)mix {
    ETSmartID *smartID = [ETSmartID new];
    [smartID.components addObject:SmartIDTypeSimilarTo];
    [smartID.components addObject:[mix.id stringValue]];
    return smartID;
}

+(instancetype) smartIDFeed {
    ETSmartID *smartID = [ETSmartID new];
    return smartID;
}

+(instancetype) smartIDSocialFeedForUser:(ETUser *)user {
    ETSmartID *smartID = [ETSmartID new];
    return smartID;
}

+(instancetype) smartIDListened {
    ETSmartID *smartID = [ETSmartID new];
    smartID.components = [NSMutableArray arrayWithObject:SmartIDTypeListened];
    return smartID;
}

+(instancetype) smartIDRecommended {
    ETSmartID *smartID = [ETSmartID new];
    smartID.components = [NSMutableArray arrayWithObject:SmartIDTypeRecommended];
    return smartID;
}

+(NSString *)sortingToString:(ETSmartIDSorting)sorting {
    NSString *result = nil;
    switch (sorting) {
        case ETSmartIDSortingRECENT:
            result = @"recent";
            break;
        case ETSmartIDSortingHOT:
            result = @"hot";
            break;
        case ETSmartIDSortingPOPULAR:
            result = @"popular";
            break;
        default:
            break;
    }
    return result;
}

-(NSString *)description {
    NSMutableArray *components = [NSMutableArray arrayWithArray:_components];
    
    if (components.count == 0)
    {
        [components addObject:@"all"];
    }
    
    if (_sorting > ETSmartIDSortingNONE)
    {
        [components addObject:[ETSmartID sortingToString:_sorting]];
    }
    
    return [components componentsJoinedByString:@":"];
}

+(NSString *)encodeSlug:(NSString *)input {
    NSMutableString *string = [NSMutableString stringWithString:input];
    [string replaceOccurrencesOfString:@"_" withString:@"__" options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"/" withString:@"\\" options:0 range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"." withString:@"^" options:0 range:NSMakeRange(0, [string length])];
    return [ETUtils URLEncodeWithString:string];
}

@end
