//
//  GKImageCropView.m
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import "GKImageCropView.h"
#import "GKImageCropOverlayView.h"

#import <QuartzCore/QuartzCore.h>

#define rad(angle) ((angle) / 180.0 * M_PI)

static CGRect GKScaleRect(CGRect rect, CGFloat scale)
{
	return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}

@interface ScrollView : UIScrollView
@end

@implementation ScrollView

- (void)layoutSubviews{
    [super layoutSubviews];

    UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = zoomView.frame;
    
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (frameToCenter.size.width < boundsSize.width) {
        inset.right = inset.left = (boundsSize.width - frameToCenter.size.width);
    }
    if (frameToCenter.size.height < boundsSize.height) {
        inset.top = inset.bottom = (boundsSize.height - frameToCenter.size.height);
    }
    self.contentInset = inset;
}

@end

@interface GKImageCropView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GKImageCropOverlayView *cropOverlayView;

@property (nonatomic) CGSize cropSize;
@property (nonatomic, strong) UIImage *imageToCrop;
@property (nonatomic) CGSize minimumCropSize;

@end

@implementation GKImageCropView

- (CGRect)crop
{
    CGRect crop = CGRectZero;
    
    crop.origin.x = self.scrollView.contentOffset.x / self.scrollView.zoomScale;
    crop.origin.y = self.scrollView.contentOffset.y / self.scrollView.zoomScale;
    crop.size.width = self.cropSize.width / self.scrollView.zoomScale;
    crop.size.height = self.cropSize.height / self.scrollView.zoomScale;
    
    return crop;
}

#pragma mark -
#pragma Override Methods

- (id)initWithFrame:(CGRect)frame imageToCrop:(UIImage *)imageToCrop crop:(CGRect)crop cropSize:(CGSize)cropSize minimumCropSize:(CGSize)minimumCropSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cropSize = cropSize;
        self.imageToCrop = imageToCrop;
        self.minimumCropSize = minimumCropSize;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        CGSize size = cropSize;
        CGFloat xOffset = floor((CGRectGetWidth(self.bounds) - size.width) * 0.5);
        CGFloat yOffset = floor((CGRectGetHeight(self.bounds) - size.height) * 0.5);
        
        self.scrollView = [[ScrollView alloc] initWithFrame:CGRectMake(xOffset, yOffset, size.width, size.height)];
        self.scrollView.contentSize = imageToCrop.size;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.decelerationRate = 0.0;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        CGRect imageViewFrame = CGRectMake(0, 0, imageToCrop.size.width, imageToCrop.size.height);
        self.imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        self.imageView.image = imageToCrop;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:self.imageView];
        
        self.scrollView.maximumZoomScale = cropSize.height / minimumCropSize.height;
        if (imageToCrop.size.width * cropSize.height > cropSize.width * imageToCrop.size.height) {
            self.scrollView.minimumZoomScale = cropSize.width / imageToCrop.size.width;
            self.scrollView.maximumZoomScale = fmaxf(self.scrollView.maximumZoomScale, cropSize.height / imageToCrop.size.height);
        } else {
            self.scrollView.minimumZoomScale = cropSize.height / imageToCrop.size.height;
            self.scrollView.maximumZoomScale = fmaxf(self.scrollView.maximumZoomScale, cropSize.width / imageToCrop.size.width);
        }
        self.scrollView.zoomScale = cropSize.height / crop.size.height;
        
        self.scrollView.contentOffset = CGPointMake(crop.origin.x * self.scrollView.zoomScale, crop.origin.y * self.scrollView.zoomScale);
        
        self.cropOverlayView = [[GKImageCropOverlayView alloc] initWithFrame:self.bounds];
        self.cropOverlayView.cropSize = cropSize;
        [self addSubview:self.cropOverlayView];
    }
    return self;
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self.scrollView;
}

#pragma mark -
#pragma UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end
