//
//  SplashViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 03/10/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "SplashViewController.h"
#import "Util.h"
@interface SplashViewController ()

//Check Parameter

@property BOOL hasAppStarted;

//Two Smartphone Images
@property UIImageView * mobileOnLeft;
@property UIImageView * mobileOnRight;

//Splash Title
@property UILabel * mobileLabel;
@property UILabel * developmentLabel;
@property UILabel * groupLabel;

//Revolving ImageViews
@property UIImageView * appleImage;
@property UIImageView * androidImage;
@property UIImageView * windowsImage;
@property UIImageView * blackberryImage;


//Animation Methods
-(void) initializeViews;
-(void) translateMobileImages;
-(void) animateToFinalFrameOfMobileImages;
-(void) translateLabels;
-(void) animateLabelsToFinalFrame;
-(void) animateLogos;

//Release Views
-(void) releaseViews;

//Start Application

- (IBAction)startApplication;

@end

#define SPACING 1
#define WIDTH 50
#define HEIGHT 88
#define OFFSET HEIGHT/4

#define MOBILE_WIDTH 150
#define DEV_WIDTH  235
#define TEXT_HEIGHT 45
#define LABEL_OFFSET DEV_WIDTH/4
#define LOGO_DIM 25


@implementation SplashViewController

@synthesize mobileOnLeft = _mobileOnLeft;
@synthesize mobileOnRight = _mobileOnRight;
@synthesize mobileLabel = _mobileLabel;
@synthesize developmentLabel = _developmentLabel;
@synthesize groupLabel = _groupLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSTimer * startTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(initializeViews) userInfo:nil repeats:NO];
    
    startTimer = nil;
  
}


-(void)initializeViews
{
    self.hasAppStarted = NO;
    
    //Left Mobile Image
    self.mobileOnLeft = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x - (SPACING/2+WIDTH), -HEIGHT, WIDTH, HEIGHT)];
    self.mobileOnLeft.image = [UIImage imageNamed:@"mobile_one.png"];
    self.mobileOnLeft.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view addSubview:self.mobileOnLeft];
    
    
    // Right Mobile Image
    self.mobileOnRight = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x + SPACING/2, 2*[Util centerPointOfScreen].y, WIDTH, HEIGHT)];
    self.mobileOnRight.image = [UIImage imageNamed:@"mobile_two.png"];
    self.mobileOnRight.contentMode = UIViewContentModeScaleAspectFit;
    
    
    [self.view addSubview:self.mobileOnRight];
    
    
    //Mobile Label
    self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(-MOBILE_WIDTH, [Util centerPointOfScreen].y/2 + HEIGHT +10, MOBILE_WIDTH, TEXT_HEIGHT)];
    self.mobileLabel.font = [UIFont fontWithName:@"ROBOTO" size:35];
    self.mobileLabel.text = @"Mobile";
    self.mobileLabel.backgroundColor = [UIColor clearColor];
    self.mobileLabel.textColor = [UIColor colorWithRed:0.443 green:0.200 blue:0.090 alpha:1.000];
    self.mobileLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.mobileLabel];
    
    
    //Development Label
    self.developmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*[Util centerPointOfScreen].x, [Util centerPointOfScreen].y/2 + HEIGHT +10 + TEXT_HEIGHT, DEV_WIDTH, TEXT_HEIGHT)];
    self.developmentLabel.font = [UIFont fontWithName:@"ROBOTO" size:35];
    self.developmentLabel.text = @"Development";
    self.developmentLabel.backgroundColor = [UIColor clearColor];
    self.developmentLabel.textColor = [UIColor colorWithRed:0.443 green:0.200 blue:0.090 alpha:1.000];
    self.developmentLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.developmentLabel];
    
    
    
    
    
    //Group Label
    self.groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(-MOBILE_WIDTH, [Util centerPointOfScreen].y/2 + HEIGHT +10 + 2*(TEXT_HEIGHT ), MOBILE_WIDTH, TEXT_HEIGHT)];
    self.groupLabel.font = [UIFont fontWithName:@"ROBOTO" size:35];
    self.groupLabel.text = @"Group";
    self.groupLabel.backgroundColor = [UIColor clearColor];
    self.groupLabel.textColor = [UIColor colorWithRed:0.443 green:0.200 blue:0.090 alpha:1.000];
    self.groupLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.groupLabel];
    
    
    
    //Apple Logo
    
    self.appleImage = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x -WIDTH-25, [Util centerPointOfScreen].y/2 - 35, LOGO_DIM, LOGO_DIM)];
    self.appleImage.image = [UIImage imageNamed:@"apple.png"];
    self.appleImage.contentMode = UIViewContentModeScaleAspectFit;
    self.appleImage.alpha = 0;
    [self.view addSubview:self.appleImage];
    
    //Windows Logo
    
    self.windowsImage = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x -12 , [Util centerPointOfScreen].y/2 - 14, LOGO_DIM, LOGO_DIM)];
    
    self.windowsImage.image = [UIImage imageNamed:@"windows.png"];
    self.windowsImage.contentMode = UIViewContentModeScaleAspectFit;
    self.windowsImage.alpha = 0;
    [self.view addSubview:self.windowsImage];
    
    // Android Logo
    
    self.androidImage = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x +WIDTH , [Util centerPointOfScreen].y/2 - 35, LOGO_DIM, LOGO_DIM)];
    
    self.androidImage.image = [UIImage imageNamed:@"ap_1.png"];
    self.androidImage.contentMode = UIViewContentModeScaleAspectFit;
    self.androidImage.alpha = 0;
    [self.view addSubview:self.androidImage];
    
    //Blackberry Logo
    
    self.blackberryImage = [[UIImageView alloc] initWithFrame:CGRectMake([Util centerPointOfScreen].x -12 , [Util centerPointOfScreen].y/2 - 56, LOGO_DIM, LOGO_DIM)];
    self.blackberryImage.image = [UIImage imageNamed:@"bb.png"];
    self.blackberryImage.contentMode = UIViewContentModeScaleAspectFit;
    self.blackberryImage.alpha = 0;
    [self.view addSubview:self.blackberryImage];
    
    
    
    
    //Start Animation
    [self translateMobileImages];
    
}

-(void)translateMobileImages
{
    [UIView animateWithDuration:0.7 animations:^{
        
        self.mobileOnLeft.frame = CGRectMake([Util centerPointOfScreen].x - (SPACING/2+WIDTH), [Util centerPointOfScreen].y/2+ OFFSET, WIDTH, HEIGHT);
        self.mobileOnRight.frame = CGRectMake([Util centerPointOfScreen].x + SPACING/2, [Util centerPointOfScreen].y/2 - OFFSET, WIDTH, HEIGHT);
        
    } completion:^(BOOL finished) {
        
        [self animateToFinalFrameOfMobileImages];
    }];
}

-(void)animateToFinalFrameOfMobileImages
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mobileOnLeft.frame = CGRectMake([Util centerPointOfScreen].x - (SPACING/2+WIDTH), [Util centerPointOfScreen].y/2, WIDTH, HEIGHT);
        self.mobileOnRight.frame = CGRectMake([Util centerPointOfScreen].x + SPACING/2, [Util centerPointOfScreen].y/2, WIDTH, HEIGHT);
    } completion:^(BOOL finished) {
        
        [self translateLabels];
    }];
    
}

-(void)translateLabels
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mobileLabel.frame=CGRectMake([Util centerPointOfScreen].x - MOBILE_WIDTH/2 + LABEL_OFFSET, [Util centerPointOfScreen].y/2 + HEIGHT +10, MOBILE_WIDTH, TEXT_HEIGHT);
        
        self.developmentLabel.frame = CGRectMake([Util centerPointOfScreen].x - DEV_WIDTH/2 - LABEL_OFFSET, [Util centerPointOfScreen].y/2 + HEIGHT +10 + TEXT_HEIGHT, DEV_WIDTH, TEXT_HEIGHT);
        
        self.groupLabel.frame =  CGRectMake([Util centerPointOfScreen].x - MOBILE_WIDTH/2 +LABEL_OFFSET, [Util centerPointOfScreen].y/2 + HEIGHT +10 + 2*(TEXT_HEIGHT), MOBILE_WIDTH, TEXT_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        [self animateLabelsToFinalFrame];
    }];
}

-(void) animateLabelsToFinalFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.mobileLabel.frame=CGRectMake([Util centerPointOfScreen].x - MOBILE_WIDTH/2, [Util centerPointOfScreen].y/2 + HEIGHT +10, MOBILE_WIDTH, TEXT_HEIGHT);
        
        self.developmentLabel.frame = CGRectMake([Util centerPointOfScreen].x - DEV_WIDTH/2, [Util centerPointOfScreen].y/2 + HEIGHT +10 + TEXT_HEIGHT, DEV_WIDTH, TEXT_HEIGHT);
        
        self.groupLabel.frame =  CGRectMake([Util centerPointOfScreen].x - MOBILE_WIDTH/2, [Util centerPointOfScreen].y/2 + HEIGHT +10 + 2*(TEXT_HEIGHT ), MOBILE_WIDTH, TEXT_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
            
            self.appleImage.alpha = 1;
            self.windowsImage.alpha = 1;
            self.androidImage.alpha = 1;
            self.blackberryImage.alpha = 1;
            
            [self animateLogos];
            
        } completion:^(BOOL finished) {
            
            [self releaseViews];
           if(!self.hasAppStarted) [self performSegueWithIdentifier:@"startApp" sender:nil];
        }];
    }];
}

-(void)animateLogos
{
    CAKeyframeAnimation * keyFrameAnimationForApple = [CAKeyframeAnimation animationWithKeyPath:@"position"];    keyFrameAnimationForApple.duration = 3;
    //  keyFrameAnimationForApple.repeatCount = 3;
    keyFrameAnimationForApple.calculationMode = kCAAnimationCubicPaced;
    keyFrameAnimationForApple.values = @[[NSValue valueWithCGPoint:self.appleImage.center],[NSValue valueWithCGPoint:self.windowsImage.center],[NSValue valueWithCGPoint:self.androidImage.center],[NSValue valueWithCGPoint:self.blackberryImage.center],[NSValue valueWithCGPoint:self.appleImage.center]];
    [self.appleImage.layer addAnimation:keyFrameAnimationForApple forKey:@"position"];
    
    CAKeyframeAnimation * keyFrameAnimationForWindows = [CAKeyframeAnimation animationWithKeyPath:@"position"];    keyFrameAnimationForWindows.duration = 3;
    //   keyFrameAnimationForWindows.repeatCount = 3;
    keyFrameAnimationForWindows.calculationMode = kCAAnimationCubicPaced;
    keyFrameAnimationForWindows.values = @[[NSValue valueWithCGPoint:self.windowsImage.center],[NSValue valueWithCGPoint:self.androidImage.center],[NSValue valueWithCGPoint:self.blackberryImage.center],[NSValue valueWithCGPoint:self.appleImage.center],[NSValue valueWithCGPoint:self.windowsImage.center]];
    [self.windowsImage.layer addAnimation:keyFrameAnimationForWindows forKey:@"position"];
    
    CAKeyframeAnimation * keyFrameAnimationForAndroid = [CAKeyframeAnimation animationWithKeyPath:@"position"];    keyFrameAnimationForAndroid.duration = 3;
    // keyFrameAnimationForAndroid.repeatCount = 3;
    keyFrameAnimationForAndroid.calculationMode = kCAAnimationCubicPaced;
    keyFrameAnimationForAndroid.values = @[[NSValue valueWithCGPoint:self.androidImage.center],[NSValue valueWithCGPoint:self.blackberryImage.center],[NSValue valueWithCGPoint:self.appleImage.center],[NSValue valueWithCGPoint:self.windowsImage.center],[NSValue valueWithCGPoint:self.androidImage.center]];
    [self.androidImage.layer addAnimation:keyFrameAnimationForAndroid forKey:@"position"];
    
    CAKeyframeAnimation * keyFrameAnimationForBlackberry = [CAKeyframeAnimation animationWithKeyPath:@"position"];    keyFrameAnimationForBlackberry.duration = 3;
    //  keyFrameAnimationForBlackberry.repeatCount = 3;
    keyFrameAnimationForBlackberry.calculationMode = kCAAnimationCubicPaced;
    keyFrameAnimationForBlackberry.values = @[[NSValue valueWithCGPoint:self.blackberryImage.center],[NSValue valueWithCGPoint:self.appleImage.center],[NSValue valueWithCGPoint:self.windowsImage.center],[NSValue valueWithCGPoint:self.androidImage.center],[NSValue valueWithCGPoint:self.blackberryImage.center]];
    [self.blackberryImage.layer addAnimation:keyFrameAnimationForBlackberry forKey:@"position"];
    

}

-(void) releaseViews
{

    self.mobileOnLeft = nil;
    self.mobileOnRight= nil;
    self.mobileLabel= nil;
    self.developmentLabel= nil;
    self.groupLabel = nil;
    self.appleImage= nil;
    self.androidImage= nil;
    self.windowsImage= nil;
    self.blackberryImage= nil;
}

- (IBAction)startApplication {
    
    self.hasAppStarted = YES;
    [self performSegueWithIdentifier:@"startApp" sender:nil];

    
}
@end
