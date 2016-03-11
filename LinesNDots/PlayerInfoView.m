//
//  PlayerInfoView.m
//  LinesNDots
//
//  Created by Mason Silber on 3/10/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayerInfoView.h"
#import "Player.h"

@implementation PlayerInfoView {
  UILabel *_playerInfoLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];

  if (self) {
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2.0;

    _playerInfoLabel = [UILabel new];
    _playerInfoLabel.backgroundColor = [UIColor blackColor];
    _playerInfoLabel.numberOfLines = 0;
    _playerInfoLabel.font = [UIFont systemFontOfSize:18.0];
    _playerInfoLabel.textColor = [UIColor whiteColor];
    _playerInfoLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_playerInfoLabel];
  }

  return self;
}

- (void)setPlayer:(Player *)player
{
  if (![_player isEqual:player]) {
    _player = player;
    _playerInfoLabel.text = [NSString stringWithFormat:@"%@ %@ | %@\n%@, %@\n%@, %@\n%@", player.firstName, player.lastName, player.position, player.height, player.weight, player.school, player.state, player.declared];
    [self setNeedsLayout];
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  CGSize playerInfoSize = [_playerInfoLabel.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : _playerInfoLabel.font }  context:nil].size;
  _playerInfoLabel.frame = CGRectMake(0, 0, playerInfoSize.width, playerInfoSize.height);
  _playerInfoLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
