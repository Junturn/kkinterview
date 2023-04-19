//
//  inforCell.h
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface inforCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView * pinImageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UIButton * transerAccButton;
@property (nonatomic, weak) IBOutlet UIButton * transerAccButtonV2;
@property (nonatomic, weak) IBOutlet UIButton * inviteButton;
@property (nonatomic, weak) IBOutlet UIButton * moreInfoButton;
- (void) isInviteStatus:(BOOL) invite;
@end

NS_ASSUME_NONNULL_END
