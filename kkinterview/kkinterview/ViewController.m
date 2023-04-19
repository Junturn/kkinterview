//
//  ViewController.m
//  kkinterview
//
//  Created by Junteng on 2023/4/18.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabbarView];
}

-(void) setupTabbarView {
    SettingsViewController * setVC = [SettingsViewController new];
    FirendViewController * friendVC = [FirendViewController new];
    HomeViewController * homeVC = [HomeViewController new];
    ManagerViewController * managerVC = [ManagerViewController new];
    ProductViewController * productVC = [ProductViewController new];
    
    UITabBarItem * productItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icTabbarProductsOff"] tag:0];
    productVC.tabBarItem = productItem;
    
    UITabBarItem * friendItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icTabbarFriendsOn"] tag:1];
    friendVC.tabBarItem = friendItem;
    
    UIImage *homeImage = [[UIImage imageNamed:@"icTabbarHomeOff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem * homeItem = [[UITabBarItem alloc] initWithTitle:@"" image:homeImage tag:2];
    homeVC.tabBarItem = homeItem;
    
    UITabBarItem * managerItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icTabbarManageOff"] tag:3];
    managerVC.tabBarItem = managerItem;

    UITabBarItem * settingItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icTabbarSettingOff"] tag:3];
    setVC.tabBarItem = settingItem;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"imgTabbarBg"];
    [[UITabBar appearance] setBackgroundImage:backgroundImage];

    
    self.viewControllers = @[productVC, friendVC, homeVC, managerVC, setVC];
    self.selectedIndex = 1;
}


@end
