//
//  GKImageCropView.h
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKImageCropView : UIView

- (id)initWithFrame:(CGRect)frame imageToCrop:(UIImage *)imageToCrop crop:(CGRect)crop cropSize:(CGSize)cropSize minimumCropSize:(CGSize)minimumCropSize;

@property (nonatomic, assign, readonly) CGRect crop;

@end
