//
//  RefreshUITableView.h
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RefreshTableViewDelegate <NSObject>
- (void) startRefreshData;
@end

@interface RefreshUITableView : UITableView {
    UIRefreshControl * refreshControl;
}

@property (nonatomic, assign) id <RefreshTableViewDelegate> freshDelegate;
- (void) endRefreshLoading;
@end

NS_ASSUME_NONNULL_END
