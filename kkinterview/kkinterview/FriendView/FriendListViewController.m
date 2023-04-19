//
//  FriendListViewController.m
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import "FriendListViewController.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController
@synthesize descriptionLabel1, descriptionLabel2, descriptionLabel3, addfriendButton;
@synthesize friendTableView, scrollView;
@synthesize sceneStatus;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tempListArray = [NSMutableArray new];
    switch (sceneStatus) {
        case WithoutFriend:
            [self askFriendNon];
            break;
        
        case HasFriends:
        case InviteWithFriends:
            [self setupFriendListView];
            break;

        default:
            break;
    }
    friendTableView.freshDelegate = self;
    [friendTableView registerNib:[UINib nibWithNibName:@"inforCell" bundle:nil] forCellReuseIdentifier:@"inforCell"];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    searchController.searchBar.hidden = NO;
}

#pragma mark -- 列表為空

-(void) setupNoFriendView {
    [self askFriendNon];
    scrollView.hidden = NO;
    friendTableView.hidden = YES;
    
    [descriptionLabel1 setTextColor:greyishBrown];
    [descriptionLabel2 setTextColor:brownGrey];
    
    addfriendButton.layer.cornerRadius = 20;
    addfriendButton.clipsToBounds = YES;
    [addfriendButton setTitle:@"加好友" forState:UIControlStateNormal];
    [addfriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = addfriendButton.bounds;
    gradientLayer.colors = @[(id)frogGreen.CGColor, (id)booger.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [addfriendButton.layer addSublayer:gradientLayer];

    UIImage *image = [UIImage imageNamed:@"icAddFriendWhite"];
    [addfriendButton setImage:image forState:UIControlStateNormal];


    NSString * desString = @"幫助好友更快找到你? 設定KOKO ID";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desString];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:hotPink, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle) };
    [attributedString setAttributes:attributes range:NSMakeRange(11, desString.length - 11)];

    descriptionLabel3.attributedText = attributedString;
    descriptionLabel3.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupKOKOID)];
    [descriptionLabel3 addGestureRecognizer:tapGestureRecognizer];
}

-(void) setupKOKOID {
    
}

#pragma mark -- 朋友列表抓取並且更新

- (void) setupFriendListView {
    scrollView.hidden = YES;
    friendTableView.hidden = NO;
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchBar.placeholder = @"想轉一筆給誰呢？";
    searchController.definesPresentationContext = YES;
    friendTableView.tableHeaderView = searchController.searchBar;
    

    
    switch (sceneStatus) {
        case WithoutFriend:
            break;
            
        case HasFriends:
            [self askFriendList];
            break;
            
        case  InviteWithFriends:
            [self askFriendAndInviteList];
            break;
            
        default:
            break;
    }
}

- (void) askFriendNon {
    [[KKRequest sharedInstance] askFriendListV4withCompletion:^(NSMutableArray *friendArray, NSError * error) {
        if([friendArray count] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNoFriendView];
            });
        }
    }];
}

- (void) askFriendList {
    __block NSMutableArray * friendOneArray;
    __block NSMutableArray * friendTwoArray;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [[KKRequest sharedInstance] askFriendListV1withCompletion:^(NSMutableArray *friendArray, NSError * error) {
        friendOneArray = friendArray;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[KKRequest sharedInstance] askFriendListV2withCompletion:^(NSMutableArray *friendArray, NSError * error) {
        friendTwoArray = friendArray;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self->listArray = [self checkFriendArrayData:friendOneArray Friend2:friendTwoArray];
        [self->friendTableView endRefreshLoading];
        [self->friendTableView reloadData];
    });
    
    
}

- (void) askFriendAndInviteList {
    [[KKRequest sharedInstance] askFriendListV3withCompletion:^(NSMutableArray *friendArray, NSError * error) {
        NSMutableArray * invitingArray = [NSMutableArray new];
        for (Friend * friend in friendArray) {
            if(friend.status == 0) {
                [invitingArray addObject:friend];
            } else {
                if(self->listArray == nil) {
                    self->listArray = [NSMutableArray new];
                }
                [self->listArray addObject:friend];
            }
        }
        Friend * fake = [Friend new];
        fake.name = @"Fake";
        fake.fid = @"099";
        fake.status = 2;
        fake.isTop = NO;
        fake.updateDate = @"20230419";
        
        [invitingArray addObject:fake];
        [self->delegate inviteFriendListArray:invitingArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->friendTableView endRefreshLoading];
            [self->friendTableView reloadData];
        });
        
    }];
}

- (NSMutableArray *) checkFriendArrayData:(NSMutableArray *)friend1 Friend2:(NSMutableArray *)friend2 {
    NSMutableArray *mergedArray = [NSMutableArray arrayWithArray:friend1];
    [mergedArray addObjectsFromArray:friend2];
    NSMutableArray * resultArray = [NSMutableArray new];
    
    for (Friend *friend in mergedArray) {
        NSString * fid = friend.fid;
        Boolean findFid = NO;
        for (Friend *savefriend in resultArray) {
            NSString * saveFid = savefriend.fid;
            if([fid isEqualToString:saveFid]) {
                findFid = YES;
                if ([friend.updateDate compare:savefriend.updateDate] == NSOrderedDescending) {
                    savefriend.status = friend.status;
                    savefriend.isTop = friend.isTop;
                    savefriend.updateDate = friend.updateDate;
                }
                break;
            } else {
                findFid = NO;
            }
        }
        if(!findFid) {
            [resultArray addObject:friend];
        }
    }
    
    return resultArray;
}

#pragma mark -- UITableViewDataSource
- (void)didPresentSearchController:(UISearchController *)searchController {
    for (Friend * f in listArray) {
        [tempListArray addObject:f];
    }
    isSearch = YES;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    isSearch = NO;
    for (Friend * f in tempListArray) {
        [listArray addObject:f];
    }
    [tempListArray removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->friendTableView reloadData];
    });
    
}

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
    if(!isSearch) {
        return;
    }
    
    NSString * searchText = searchController.searchBar.text;
    [listArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchText];
    
    NSArray * tempArray = [tempListArray filteredArrayUsingPredicate:predicate];
    

    for (Friend * friend in tempArray) {
        [listArray addObject:friend];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->friendTableView reloadData];
    });
}

#pragma mark -- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    inforCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell"];

    if (cell == nil) {
        cell = [[inforCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inforCell"];
    }
    int row = (int)indexPath.row;
    Friend * friendData = [listArray objectAtIndex:row];
    cell.nameLabel.text = friendData.name;
    cell.pinImageView.hidden = friendData.isTop;
    if(sceneStatus == HasFriends) {
        [cell isInviteStatus:NO];
    } else {
        if (friendData.status == 2) {
            [cell isInviteStatus:NO];
        }
        else if (friendData.status == 1) {
            [cell isInviteStatus:YES];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listArray count];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- RefreshTableViewDelegate
- (void) startRefreshData {
    switch (sceneStatus) {
        case WithoutFriend:
            break;
        
        case HasFriends:
            [self askFriendList];
            break;
            
        case InviteWithFriends:
            [self askFriendAndInviteList];
            break;

        default:
            break;
    }
}
@end
