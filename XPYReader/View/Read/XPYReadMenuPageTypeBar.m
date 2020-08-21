//
//  XPYReadMenuPageTypeBar.m
//  XPYReader
//
//  Created by zhangdu_imac on 2020/8/20.
//  Copyright © 2020 xiang. All rights reserved.
//

#import "XPYReadMenuPageTypeBar.h"

@interface XPYReadMenuPageTypeBar ()

@property (nonatomic, strong) UIButton *selectedTypeButton;

@end

@implementation XPYReadMenuPageTypeBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

#pragma mark - UI
- (void)configureUI {
    self.backgroundColor = XPYColorFromHex(0x232428);
    NSArray <NSString *> *pageTypes = @[@"仿真", @"上下", @"平移", @"无"];
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    [pageTypes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FontRegular(14);
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:XPYColorFromHex(0xdddddd) forState:UIControlStateNormal];
        [button setTitleColor:XPYColorFromHex(0xf46663) forState:UIControlStateSelected];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = XPYColorFromHex(0x555555).CGColor;
        button.tag = 1000 + idx;
        [button addTarget:self action:@selector(pageTypeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == [XPYReadConfigManager sharedInstance].pageType) {
            button.selected = YES;
            button.layer.borderColor = XPYColorFromHex(0xf46663).CGColor;
            self.selectedTypeButton = button;
        }
        [self addSubview:button];
        [buttons addObject:button];
    }];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:64 leadSpacing:20 tailSpacing:20];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(64, 33));
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Actions
- (void)pageTypeSelectAction:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    self.selectedTypeButton.selected = NO;
    self.selectedTypeButton.layer.borderColor = XPYColorFromHex(0x555555).CGColor;
    sender.selected = YES;
    sender.layer.borderColor = XPYColorFromHex(0xf46663).CGColor;
    self.selectedTypeButton = sender;
    
    // 更新阅读页翻页模式配置
    [XPYReadConfigManager sharedInstance].pageType = self.selectedTypeButton.tag - 1000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageTypeBarDidSelectType:)]) {
        [self.delegate pageTypeBarDidSelectType:self.selectedTypeButton.tag - 1000];
    }
}

@end
