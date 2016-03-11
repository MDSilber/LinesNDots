//
//  Scoreboard.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayFrame;
@class Play;

@interface ScoreboardView : UIView
// Should only need to get set whenever a new play is selected
@property (nonatomic) Play *currentPlay;
// Should get set whenever the frame changes
@property (nonatomic) PlayFrame *currentFrame;

+ (NSString *)stringforPlay:(Play *)play;
@end
