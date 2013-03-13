//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"

@interface WZGuideViewController ()

@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
    
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    [self.view addSubview:self.pageScroll];
    
    NSString *imgName = nil;
    UIView *view;
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {            
            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            [checkButton setSelected:YES];
            [view addSubview:checkButton];
            
            UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 175.f, 35.f)];
            [enterButton setTitle:@"开始使用WeeOA" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [enterButton setCenter:CGPointMake(self.view.center.x, 417.f)];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_press"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
