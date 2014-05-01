//
//  APHorizontalMenu.h
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import <UIKit/UIKit.h>

// Default values
#define AP_HORIZONTAL_MENU_SELECTED_INDEX_DEFAULT 0
#define AP_HORIZONTAL_MENU_CELL_BACKGROUND_COLOR_DEFAULT [UIColor grayColor]
#define AP_HORIZONTAL_MENU_CELL_SELECTED_COLOR_DEFAULT [UIColor colorWithRed:150.0/255.0 green:200.0/255.0 blue:150.0/255.0 alpha:1.0]
#define AP_HORIZONTAL_MENU_TEXT_COLOR_DEFAULT [UIColor whiteColor]
#define AP_HORIZONTAL_MENU_TEXT_SELECTED_COLOR_DEFAULT [UIColor grayColor]

// Protocol to get the selected item
@protocol APHorizontalMenuSelectDelegate <NSObject>

@required
- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index;

@end

@interface APHorizontalMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet id<APHorizontalMenuSelectDelegate> delegate;
@property (nonatomic, copy) NSArray *values;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) NSInteger visibleItems;

@property (nonatomic, strong) UIColor *cellSelectedColor;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textSelectedColor;

@end
