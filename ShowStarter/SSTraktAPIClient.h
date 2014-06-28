//
//  SSTraktAPIClient.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "AFHTTPSessionManager.h"

FOUNDATION_EXPORT NSString *const kSSTraktAPIBaseURLString;
FOUNDATION_EXPORT NSString *const kSSTraktAPIKey;


@interface SSTraktAPIClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)getSeasonForShowTVDBID:(NSString *)showTVDBID
                  seasonNumber:(NSNumber *)seasonNumber
                       success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)getSeasonsForShowTVDBID:(NSString *)showTVDBID
                        success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)getTrendingShowsSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
