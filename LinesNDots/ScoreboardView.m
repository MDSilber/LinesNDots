//
//  Scoreboard.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "ScoreboardView.h"
#import "PlayFrame.h"
#import "Play.h"

@implementation ScoreboardView {
  UILabel *_timeLabel;
  UILabel *_downLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];

  if (self) {
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2.0;
    
    _timeLabel = [UILabel new];
    _timeLabel.backgroundColor = [UIColor blackColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.numberOfLines = 1;
    _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _timeLabel.font = [UIFont systemFontOfSize:24.0];
    [self addSubview:_timeLabel];

    _downLabel = [UILabel new];
    _downLabel.backgroundColor = [UIColor blackColor];
    _downLabel.textColor = [UIColor whiteColor];
    _downLabel.textAlignment = NSTextAlignmentCenter;
    _downLabel.numberOfLines = 1;
    _downLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _downLabel.font = [UIFont systemFontOfSize:24.0];
    [self addSubview:_downLabel];

    // Placeholder text for the time being

    _timeLabel.text = @"13:45";
    [_timeLabel sizeToFit];

    _downLabel.text = [NSString stringWithFormat:@"%@%@", [[self class] _stringForDown:3], @(5)];
    [_downLabel sizeToFit];
  }

  return self;
}

- (void)setCurrentPlay:(Play *)currentPlay
{
  if (![_currentPlay isEqual:currentPlay]) {
    _currentPlay = currentPlay;

    NSUInteger yardsToGo = abs(currentPlay.firstDownYard - currentPlay.lineOfScrimmageYard);
    NSString *downString = [NSString stringWithFormat:@"%@%@", [[self class] _stringForDown:currentPlay.down], @(yardsToGo)];
    _downLabel.text = downString;
    [_downLabel sizeToFit];

    [self setNeedsLayout];
  }
}

- (void)setCurrentFrame:(PlayFrame *)currentFrame
{
  if (![_currentFrame isEqual:currentFrame]) {
    _currentFrame = currentFrame;

    _timeLabel.text = currentFrame.gameClock;
    [_timeLabel sizeToFit];

    [self setNeedsLayout];
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  CGRect timeFrame = _timeLabel.frame;
  timeFrame.origin = CGPointMake(floorf((CGRectGetWidth(self.bounds) - CGRectGetWidth(timeFrame))/2.0), 6.0);
  _timeLabel.frame = timeFrame;

  CGRect downFrame = _downLabel.frame;
  downFrame.origin = CGPointMake(floorf((CGRectGetWidth(self.bounds) - CGRectGetWidth(downFrame))/2.0), CGRectGetMaxY(timeFrame) + 8.0);
  _downLabel.frame = downFrame;
}

+ (NSString *)_stringForDown:(NSUInteger)down
{
  switch (down) {
    case 1:
      return @"1st & ";
    case 2:
      return @"2nd & ";
    case 3:
      return @"3rd & ";
    case 4:
      return @"4th & ";
    default:
      return nil;
  }
}

+ (NSString *)stringforPlay:(Play *)play
{
  NSUInteger yardsToGo = abs(play.firstDownYard - play.lineOfScrimmageYard);
  return [NSString stringWithFormat:@"%@\n%@%@", [play.frames firstObject].gameClock, [[self class] _stringForDown:play.down], @(yardsToGo)];
}

@end
