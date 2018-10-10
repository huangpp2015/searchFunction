//
//  HistorySearchItemsView.h
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistorySearchItemsView;
@protocol HistorySearchItemsViewDelegate <NSObject>
- (void)historySearchItemsView:(HistorySearchItemsView *)historySearchItemsView didSelectItem:(NSString *)item;
@optional
- (void)HistorySearchItemsViewDeleteRecords;
@end

@interface HistorySearchItemsView : UIView

@property (nonatomic, weak) id <HistorySearchItemsViewDelegate> delegate;

//设置历史items
- (void)setHistoryItemsArray:(NSArray <NSString *> *)array;
@end
