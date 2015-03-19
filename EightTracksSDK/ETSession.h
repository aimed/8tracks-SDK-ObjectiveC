//
//  ETSession.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ETSessionStateChangeNotification;

typedef void (^ETRequestCompletion)(NSError *err, id result);
typedef enum : NSUInteger {
    /* There is no known user object */
    ETSessionStateEmpty = 0,
    /* Session is disabled, acts as logout */
    ETSessionStateDisabled,
    /* Session token is not valid */
    ETSessionStateTokenInvalid,
    /* There is a token, but it has not been validated yet */
    ETSessionStateTokenCreated,
    /* Session token is valid */
    ETSessionStateTokenValid,
} ETSessionState;

//
// Protocol
//
@class ETSession;
@protocol ETSessionStateChangeListener
-(void)sessionStateChange:(NSNotification *)aNotification;
@end


@class ETUser;
@interface ETSession : NSObject

@property (nonatomic, readonly) ETSessionState state;
@property (nonatomic, readonly) ETSessionState previousState;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) ETUser *user;

-(instancetype)initWithToken:(NSString *)token;
-(void)authorizeWithUsername:(NSString *)username andPassword:(NSString *)password complete:(ETRequestCompletion)handler;
-(void)setSessionState:(ETSessionState)state;
-(BOOL)isValid;

+(void)setActiveSession:(ETSession *)session;
+(ETSession *)activeSession;
+(BOOL)hasActiveSession;
+(void)subscribe:(id<ETSessionStateChangeListener>)listener;
+(void)unsubscribe:(id<ETSessionStateChangeListener>)listener;
@end
