//
//  ETSmartID.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 01/03/15.
//  Copyright (c) 2015 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETSmartIDSorting.h"

@class ETUser;
@class ETMix;
@class ETSession;


@interface ETSmartID : NSObject

@property (nonatomic, strong, readonly) ETSession *session;
@property (nonatomic, readwrite) BOOL filterNSFW;

+(instancetype) smartIDFromString:(NSString *)string;
+(instancetype) smartIDAllSortBy:(ETSmartIDSorting)sorting;
+(instancetype) smartIDWithTags:(NSArray *)tags sortBy:(ETSmartIDSorting)sorting;
+(instancetype) smartIDWithArtist:(NSString *)artist;
+(instancetype) smartIDWithKeyword:(NSString *)keyword;
+(instancetype) smartIDWithDJ:(ETUser *)user;
+(instancetype) smartIDWithLikedBy:(ETUser *)user;
+(instancetype) smartIDWithSimiliarTo:(ETMix *)mix;
+(instancetype) smartIDFeed;
+(instancetype) smartIDSocialFeedForUser:(ETUser *)user;
+(instancetype) smartIDListened;
+(instancetype) smartIDRecommended;

@end
