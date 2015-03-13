//
//  ETPaginator.h
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ETPaginator : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSNumber *currentPage;
@property (nonatomic, strong, readonly) NSNumber *perPage;
@property (nonatomic, strong, readonly) NSNumber *totalEntries;
-(void)nextPage;
-(void)previousPage;
-(BOOL)atBeginning;
-(BOOL)atEnd;
@end
