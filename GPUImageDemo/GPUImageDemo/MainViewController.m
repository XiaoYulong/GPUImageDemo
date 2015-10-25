//
//  MainViewController.m
//  GPUImageDemo
//
//  Created by 肖 玉龙 on 15/10/25.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "MainViewController.h"
#import "GPUImage.h"
@interface MainViewController ()
@property (nonatomic, strong) GPUImageView *primaryView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) GPUImagePicture *sourcePicture;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *sepiaFilter;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *sepiaFilter2;
@end

@implementation MainViewController

- (void)loadView
{
    [super loadView];
    self.primaryView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.primaryView];
    
    self.slider = [[UISlider alloc] init];
    [self.slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
    self.slider.value = 0.5;
    
    [self.view addSubview:self.slider];
    
    [self setupDisplayFiltering];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.slider.frame = CGRectMake(25.0, self.view.bounds.size.height - 50.0, self.view.bounds.size.width - 50.0, 40.0);
}

-(void)updateSliderValue:(UISlider *)slider
{
    CGFloat midpoint = [slider value];
    [(GPUImageTiltShiftFilter *)self.sepiaFilter setTopFocusLevel:midpoint - 0.1];
    [(GPUImageTiltShiftFilter *)self.sepiaFilter setBottomFocusLevel:midpoint + 0.1];
    
    [self.sourcePicture processImage];
}

- (void)setupDisplayFiltering;
{
    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"]; // The WID.jpg example is greater than 2048 pixels tall, so it fails on older devices
    
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    self.sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    //    sepiaFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    GPUImageView *imageView = self.primaryView;
    [self.sepiaFilter forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    
    [self.sourcePicture addTarget:self.sepiaFilter];
    [self.sepiaFilter addTarget:imageView];
    
    [self.sourcePicture processImage];
}
@end
