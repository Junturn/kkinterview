//
//  FirendViewController.h
//  kkinterview
//
//  Created by Junteng on 2023/4/18.
//

#import <UIKit/UIKit.h>
#import "CommandDef.h"
#import "FriendListViewController.h"
#import "QiPageMenuView.h"
#import "QiPageContentView.h"
#import "UIView+frame.h"
#import "inviteCell.h"
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirendViewController : UIViewController <InviteList> {
    NSMutableArray * inviteArray;
    QiPageMenuView *menuView;
    QiPageContentView *contenView;
    BOOL isExpand;
}

@property (nonatomic, weak) IBOutlet UIView * circleView;
@property (nonatomic, weak) IBOutlet UITableView * inviteTableview;

@end

NS_ASSUME_NONNULL_END
