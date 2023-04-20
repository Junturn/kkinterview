//
//  inviteCell.m
//  kkinterview
//
//  Created by Junteng on 2023/4/19.
//

#import "inviteCell.h"
#import "CommandDef.h"

@implementation inviteCell
@synthesize nameLabel, inviteLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 6;
    [self addShadowForView:self shadowOffset:CGSizeMake(0, 5)];

    [nameLabel setTextColor:greyishBrown];
    [inviteLabel setTextColor:brownGrey];
    [inviteLabel setText:@"邀請你成為好友：）"];
    [inviteLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addShadowForView:(UIView *)view shadowOffset:(CGSize)shadowOffset {
    view.backgroundColor = UIColor.whiteColor;
    
    view.layer.shadowColor = UIColor.lightGrayColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 2;
    
    view.layer.borderColor = UIColor.clearColor.CGColor;
    view.layer.borderWidth = 1 / UIScreen.mainScreen.scale;
    view.layer.cornerRadius = 10;
}

@end
