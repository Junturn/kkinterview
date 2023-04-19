//
//  Friend.h
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *updateDate;


@end

NS_ASSUME_NONNULL_END
