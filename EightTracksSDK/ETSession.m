//
//  ETSession.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETSession.h"
#import "ETUser.h"
#import "ETFormDataRequest.h"

static ETSession *_activeSession;

NSString *const ETSessionStateChangeNotification = @"ETSessionStateChangeNotification";

@implementation ETSession

-(instancetype)initWithToken:(NSString *)token {
    self = [super init];
    if (self) {
        _token = token;
        [self setSessionState:ETSessionStateTokenCreated];
        
        // validate session
        [self authorizeWithUsername:nil
                        andPassword:nil
                           complete:^(NSError *err, id result) {
            
        }];
    }
    return self;
}

-(void)authorizeWithUsername:(NSString *)username
                 andPassword:(NSString *)password
                    complete:(ETRequestCompletion)handler
{
    ETURL *url = [ETURL URLWithSSLEndpoint:@"sessions"];
    ETFormDataRequest *request;
    request = [[ETFormDataRequest alloc]
               initWithURL:url
               complete:^(NSError *err, id result)
    {
        // login successfull
        if (!err) {
            _token = result[@"user"][@"user_token"];
            _user = [MTLJSONAdapter modelOfClass:[ETUser class] fromJSONDictionary:result[@"user"] error:nil];
            [self setSessionState:ETSessionStateTokenValid];
        }
        handler(err, self);
    }];
    
    // validate token sessions
    if (_token && username == nil && password == nil) {
        [request setSession:self];
    } else {
        [request setObject:username forKey:@"login"];
        [request setObject:password forKey:@"password"];
    }
    
    [request send];
}

-(void)setSessionState:(ETSessionState)state {
    _previousState = _state;
    _state = state;
    
    NSNotification *stateChangeNotification = [NSNotification
                                               notificationWithName:ETSessionStateChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] postNotification:stateChangeNotification];
    
    // destroy the active session if it is invalidated
    if (self == _activeSession && _state == ETSessionStateDisabled)
    {
        _activeSession = nil;
    }
}

-(BOOL)isValid {
    return _state > ETSessionStateTokenInvalid;
}

+(void)setActiveSession:(ETSession *)session {
    _activeSession = session;
}

+(ETSession *)activeSession {
    return _activeSession;
}

+(BOOL)hasActiveSession {
    return _activeSession != nil;
}

+(void)subscribe:(id<ETSessionStateChangeListener>)listener {
    [[NSNotificationCenter defaultCenter]
     addObserver:listener
     selector:@selector(sessionStateChange:)
     name:ETSessionStateChangeNotification
     object:nil];
}

+(void)unsubscribe:(id<ETSessionStateChangeListener>)listener {
    [[NSNotificationCenter defaultCenter]
     removeObserver:listener
     name:ETSessionStateChangeNotification
     object:nil];
}

@end
