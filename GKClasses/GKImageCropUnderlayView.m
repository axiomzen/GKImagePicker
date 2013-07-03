//
//  GKImageCropUnderlayView.m
//  Print Studio
//
//  Created by Kyle Fleming on 6/26/13.
//  Copyright (c) 2013 Social Print Studio. All rights reserved.
//

#import "GKImageCropUnderlayView.h"

@implementation GKImageCropUnderlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat heightSpan = floor(height / 2 - self.cropSize.height / 2);
    CGFloat widthSpan = floor(width / 2 - self.cropSize.width  / 2);
    
    //fill outer rect
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(widthSpan, heightSpan, self.cropSize.width, self.cropSize.height));
}

@end
