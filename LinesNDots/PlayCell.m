//
//  PlayCell.m
//  LinesNDots
//
//  Created by Mason Silber on 3/10/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayCell.h"

@implementation PlayCell {
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];

  if (self) {
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2.0;

    _label = [UILabel new];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 2;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_label];
  }
  return self;
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  self.backgroundColor = selected ? [UIColor darkGrayColor] : [UIColor blackColor];
}

- (void)prepareForReuse
{
  [super prepareForReuse];
  self.selected = NO;
}

- (void)setPlayString:(NSString *)playString
{
  if (![_playString isEqualToString:playString]) {
    _playString = playString;
    _label.text = playString;
    CGSize stringSize = [_label.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _label.font} context:nil].size;
    _label.frame = CGRectMake(0, 0, stringSize.width, stringSize.height);

    _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  }
}

@end
