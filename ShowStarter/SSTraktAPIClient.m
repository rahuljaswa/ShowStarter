//
//  SSTraktAPIClient.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSTraktAPIClient.h"

NSString *const kSSTraktAPIKey              = @"7f25f46808644fa166e5b57a9ae8df13";
NSString *const kSSTraktAPIBaseURLString    = @"http://api.trakt.tv";


@implementation SSTraktAPIClient

#pragma mark - Helpers

- (void)getWithPath:(NSString *)path
            success:(void (^)(NSURLSessionDataTask *, id))success
            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

#pragma mark - AFHTTPSession overrides

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma mark - Public methods

+ (instancetype)sharedInstance
{
    static SSTraktAPIClient *sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kSSTraktAPIBaseURLString]];
    });
    return sharedClient;
}

- (void)getSeasonForShowTVDBID:(NSString *)showTVDBID
                  seasonNumber:(NSNumber *)seasonNumber
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"/show/season.json/%@/%@/%@",
                      kSSTraktAPIKey, showTVDBID, seasonNumber];
    [self getWithPath:path success:success failure:failure];
}

- (void)getSeasonsForShowTVDBID:(NSString *)showTVDBID
                        success:(void (^)(NSURLSessionDataTask *, id))success
                        failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"/show/seasons.json/%@/%@", kSSTraktAPIKey, showTVDBID];
    [self getWithPath:path success:success failure:failure];
}

- (void)getTrendingShowsSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"/shows/trending.json/%@", kSSTraktAPIKey];
    [self getWithPath:path success:success failure:failure];
}

@end
