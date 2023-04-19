//
//  FriendListViewController.h
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import <UIKit/UIKit.h>
#import "RefreshUITableView.h"
#import "CommandDef.h"
#import "inforCell.h"
#import "KKRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    WithoutFriend = 0,
    HasFriends,
    InviteWithFriends
} SceneStatus;

@protocol InviteList <NSObject>

- (void) inviteFriendListArray:(NSMutableArray *) listArray;

@end


@interface FriendListViewController : UIViewController <UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, RefreshTableViewDelegate> {
    NSMutableArray * listArray;
    NSMutableArray * tempListArray;
    Boolean isSearch;
    UISearchController *searchController;
}

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet UILabel * descriptionLabel1;
@property (nonatomic, weak) IBOutlet UILabel * descriptionLabel2;
@property (nonatomic, weak) IBOutlet UILabel * descriptionLabel3;
@property (nonatomic, weak) IBOutlet UIButton * addfriendButton;
@property (nonatomic, weak) IBOutlet RefreshUITableView * friendTableView;

@property (nonatomic, assign) SceneStatus sceneStatus;
@property (nonatomic, weak) id<InviteList> delegate;

@end

NS_ASSUME_NONNULL_END
