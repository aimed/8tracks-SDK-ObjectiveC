//
//  EightTracksSDKTests.m
//  EightTracksSDKTests
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#define UNIT_TESTING 1

#import <XCTest/XCTest.h>
#import "EightTracksSDK.h"

@interface EightTracksSDKTests : XCTestCase
@end

@implementation EightTracksSDKTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [ETAPIKeyManager setAPIKey:@"e1e2db6d0010f8c54f80645209401fcb9fd91f36"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testSet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting..."];

    [ETSet get:^(NSError *err, ETSet *result) {
        [expectation fulfill];
        XCTAssert(err == nil);
    }];
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {}];
}

-(void)testSetPlay {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting..."];
    
    [ETSet get:^(NSError *err, ETSet *set) {
        if (!err) {
            [ETMix setBySmartID:[ETSmartID smartIDAllSortBy:0] complete:^(NSError *err2, NSArray *result) {
                if (!err2) {
                    [set playMix:result[0] complete:^(NSError *err, id result) {
                        [expectation fulfill];
                        XCTAssert(err == nil);
                    }];
                }
            }];
        }
    }];
    
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {}];

}

 - (void)testAuth
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting..."];

    ETSession *session = [ETSession new];
    [session authorizeWithUsername:@"aimed" andPassword:@"digital" complete:^(NSError *err, id result) {
        [expectation fulfill];
        XCTAssert(err == nil);
    }];
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {}];
}

 -(void)testMixSet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting..."];
    
    [ETMix setBySmartID:[ETSmartID smartIDAllSortBy:0] complete:^(NSError *err, id result) {
        [expectation fulfill];
        XCTAssert(err == nil);
    }];
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {}];
}
@end
