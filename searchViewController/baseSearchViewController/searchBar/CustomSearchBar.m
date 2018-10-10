//
//  CustomSearchBar.m
//  searchViewController
//
//  Created by 黄盼盼 on 19/9/18.
//  Copyright © 2018年 panpan. All rights reserved.
//

#import "CustomSearchBar.h"
#import "CommonDefine.h"

@implementation CustomSearchBar
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.font = [UIFont systemFontOfSize:14.f];
        self.backgroundColor = HEXCOLOR(0xf4f4f4);
        self.tintColor = [UIColor blackColor];
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeySearch;
        
        UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34.f, 20.f)];
        searchImageView.image = [UIImage imageNamed:@"ic-搜索"];
        searchImageView.contentMode = UIViewContentModeCenter;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = searchImageView;
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
