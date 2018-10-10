//
//  ExampleViewController.m
//  searchViewController
//
//  Created by 黄盼盼 on 28/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import "ExampleViewController.h"
#import "CustomSearchBar.h"
#import "MySearchViewController.h"
#import "CommonDefine.h"

@interface ExampleViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) CustomSearchBar *searchBar;
@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(15.f, 10.f, ScreenWidth - 15.f * 2, 34.f)];
    self.searchBar.layer.cornerRadius = CGRectGetHeight(self.searchBar.bounds)/2.f;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    MySearchViewController *searchVC = [[MySearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
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
