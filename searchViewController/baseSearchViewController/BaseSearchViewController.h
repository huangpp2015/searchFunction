//
//  BaseSearchViewController.h
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSearchViewController : UIViewController

///> 历史搜索view
@property (nonatomic, strong) UIView *historyView;

///> 无搜索结果view
@property (nonatomic, strong) UIView *noDataView;

///> 搜索结果是否需要上拉加载更多
@property (nonatomic, assign) BOOL needLoadMore;

///>分页数据条数
@property (nonatomic, assign) NSInteger pageSize;
///>输入关键词最大长度，默认不限制，为0
@property (nonatomic, assign) NSInteger maxInputWordNumber;
///>超过准许输入关键词最大长度弹出的提示语
@property (nonatomic, copy) NSString *overInputToastString;

@property (nonatomic, copy) NSString *placeholderString;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataMutableArray;


/**
 开始搜索
 继承需调用super方法

 @param keyword 搜索关键字
 */
- (void)startSearch:(NSString *)keyword;

/**
 返回搜索结果数据，需重写此方法
 @param keyword 搜索关键字
 @param offset 偏移量，多页搜索的时候需要使用
 @param pageSize 一页的大小，多页搜索需要使用
 @return 搜索结果数据
 */
- (NSArray *)searchResultWithKeyword:(NSString *)keyword
                              offset:(NSInteger)offset
                            pageSize:(NSInteger)pageSize;

/**
 存储历史搜索记录

 @param text 搜索keyword
 @param key 历史记录存储标识
 @param size 最大存储条数
 */
- (void)saveItem:(NSString *)text
          forKey:(NSString *)key
         maxSize:(NSInteger)size;

/**
 获取搜索历史记录

 @param key 历史记录存储标识
 @return  存储的历史记录
 */
- (NSArray <NSString *>*)getHistoryForKey:(NSString *)key;

/**
 清除历史记录

 @param key 历史记录存储标识
 */
- (void)clearHistoryForKey:(NSString *)key;
@end
