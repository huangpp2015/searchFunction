//
//  MySearchViewController.m
//  searchViewController
//
//  Created by 黄盼盼 on 28/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import "MySearchViewController.h"
#import "HistorySearchItemsView.h"
#import "CommonDefine.h"
#import <Masonry.h>

static NSString * const searchRecordKey = @"MySearchVCSearchRecordKey";

@interface MySearchViewController ()<HistorySearchItemsViewDelegate>

@end

@implementation MySearchViewController

- (void)viewDidLoad {
    UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNaviBarHeight)];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noDataLabel.font = [UIFont systemFontOfSize:17.f];
    noDataLabel.textColor = HEXCOLOR(0x999999);
    noDataLabel.text = @"暂无数据";
    [noDataLabel sizeToFit];
    [noDataView addSubview:noDataLabel];
    [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(noDataView);
    }];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"清单"]];
    [noDataView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noDataView);
        make.bottom.equalTo(noDataLabel.mas_top).offset(-20.f);
        make.size.mas_equalTo(CGSizeMake(80.f, 80.f));
    }];
    self.noDataView = noDataView;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HistorySearchItemsView *myHistoryView = [[HistorySearchItemsView alloc] initWithFrame:self.view.bounds];
    [myHistoryView setHistoryItemsArray:[self getHistoryForKey:searchRecordKey]];
    myHistoryView.delegate = self;
    self.historyView = myHistoryView;
    
}

- (void)startSearch:(NSString *)keyword {
    [super startSearch:keyword];
    [self saveItem:keyword forKey:searchRecordKey maxSize:6];
    [(HistorySearchItemsView *)self.historyView setHistoryItemsArray:[self getHistoryForKey:searchRecordKey]];
}

- (NSArray *)searchResultWithKeyword:(NSString *)keyword
                              offset:(NSInteger)offset
                            pageSize:(NSInteger)pageSize {
    NSLog(@"%@---%ld---%ld",keyword,(long)offset,(long)pageSize);
    if ([keyword isEqualToString:@"2"]) {
        return @[];
    }
    return @[@"1", @"2"];
}

- (void)historySearchItemsView:(HistorySearchItemsView *)historySearchItemsView
                 didSelectItem:(NSString *)item {
    [self startSearch:item];
    NSLog(@"%@",item);
}

- (void)HistorySearchItemsViewDeleteRecords {
    NSLog(@"我要删除自己了");
    [self clearHistoryForKey:searchRecordKey];
}

- (BOOL)needLoadMore {
    return YES;
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
