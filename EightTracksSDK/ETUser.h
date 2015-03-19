//
//  ETUser.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETUserAvatar.h"

typedef enum : NSUInteger {
    ETUserIncludesBase = 0,
    ETUserIncludesProfile = 1 << 0,
    ETUserIncludesProfileCounts = 1 << 1,
    ETUserIncludesCollections = 1 << 2,
    ETUserIncludesTimeLine = 1 << 3,
    ETUserIncludesTopTags = 1 << 4,
    ETUserIncludesFollowed = 1 << 5,
    ETUserIncludesLocation = 1 << 6,
    ETUserIncludesLocationSummary = 1 << 7,
    ETUserIncludesPresets = 1 << 8,
    ETUserIncludesPublic = (1 << 9) - 1,
    ETUserIncludesRecentMixes = 1 << 9,
    ETUserIncludesWebPreferences = 1 << 10,
    ETUserIncludesAll = (1 << 10) - 1,
} ETUserIncludes;

typedef void (^ETRequestCompletion)(NSError *err, id result);

@class ETSession;

@interface ETUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSString *login;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSString *bio;
@property (nonatomic, strong, readonly) NSString *memberSince;
@property (nonatomic, strong, readonly) NSArray  *topTags;
@property (nonatomic, strong, readonly) NSArray  *presetSmartIDs;
@property (nonatomic, strong, readonly) NSNumber *followsCount;
@property (nonatomic, strong, readonly) NSNumber *followersCount;
@property (nonatomic, strong, readonly) NSNumber *likedMixesCount;
@property (nonatomic, strong, readonly) NSNumber *publicMixesCount;
@property (nonatomic, strong, readonly) NSNumber *favoritesCount;
@property (nonatomic, strong, readonly) ETUserAvatar *avatar;
@property (nonatomic, readonly)         BOOL subscribed;
@property (nonatomic, readonly)         BOOL followedBySessionUser;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSArray *recentMixes;
@property (nonatomic, strong, readonly) NSArray *collections;

-(void)fetch:(ETUserIncludes)includes session:(ETSession *)session complete:(ETRequestCompletion)handler;
+(NSString *)includesToString:(ETUserIncludes)includes;
@end
