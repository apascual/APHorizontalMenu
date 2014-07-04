//
//  APHorizontalMenu.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "APHorizontalMenu.h"

@interface APHorizontalMenu ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger cellWidth;
@property (nonatomic) BOOL isTouchAnimation;

@end

@implementation APHorizontalMenu

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self customInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    
    _selectedIndex = AP_HORIZONTAL_MENU_SELECTED_INDEX_DEFAULT;
    _cellSelectedColor = AP_HORIZONTAL_MENU_CELL_SELECTED_COLOR_DEFAULT;
    _cellBackgroundColor = AP_HORIZONTAL_MENU_CELL_BACKGROUND_COLOR_DEFAULT;
    _textColor = AP_HORIZONTAL_MENU_TEXT_COLOR_DEFAULT;
    _textSelectedColor = AP_HORIZONTAL_MENU_TEXT_SELECTED_COLOR_DEFAULT;
    _textFont = AP_HORIZONTAL_MENU_TEXT_FONT;
    
    // Number of items visibles in iPhone / iPod Touch
    _visibleItems = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Number of items visible in iPad
        _visibleItems = 5;
    }
}

- (void)createMenuControl {
    [self.tableView removeFromSuperview];
    self.tableView=nil;
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.height,self.frame.size.width);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    
    CGPoint oldCenter = self.center;
    oldCenter.y = frame.size.width/2;
    self.tableView.transform=CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.center = oldCenter;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setDecelerationRate: UIScrollViewDecelerationRateNormal];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createMenuControl];
    [self update];
}

#pragma mark - Custom setters

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex) {
        [self setCurrentIndex:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES];
    }
}

- (void)setValues:(NSArray *)values
{
    if(_values != values) {
        _values = values;
        [self update];
    }
}

- (void)setCellSelectedColor:(UIColor *)cellSelectedColor {
    _cellSelectedColor = cellSelectedColor;
    [self update];
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor {
    _cellBackgroundColor = cellBackgroundColor;
    [self update];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self update];
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor {
    _textSelectedColor = textSelectedColor;
    [self update];
}

- (void)setVisibleItems:(NSInteger)visibleItems {
    _visibleItems = visibleItems;
    [self update];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self update];
}

- (void)update {
    self.cellWidth = self.frame.size.width/self.visibleItems;
    self.backgroundColor = self.cellBackgroundColor;
    
    NSInteger viewWidth = self.frame.size.width;
    CGFloat f = (viewWidth-self.cellWidth)/2;
    [self.tableView setContentInset: UIEdgeInsetsMake(f, 0, f, 0)];
    self.clipsToBounds = YES;
    
    [self.tableView reloadData];
    if(self.values.count > self.selectedIndex)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark - UITableView control

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.font = self.textFont;
    cell.textLabel.textColor = self.textColor;
    cell.textLabel.highlightedTextColor = self.textSelectedColor;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = self.cellSelectedColor;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.textLabel.text = [self.values objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isTouchAnimation = YES;
    [self setCurrentIndex:indexPath animated:YES];
}

#pragma mark - Scroll control

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isTouchAnimation)
    {
        CGPoint point = [self convertPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) toView:self.tableView];
        NSIndexPath* centerIndexPath = [self.tableView indexPathForRowAtPoint:point];
        [self.tableView selectRowAtIndexPath:centerIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self centerTable];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerTable];
}

- (void)centerTable {
    CGPoint point = [self convertPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) toView:self.tableView];
    NSIndexPath* centerIndexPath = [self.tableView indexPathForRowAtPoint:point];
    [self setCurrentIndex:centerIndexPath animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isTouchAnimation = NO;
}

- (void) setCurrentIndex:(NSIndexPath *)indexPath animated:(BOOL)animated {
    if(self.isTouchAnimation || _selectedIndex != indexPath.row) {
        
        [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionTop];
        
        if(_selectedIndex != indexPath.row) {
            _selectedIndex = indexPath.row;
            
            if ([self.delegate respondsToSelector:@selector(horizontalMenu:didSelectPosition:)]) {
                [self.delegate horizontalMenu:self didSelectPosition:indexPath.row];
            }
        }
    }
}

@end
