//
//  ETRequest.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETRequest.h"
#import "ETSession.h"
#import "ETAPIKeyManager.h"

NSString *const ETRequestResponseKeyStatus = @"status";
NSString *const ETRequestResponseKeyErrors = @"errors";
NSString *const ETRequestResponseStatusOK = @"200 OK";

NSString *const ETHeaderFieldUserToken = @"X-User-Token";
NSString *const ETHeaderFieldAPIKey = @"X-Api-Key";



@interface ETRequest ()

@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, strong, readwrite) NSMutableData *data;
@property (nonatomic, strong, readwrite) NSURLResponse *response;

@end



@implementation ETRequest

-(ETRequest *)initWithURL:(ETURL *)url complete:(ETRequestCompletion)handler {
    self = [super init];
    if (self) {
        _handler = handler;
        _request = [[NSMutableURLRequest alloc] initWithURL:[url toURL]];
        [_request setHTTPShouldHandleCookies:NO];
        [_request setValue:[ETAPIKeyManager APIKey] forHTTPHeaderField:ETHeaderFieldAPIKey];
    }
    return self;
}

-(ETRequest *)initWithURL:(ETURL *)url andSession:(ETSession *)session complete:(ETRequestCompletion)handler {
    self = [self initWithURL:url complete:handler];
    if (session) {
        _session = session;
    }
    return self;
}

-(NSString *)requestMethod {
    return @"GET";
}

-(void)send {
    NSLog(@"%@", _request.URL.description);
    [_request setHTTPMethod:self.requestMethod];
    
    // if a valid session is attached - use it
    if (_session && [_session isValid]) {
        [_request setValue:_session.token forHTTPHeaderField:ETHeaderFieldUserToken];
    }
    
    _data = [NSMutableData new];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
}


#pragma mark NSConnectionDelegate + NSConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _response = response;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSError *dictError = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:_data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&dictError];
    if (!dictError)
    {
        error = [NSError errorWithDomain:@"" code:0 userInfo:data];
    }
    _handler(error, nil);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization
                          JSONObjectWithData:_data
                          options:NSJSONReadingAllowFragments
                          error:&error];
    
    if (!error && ![data[ETRequestResponseKeyStatus] isEqualToString:ETRequestResponseStatusOK]) {
        NSInteger responseCode = [data[ETRequestResponseKeyStatus] integerValue];
        
        // invalidate session
        if (responseCode == 401 && _session) {
            [_session setSessionState:ETSessionStateTokenInvalid];
        }
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: data[ETRequestResponseKeyErrors]};
        error = [NSError errorWithDomain:@"" code:responseCode userInfo:userInfo];
    }
    
    // validate session
    if (_session && !error) {
        BOOL isLoggedIn = [(NSNumber *)data[@"logged_in"] boolValue];
        if (isLoggedIn && _session.state != ETSessionStateTokenValid)
        {
            [_session setSessionState:ETSessionStateTokenValid];
        }
        else if (!isLoggedIn && _session.isValid)
        {
            [_session setSessionState:ETSessionStateTokenInvalid];
        }
    }
    
    _handler(error, data);
}

@end
