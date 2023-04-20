//
//  FirendViewController.m
//  kkinterview
//
//  Created by Junteng on 2023/4/18.
//

#import "FirendViewController.h"

@interface FirendViewController ()

@end

@implementation FirendViewController
@synthesize circleView, inviteTableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isExpand = NO;
    circleView.layer.cornerRadius = circleView.frame.size.width / 2;
    [circleView setBackgroundColor:hotPink];
    [inviteTableview setHidden:YES];
    [inviteTableview registerNib:[UINib nibWithNibName:@"inviteCell" bundle:nil] forCellReuseIdentifier:@"inviteCell"];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"請選擇情境" message:@"情境條件為下列三項" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *noFriendAction = [UIAlertAction actionWithTitle:@"無好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupView:WithoutFriend];
    }];
    
    UIAlertAction *firendAction = [UIAlertAction actionWithTitle:@"好友列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupView:HasFriends];
    }];
    
    UIAlertAction *inviteAction = [UIAlertAction actionWithTitle:@"邀請+好友列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupView:InviteWithFriends];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:noFriendAction];
    [alertController addAction:firendAction];
    [alertController addAction:inviteAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) setupView:(SceneStatus)option {
    int y = inviteTableview.frame.origin.y;
    NSDictionary *dataSource = @{
                                 QiPageMenuViewNormalTitleColor : [UIColor blackColor],
                                 QiPageMenuViewSelectedTitleColor : hotPink,
                                 QiPageMenuViewTitleFont : [UIFont systemFontOfSize:13],
                                 QiPageMenuViewSelectedTitleFont : [UIFont systemFontOfSize:13],
                                 QiPageMenuViewItemIsVerticalCentred : @(YES),
                                 QiPageMenuViewItemTitlePadding : @(10.0),
                                 QiPageMenuViewItemTopPadding : @(10.0),
                                 QiPageMenuViewItemPadding : @(10.0),
                                 QiPageMenuViewLeftMargin : @(20.0),
                                 QiPageMenuViewRightMargin : @(20.0),
                                 QiPageMenuViewItemWidth : @(0.0),
                                 QiPageMenuViewItemsAutoResizing : @(YES),
                                 QiPageMenuViewItemHeight : @(40.0),
                                 QiPageMenuViewHasUnderLine :@(YES),
                                 QiPageMenuViewLineColor : hotPink,
                                 QiPageMenuViewLineWidth : @(30.0),
                                 QiPageMenuViewLineHeight : @(4.0),
                                 QiPageMenuViewLineTopPadding : @(10.0)
                                 };
    
    menuView = [[QiPageMenuView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 30) titles:@[@"好友",@"聊天"]
                                          dataSource:dataSource];
    menuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:menuView];
    
    FriendListViewController * friendListVC = [FriendListViewController new];
    friendListVC.sceneStatus = option;
    friendListVC.delegate = self;
    friendListVC.view.backgroundColor = [UIColor clearColor];
    
    UIViewController *chatVC = [UIViewController new];
    chatVC.view.backgroundColor = [UIColor clearColor];
                                  
    int height = self.view.frame.size.height - (menuView.size.height + menuView.frame.origin.y) - 83;
    contenView = [[QiPageContentView alloc] initWithFrame:
                                     CGRectMake(0, menuView.bottom, self.view.width, height)
                                                         childViewController:@[friendListVC, chatVC]];
    [self.view addSubview:contenView];
}

#pragma mark -- InviteList Protocol
- (void) inviteFriendListArray:(NSMutableArray *) listArray {
    inviteArray = listArray;
    
    // 設置 tableHeight 為您要設置的高度
    __block CGFloat tableHeight = 60;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->inviteTableview setHidden:NO];
        if([self->inviteArray count] >= 2) {
            tableHeight = 120;
        }
        
        NSLayoutConstraint *heightConstraint;
        for (NSLayoutConstraint *constraint in self->inviteTableview.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                heightConstraint = constraint;
                break;
            }
        }
        if (heightConstraint) {
            heightConstraint.constant = tableHeight;
            [self->inviteTableview layoutIfNeeded];
        }
        
        int y = self->inviteTableview.frame.origin.y;
        y = self->inviteTableview.frame.size.height + y;
        CGRect frame = self->menuView.frame;
        frame.origin.y = y;
        self->menuView.frame = frame;
        
        int height = self.view.frame.size.height - (self->menuView.size.height + self->menuView.frame.origin.y) - 83;
        frame = self->contenView.frame;
        frame.size.height = height;
        frame.origin.y = self->menuView.frame.origin.y + self->menuView.size.height;
        self->contenView.frame = frame;

        [self->inviteTableview reloadData];
    });
}

#pragma mark -- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    inviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell"];

    if (cell == nil) {
        cell = [[inviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inviteCell"];
    }
    int row = (int)indexPath.row;
    Friend * friendData = [inviteArray objectAtIndex:row];
    cell.nameLabel.text = friendData.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [inviteArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(isExpand) {
        if(indexPath.row == 0) {
            return 80;
        } else {
            return 10;
        }
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    isExpand = !isExpand;
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消選取狀態

    [tableView reloadData];
}


@end
