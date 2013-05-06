//
//  GKImageCropViewController.h
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GKImageCropControllerDelegate;

@interface GKImageCropViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGRect crop;
@property (nonatomic, assign) CGSize cropSize; //size of the crop rect, default is 320x320
@property (nonatomic, assign) CGSize minimumCropSize;
@property (nonatomic, weak) id<GKImageCropControllerDelegate> delegate;

@end


@protocol GKImageCropControllerDelegate <NSObject>
@required
- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCrop:(CGRect)crop;
@end