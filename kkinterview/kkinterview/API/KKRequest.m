//
//  KKRequest.m
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import "KKRequest.h"

@implementation KKRequest

static KKRequest *sharedInstance = nil;

+ (KKRequest *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)init {
    self = [super init];
    if (self) {
        // 初始化代码
    }
    return self;
}

- (void)askFriendListV1withCompletion:(void (^)(NSMutableArray *friendList, NSError *error))completion {
    [self sendRequest:@"https://dimanyen.github.io/friend1.json" withCompletion:^(NSData *data, NSError *error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self parseFriendListData:data], nil);
        }
    }];
}

- (void)askFriendListV2withCompletion:(void (^)(NSMutableArray *friendList, NSError *error))completion {
    [self sendRequest:@"https://dimanyen.github.io/friend2.json" withCompletion:^(NSData *data, NSError *error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self parseFriendListData:data], nil);
        }
    }];
}

- (void)askFriendListV3withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion {
    [self sendRequest:@"https://dimanyen.github.io/friend3.json" withCompletion:^(NSData *data, NSError *error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self parseFriendListData:data], nil);
        }
    }];
}

- (void)askFriendListV4withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion {
    [self sendRequest:@"https://dimanyen.github.io/friend4.json" withCompletion:^(NSData *data, NSError *error) {
        if(error) {
            completion(nil, error);
        } else {
            completion([self parseFriendListData:data], nil);
        }
    }];
}

-(void) sendRequest:(NSString *)request withCompletion:(void (^)(NSData *data, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:request];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completion(nil, error);
        } else {
            completion(data, nil);
        }
    }];
    [task resume];
}

-(NSMutableArray *) parseFriendListData:(NSData *) data {
    NSMutableArray * resultArray = [NSMutableArray new];
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
    NSMutableArray * dataArray = [jsonDict objectForKey:@"response"];
    for (NSMutableDictionary * dict in dataArray) {
        Friend * friend = [Friend new];
        friend.name = [dict objectForKey:@"name"];
        friend.fid = [dict objectForKey:@"fid"] ;
        friend.isTop = [[dict objectForKey:@"isTop"] boolValue];
        friend.status = [[dict objectForKey:@"status"] intValue];
        NSString * updateDate = [dict objectForKey:@"updateDate"];
        updateDate = [updateDate stringByReplacingOccurrencesOfString:@"/" withString:@""];
        friend.updateDate = updateDate;
        [resultArray addObject:friend];
    }
    return resultArray;
}



@end
