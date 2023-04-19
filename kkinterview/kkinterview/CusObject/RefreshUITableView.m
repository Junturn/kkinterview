//
//  RefreshUITableView.m
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import "RefreshUITableView.h"

@implementation RefreshUITableView

@synthesize freshDelegate;

- (void) awakeFromNib {
    [super awakeFromNib];
    refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height)];
    [refreshControl addTarget:self action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    [self addSubview:refreshControl];
}

- (void) beginRefreshing {
    [freshDelegate startRefreshData];
}

- (void) endRefreshLoading {
    [refreshControl endRefreshing];
}

@end
