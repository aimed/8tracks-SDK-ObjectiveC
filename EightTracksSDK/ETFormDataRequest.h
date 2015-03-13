//
//  ETFormDataRequest.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 21/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETRequest.h"

@interface ETFormDataRequest : ETRequest
-(void)setObject:(id)object forKey:(NSString *)key;
@end
