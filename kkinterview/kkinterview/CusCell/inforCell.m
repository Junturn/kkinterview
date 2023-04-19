//
//  inforCell.m
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import "inforCell.h"
#import "CommandDef.h"

@implementation inforCell
@synthesize pinImageView, inviteButton, transerAccButton, transerAccButtonV2, nameLabel, moreInfoButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    transerAccButton.layer.borderColor = hotPink.CGColor;
    transerAccButton.layer.borderWidth = 2;
    [transerAccButton setTitle:@"轉帳" forState:UIControlStateNormal];
    [transerAccButton setTitleColor:hotPink forState:UIControlStateNormal];
    
    transerAccButtonV2.layer.borderColor = hotPink.CGColor;
    transerAccButtonV2.layer.borderWidth = 2;
    [transerAccButtonV2 setTitle:@"轉帳" forState:UIControlStateNormal];
    [transerAccButtonV2 setTitleColor:hotPink forState:UIControlStateNormal];
    
    inviteButton.layer.borderColor = brownGrey.CGColor;
    inviteButton.layer.borderWidth = 2;
    [inviteButton setTitle:@"邀請中" forState:UIControlStateNormal];
    [inviteButton setTitleColor:brownGrey forState:UIControlStateNormal];
    
    
    UIImage *icFriendsMore = [[UIImage imageNamed:@"icFriendsMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [moreInfoButton setImage:icFriendsMore forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) isInviteStatus:(BOOL) invite {
    if( invite) {
        transerAccButton.hidden = NO;
        inviteButton.hidden = NO;
        transerAccButtonV2.hidden = YES;
        moreInfoButton.hidden = YES;
    } else {
        transerAccButton.hidden = YES;
        inviteButton.hidden = YES;
        transerAccButtonV2.hidden = NO;
        moreInfoButton.hidden = NO;
    }
}

@end
