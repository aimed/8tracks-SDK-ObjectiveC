//
//  ETTrack.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETTrack.h"
#import "ETRequest.h"

@implementation ETTrack

-(ETTrack *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _url = [NSURL URLWithString:dict[@"url"]];
        _buyLink = [NSURL URLWithString:dict[@"buy_link"]];
        _trackFileStreamURL = [NSURL URLWithString:dict[@"track_file_stream_url"]];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
}


-(void)favorite:(BOOL)yesOrNo
        session:(ETSession *)session
       complete:(ETRequestCompletion)handler
{
    NSMutableString *endpoint;
    endpoint = [NSMutableString stringWithFormat:@"tracks/%@/",[self.id stringValue]];
    [endpoint appendString:(yesOrNo == true) ? @"fav" : @"unfav"];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    ETRequest *request;
    request = [[ETRequest alloc] initWithURL:url
                                  andSession:session
                                    complete:^(NSError *err, id result)
               {
                   if (!err) {
                       _favedBySessionUser = yesOrNo;
                   }
                   handler(err, result);
               }];
    [request send];
}

#pragma mark Mantle

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"buyLink":@"buy_link",
      @"trackFileStreamURL":@"track_file_stream_url"
      };
}
@end
