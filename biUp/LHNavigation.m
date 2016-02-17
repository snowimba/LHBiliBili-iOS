//
//  LHNavigation.m
//  biUp
//
//  Created by snowimba on 15/12/18.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHNavigation.h"

@interface LHNavigation () <UIGestureRecognizerDelegate>

@end

@implementation LHNavigation

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{

    if (self.childViewControllers.count == 1) {
        return false;
    }
    return true;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
