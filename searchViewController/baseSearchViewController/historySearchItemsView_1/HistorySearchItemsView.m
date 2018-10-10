//
//  HistorySearchItemsView.m
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import "HistorySearchItemsView.h"
#import <Masonry.h>
#import "CommonDefine.h"

@interface HistorySearchItemsView()
@property (nonatomic, strong) UIButton *deleteHistoryButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray *historyArray;
@property (nonatomic, strong) UIView *itemsBackgroundView;
@end

@implementation HistorySearchItemsView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textColor = HEXCOLOR(0x999999);
        self.titleLabel.text = @"历史搜索";
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.f);
            make.top.equalTo(self).offset(15.f);
            make.size.mas_equalTo(self.titleLabel.bounds.size);
        }];
        
        self.deleteHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *deleteImage = [UIImage imageNamed:@"ic-搜索-删除记录"];
        [self.deleteHistoryButton setImage:deleteImage forState:UIControlStateNormal];
        [self.deleteHistoryButton addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteHistoryButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40.f-deleteImage.size.width, 0, 0);
        [self addSubview:self.deleteHistoryButton];
        [self.deleteHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15.f);
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        }];
        
        self.itemsBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.itemsBackgroundView];
        [self.itemsBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.deleteHistoryButton.mas_bottom);
        }];
    }
    return self;
}

- (void)setHistoryItemsArray:(NSArray<NSString *> *)array {
    self.historyArray = array;
    self.hidden = self.historyArray.count == 0;
    NSArray *itemsViewArray = self.itemsBackgroundView.subviews;
    for (UIView *templeItemView in itemsViewArray) {
        [templeItemView removeFromSuperview];
    }
    
    CGFloat originX = 15.f;
    CGFloat originY = 0.f;
    CGFloat itemWidth = 0.f;
    CGFloat itemHeight = 0.f;
    
    for (NSInteger i=0; i < self.historyArray.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = i;
        itemButton.backgroundColor = HEXCOLOR(0xf4f4f4);
        itemButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [itemButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        itemButton.titleEdgeInsets = UIEdgeInsetsMake(2, 12.f, 2, 12.f);
        itemButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [itemButton setTitle:self.historyArray[i] forState:UIControlStateNormal];
        [itemButton.titleLabel sizeToFit];
        
        itemWidth = CGRectGetWidth(itemButton.titleLabel.bounds) + 12.f*2;
        itemHeight = CGRectGetHeight(itemButton.titleLabel.bounds) + 4.f*2;
        if (itemWidth > ScreenWidth - 15.f*2) {
            itemWidth = ScreenWidth - 15.f*2;
        }
        
        if (originX + itemWidth > ScreenWidth) {
            originX = 15.f;
            originY += itemHeight + 10.f;
        }
        
        itemButton.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        itemButton.layer.cornerRadius = itemHeight / 2.f;
        itemButton.clipsToBounds = YES;
        originX += itemWidth + 15.f;
        
        [self.itemsBackgroundView addSubview:itemButton];
        [itemButton addTarget:self action:@selector(historyItemSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)historyItemSelectAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(historySearchItemsView:didSelectItem:)]) {
        [self.delegate historySearchItemsView:self didSelectItem:self.historyArray[button.tag]];
    }
}

- (void)deleteHistory:(id)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(HistorySearchItemsViewDeleteRecords)]) {
        [self.delegate HistorySearchItemsViewDeleteRecords];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
