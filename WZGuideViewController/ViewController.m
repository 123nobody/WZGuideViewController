//
//  ViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "ViewController.h"
#import "WZGuideViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearButton setFrame:CGRectMake(60.f, 200.f, 200.f, 50.f)];
    [clearButton setTitle:@"清除运行记录" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(pressClearButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showButton setFrame:CGRectMake(60.f, 270.f, 200.f, 50.f)];
    [showButton setTitle:@"显示引导界面" forState:UIControlStateNormal];
    [showButton addTarget:self action:@selector(pressShowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exitButton setFrame:CGRectMake(60.f, 340.f, 200.f, 50.f)];
    [exitButton setTitle:@"结束程序" forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(pressExitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
}

- (void)pressClearButton:(UIButton *)clearButton
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pressShowButton:(UIButton *)showButton
{
    [WZGuideViewController show];
}

- (void)pressExitButton:(UIButton *)exitButton
{
    exit(0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
