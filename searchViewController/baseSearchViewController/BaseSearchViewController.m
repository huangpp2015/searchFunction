//
//  BaseSearchViewController.m
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import "BaseSearchViewController.h"
#import "CustomSearchBar.h"

#import "MJRefresh.h"
#import "CommonDefine.h"

@interface BaseSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) CustomSearchBar *searchBar;

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *historySearchRecordKey;
@property (nonatomic, strong) NSMutableArray *historySearchRecordArray;
@end

@implementation BaseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
}

- (NSArray *)searchResultWithKeyword:(NSString *)keyword
                              offset:(NSInteger)offset
                            pageSize:(NSInteger)pageSize {
    self.pageSize = pageSize;
    return self.dataMutableArray;
}

- (void)setUI {
#warning 工程中自定义navigationBar可省略这一行
    self.navigationItem.hidesBackButton = YES;
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34.f)];
    self.searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectMake(0, 2.f, ScreenWidth - 55.f - 15.f, 32.f)];
    self.searchBar.layer.cornerRadius = CGRectGetHeight(self.searchBar.bounds)/2.f;
    self.searchBar.placeholder = self.placeholderString;
    self.searchBar.text = self.keyword;
    self.searchBar.delegate = self;
    [naviView addSubview:self.searchBar];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:HEXCOLOR(0x27A5F9) forState:UIControlStateNormal];
    cancleButton.frame = CGRectMake(ScreenWidth - 55.f - 10.f, 0, 45.f, 34.f);
    [cancleButton addTarget:self action:@selector(cancleSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:cancleButton];
    
    self.navigationItem.titleView = naviView;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = HEXCOLOR(0xe8e8e8);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15.f, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self)weakSelf = self;
    MJRefreshFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    refreshFooter.hidden = YES;
    self.tableView.mj_footer = refreshFooter;
    
    if (self.noDataView) {
        [self.view addSubview:self.noDataView];
        self.noDataView.hidden = YES;
    }
}

- (void)cancleSearchAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


//加载更多
/*
 1.endRefresh
 2.appandData
 3.reloadData
 */
- (void)loadMoreData {
    if ([self respondsToSelector:@selector(searchResultWithKeyword:offset:pageSize:)]) {
        NSArray *moreDataArray = [self searchResultWithKeyword:self.keyword offset:self.dataMutableArray.count pageSize:self.pageSize];
        
        if (moreDataArray.count == self.pageSize) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (moreDataArray.count) {
            [self.dataMutableArray addObjectsFromArray:moreDataArray];
        }
        
        [self.tableView reloadData];
    }
}

//开始搜索
/*
 1.设置keyword
 2.reloadData
 3.重置mj_refreshFooter
 4.历史搜索词隐藏
 5.重新判断空白页是否应该显示
 */
- (void)startSearch:(NSString *)keyword {
    self.keyword = keyword;
    self.searchBar.text = self.keyword;
    self.tableView.contentOffset = CGPointZero;
    [self.dataMutableArray removeAllObjects];
    [self loadMoreData];
    [self.historyView removeFromSuperview];
    [self.searchBar endEditing:YES];
    if (self.noDataView && self.dataMutableArray.count == 0) {
        self.noDataView.hidden = NO;
    }
}

#pragma mark -- UITextFieldDelegate
/*
 1.空白页隐藏
 2、历史数据页出现
 3、清除button出现
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.noDataView.hidden = YES;
    if (!self.historyView.superview && self.historySearchRecordArray.count && self.historyView) {
        [self.view addSubview:self.historyView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startSearch:textField.text];
    return YES;
}

#pragma mark -- UITableViewDelegate&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"**** %@ *****",self.dataMutableArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - historySearchRecord
- (void)clearHistoryForKey:(NSString *)key {
    if (key.length) {
        [self.historySearchRecordArray removeAllObjects];
        [[NSFileManager defaultManager] removeItemAtPath:[self getFilePathForKey:key] error:nil];
    }
}

- (void)saveItem:(NSString *)text
          forKey:(NSString *)key
         maxSize:(NSInteger)size {
    
    if (text.length && key.length) {
        NSMutableArray *templeMutableArray = [NSMutableArray array];
        NSArray *oldDataArray = [self getHistoryForKey:key];
        
        if (oldDataArray.count) {
            [templeMutableArray addObjectsFromArray:oldDataArray];
        }
        
        if ([templeMutableArray containsObject:text]) {
            [templeMutableArray removeObject:text];
        }
        [templeMutableArray insertObject:text atIndex:0];
        
        if (templeMutableArray.count > size) {
            [templeMutableArray removeLastObject];
        }
        [templeMutableArray writeToFile:[self getFilePathForKey:key] atomically:YES];
    }
}

- (NSArray<NSString *> *)getHistoryForKey:(NSString *)key {
    NSArray *templeHistoryItemsArray = @[];
    [self.historySearchRecordArray removeAllObjects];
    if (key.length) {
        NSString *filePath = [self getFilePathForKey:key];
        templeHistoryItemsArray = [NSArray arrayWithContentsOfFile:filePath];
        [self.historySearchRecordArray addObjectsFromArray:templeHistoryItemsArray];
    }
    return templeHistoryItemsArray;
}

- (NSString *)getFilePathForKey:(NSString *)key {
    NSString *filePath = @"";
    if (key) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        filePath = [path stringByAppendingPathComponent:key];
    }
    return filePath;
}

#pragma mark - setter
- (void)setNeedLoadMore:(BOOL)needLoadMore {
    _needLoadMore = needLoadMore;
    self.tableView.mj_footer.hidden = !_needLoadMore;
}

#pragma mark - getter
- (NSMutableArray *)historySearchRecordArray {
    if (_historySearchRecordArray == nil) {
        _historySearchRecordArray = [NSMutableArray array];
    }
    return _historySearchRecordArray;
}

- (NSInteger)pageSize {
    if (_pageSize == 0) {
        _pageSize = 10;
    }
    return _pageSize;
}

- (NSMutableArray *)dataMutableArray {
    if (_dataMutableArray == nil) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
}

- (NSString *)placeholderString {
    if (_placeholderString == nil) {
        _placeholderString = @"请输入关键词";
    }
    return _placeholderString;
}

- (void)didReceiveMemoryWarning {
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
