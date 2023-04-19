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
    
    [nameLabel setTextColor:greyishBrown];
    [inviteLabel setTextColor:brownGrey];
    [inviteLabel setText:@"邀請你成為好友：）"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
