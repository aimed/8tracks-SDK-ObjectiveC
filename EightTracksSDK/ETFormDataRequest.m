//
//  ETFormDataRequest.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETFormDataRequest.h"
#import "ETUtils.h"

@implementation ETFormDataRequest {
    NSMutableDictionary *body;
}

-(ETRequest *)initWithURL:(ETURL *)url complete:(ETRequestCompletion)handler {
    self = [super initWithURL:url complete:handler];
    if (self) {
        body = [NSMutableDictionary new];
    }
    return self;
}

-(void)send {
    NSString *bodyString = [ETUtils serializeDictionary:body];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [self.request setHTTPBody:bodyData];
    [super send];
}

-(void)setObject:(id)object forKey:(NSString *)key {
    [body setObject:object forKey:key];
}

-(NSString *)requestMethod {
    return @"POST";
}

@end
