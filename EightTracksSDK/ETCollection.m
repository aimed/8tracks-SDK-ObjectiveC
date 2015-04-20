//
//  ETCollection.m
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETCollection.h"
#import "ETUser.h"
#import "ETRequest.h"
#import "ETMixSet.h"

@implementation ETCollection
+(void)mixSetsForUser:(ETUser *)user
              session:(ETSession *)session
             complete:(ETRequestCompletion)handler
{
    NSString *endpoint;
    endpoint = [NSString stringWithFormat:@"/users/%@/collections",user.id.stringValue];
    
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"include" toObject:@"mix_sets"];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:session complete:^(NSError *err, id result) {
        NSArray *mixSets = nil;
        if (!err) {
            mixSets = [MTLJSONAdapter modelsOfClass:[ETMixSet class]
                                      fromJSONArray:result[@"mix_cluster"][@"mix_sets"]
                                              error:&err];
        }
        handler(err,(NSArray *)mixSets);
    }];
    [request send];
}
@end
