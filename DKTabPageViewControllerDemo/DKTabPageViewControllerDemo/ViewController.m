//
//  ViewController.m
//  DKTabPageViewControllerDemo
//
//  Created by 张奥 on 14-12-10.
//  Copyright (c) 2014年 ZhangAo. All rights reserved.
//

#import "ViewController.h"
#import "DKTabPageViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DKTabPageViewController *mainTabController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 4; i++) {
        TableViewController *vc = [TableViewController new];
        
        DKTabPageItem *item = [DKTabPageViewControllerItem tabPageItemWithTitle:@"消息"
                                                                 viewController:vc];
        [items addObject:item];
    }
    
    // add extra button
//    UIButton *extraButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [extraButton setTitle:@"Extra" forState:UIControlStateNormal];
//    [extraButton addTarget:self action:@selector(extraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [items addObject:[DKTabPageButtonItem tabPageItemWithButton:extraButton]];
    
    DKTabPageViewController *tabPageViewController = [[DKTabPageViewController alloc] initWithItems:items];
//    tabPageViewController.showTabPageBar = NO;
    tabPageViewController.contentInsets = UIEdgeInsetsMake(64, 0, 49, 0);
    [self addChildViewController:tabPageViewController];
    [self.view addSubview:tabPageViewController.view];
    
    self.mainTabController = tabPageViewController;
    
    [tabPageViewController setTabPageBarAnimationBlock:^(DKTabPageViewController *weakTabPageViewController, UIButton *fromButton, UIButton *toButton, CGFloat progress) {
        
        // animated font
        CGFloat pointSize = weakTabPageViewController.tabPageBar.titleFont.pointSize;
        CGFloat selectedPointSize = 18;
        
        fromButton.titleLabel.font = [UIFont systemFontOfSize:pointSize + (selectedPointSize - pointSize) * (1 - progress)];
        toButton.titleLabel.font = [UIFont systemFontOfSize:pointSize + (selectedPointSize - pointSize) * progress];
        
        // animated text color
        CGFloat red, green, blue;
        [weakTabPageViewController.tabPageBar.titleColor getRed:&red green:&green blue:&blue alpha:NULL];
        
        CGFloat selectedRed, selectedGreen, selectedBlue;
        [weakTabPageViewController.tabPageBar.selectedTitleColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:NULL];
        
        [fromButton setTitleColor:[UIColor colorWithRed:red + (selectedRed - red) * (1 - progress)
                                                  green:green + (selectedGreen - green) * (1 - progress)
                                                   blue: blue + (selectedBlue - blue) * (1 - progress)
                                                  alpha:1] forState:UIControlStateSelected];
        
        [toButton setTitleColor:[UIColor colorWithRed:red + (selectedRed - red) * progress
                                                green:green + (selectedGreen - green) * progress
                                                 blue:blue + (selectedBlue - blue) * progress
                                                alpha:1] forState:UIControlStateNormal];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)extraButtonClicked:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"This is a extra button"
                               delegate:nil
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles: nil]
     show];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 4; i++) {
            
            [self.mainTabController.tabPageBar showCircleDotBadge:YES forItemIndex:i];
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainTabController.tabPageBar showCircleDotBadge:NO forItemIndex:2];
    });
}

@end
