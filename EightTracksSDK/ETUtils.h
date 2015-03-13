//
//  ETUtils.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETUtils : NSObject

+(NSString *)URLEncodeWithString:(NSString*)string;
+(NSString *)serializeDictionary:(NSDictionary*)dict;

@end
