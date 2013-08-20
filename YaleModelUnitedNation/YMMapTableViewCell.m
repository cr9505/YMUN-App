//
//  YMMapTableViewCell.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/31/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMMapTableViewCell.h"

@implementation YMMapTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.textLabel.frame;
    frame.origin.y -= 110;
    self.textLabel.frame = frame;
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.y -= 110;
    self.detailTextLabel.frame = detailFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
