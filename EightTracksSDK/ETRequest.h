//
//  ETRequest.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETURL.h"

typedef void (^ETRequestCompletion)(NSError *err, id result);

@class ETSession;

@interface ETRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, copy, readwrite)   ETRequestCompletion handler;
@property (nonatomic, strong, readwrite) ETSession *session;
@property (nonatomic, strong, readwrite) NSMutableURLRequest *request;

-(ETRequest *)initWithURL:(ETURL *)url complete:(ETRequestCompletion)handler;
-(ETRequest *)initWithURL:(ETURL *)url andSession:(ETSession *)session complete:(ETRequestCompletion)handler;
-(NSString *)requestMethod;
-(void)send;

@end
