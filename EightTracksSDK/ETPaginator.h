//
//  ETPaginator.h
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "ETURLQueryParam.h"

@interface ETPaginator : MTLModel <MTLJSONSerializing,ETURLQueryParam>
@property (readonly) uint page;
@property (readonly) uint perPage;
@property (nonatomic, readwrite) NSNumber *totalEntries;
-(instancetype)initWithCurrentPage:(uint)currentPage andPerPage:(uint)perPage;
-(void)nextPage;
-(void)previousPage;
-(uint)currentNumberOfEntries;
-(uint)numberOfEntriesToPage:(uint)page;
-(NSRange)rangeForEntriesFromPage:(uint)fromPage toPage:(uint)toPage;
-(BOOL)atBeginning;
-(BOOL)atEnd;
@end
