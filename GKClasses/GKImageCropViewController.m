//
//  GKImageCropViewController.m
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import "GKImageCropViewController.h"
#import "GKImageCropView.h"

@interface GKImageCropViewController ()
{
    BOOL setToolBarFrame;
}

@property (nonatomic, strong) GKImageCropView *imageCropView;

@property (nonatomic, getter = isReturning) BOOL returning;

- (void)_setupNavigationBar;
- (void)_setupCropView;

@end

@implementation GKImageCropViewController

#pragma mark -
#pragma Private Methods


- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)actionUse:(id)sender {
    if (!self.isReturning) {
        self.returning = YES;
        if (self.imageCropView.scrollView.isZooming || self.imageCropView.scrollView.isZoomBouncing || self.imageCropView.scrollView.isDragging || self.imageCropView.scrollView.isDecelerating) {
            self.imageCropView.delegate = self;
        } else {
            [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
            self.delegate = nil;
        }
    }
}


- (void)_setupNavigationBar{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(actionCancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GKIuse", @"")
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(actionUse:)];
}


- (void)_setupCropView{
    CGRect frame = self.view.bounds;
    CGFloat toolbarSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0 : setToolBarFrame ? 54 : 44;
    frame.size.height -= toolbarSize;
    self.imageCropView = [[GKImageCropView alloc] initWithFrame:frame imageToCrop:self.sourceImage crop:self.crop cropSize:self.cropSize minimumCropSize:self.minimumCropSize];
    [self.view addSubview:self.imageCropView];
}

- (void)_setupCancelButton{
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"PLCameraSheetButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"PLCameraSheetButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
    
    [[self.cancelButton titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
    [[self.cancelButton titleLabel] setShadowOffset:CGSizeMake(0, 1)];
    [self.cancelButton setFrame:CGRectMake(0, 0, 50, 30)];
    [self.cancelButton setTitle:NSLocalizedString(@"GKIcancel",@"") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:0.173 green:0.176 blue:0.176 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton setTitleShadowColor:[UIColor colorWithRed:0.827 green:0.831 blue:0.839 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton  addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)_setupUseButton{
    
    self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.useButton setBackgroundImage:[[UIImage imageNamed:@"PLCameraSheetDoneButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.useButton setBackgroundImage:[[UIImage imageNamed:@"PLCameraSheetDoneButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
    
    [[self.useButton titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
    [[self.useButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [self.useButton setFrame:CGRectMake(0, 0, 50, 30)];
    [self.useButton setTitle:NSLocalizedString(@"GKIuse",@"") forState:UIControlStateNormal];
    [self.useButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [self.useButton  addTarget:self action:@selector(actionUse:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIImage *)_toolbarBackgroundImage{
    
    CGFloat components[] = {
        1., 1., 1., 1.,
        123./255., 125/255., 132./255., 1.
    };
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 54), YES, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0, 54), kCGImageAlphaNoneSkipFirst);
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)_setupToolbar{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && self.toolbar == nil) {
        setToolBarFrame = YES;
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        //[self.toolbar setBackgroundImage:[self _toolbarBackgroundImage] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        //[self.toolbar setBackgroundColor:[UIColor colorWithRed:49.f/255.f green:197.f/255.f blue:244.f/255.f alpha:1]];
        [self.view addSubview:self.toolbar];
        
        [self _setupCancelButton];
        [self _setupUseButton];
        
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
        info.text = NSLocalizedString(@"GKImoveAndScale", @"");
        info.textColor = [UIColor colorWithRed:0.173 green:0.173 blue:0.173 alpha:1];
        info.backgroundColor = [UIColor clearColor];
        info.shadowColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.839 alpha:1];
        info.shadowOffset = CGSizeMake(0, 1);
        info.font = [UIFont boldSystemFontOfSize:18];
        [info sizeToFit];
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *lbl = [[UIBarButtonItem alloc] initWithCustomView:info];
        UIBarButtonItem *use = [[UIBarButtonItem alloc] initWithCustomView:self.useButton];
        
        [self.toolbar setItems:[NSArray arrayWithObjects:cancel, flex, lbl, flex, use, nil]];
    }
}

#pragma mark -
#pragma Super Class Methods

- (void)dealloc
{
    self.imageCropView.delegate = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"GKIchoosePhoto", @"");
    
    [self _setupNavigationBar];
    [self _setupCropView];
    [self _setupToolbar];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
		[self.navigationController setNavigationBarHidden:NO];
	}
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolbar = nil;
    self.cancelButton = nil;
    self.useButton = nil;
    self.imageCropView = nil;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame = self.imageCropView.frame;
    if(setToolBarFrame) {
        self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 54, 320, 54);
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.imageCropView.frame;
    bool here = false;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isReturning && !self.imageCropView.scrollView.isZooming && !self.imageCropView.scrollView.isZoomBouncing && !self.imageCropView.scrollView.isDragging && !self.imageCropView.scrollView.isDecelerating && !decelerate) {
        [self.delegate imageCropController:self didFinishWithCrop:self.imageCropView.crop];
        self.imageCropView.delegate = nil;
        self.delegate = nil;
    }
}

@end
