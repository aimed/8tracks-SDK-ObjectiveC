//
//  ETAPIKeyManager.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETAPIKeyManager : NSObject

+(void)setAPIKey:(NSString *)key;
+(NSString *)APIKey;

@end
