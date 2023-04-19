//
//  KKRequest.h
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKRequest : NSObject

+ (KKRequest *)sharedInstance;
- (void)askFriendListV1withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion;
- (void)askFriendListV2withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion;
- (void)askFriendListV3withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion;
- (void)askFriendListV4withCompletion:(void (^)(NSMutableArray *friendArray, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
