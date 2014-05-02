//
//  APHorizontalMenu.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 17/03/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "APHorizontalMenu.h"

@implementation APHorizontalMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(float)width cellHeight:(float)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellWidth = width;
        self.cellHeight = height;
        [self _configCell];
    }
    return self;
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(float)width cellHeight:(float)height
{
    return [[self alloc] initWithStyle:style reuseIdentifier:reuseIdentifier cellWidth:width cellHeight:height];
}

- (void)_configCell
{
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = AP_HORIZONTAL_MENU_TEXT_COLOR_DEFAULT;
    self.textLabel.highlightedTextColor = AP_HORIZONTAL_MENU_TEXT_SELECTED_COLOR_DEFAULT;
    
    self.bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellHeight)];
    self.bgColorView.backgroundColor = AP_HORIZONTAL_MENU_CELL_SELECTED_COLOR_DEFAULT;
    self.bgColorView.layer.masksToBounds = YES;
    [self setSelectedBackgroundView:self.bgColorView];
    
    self.customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cellWidth, self.cellHeight)];
    self.customView.contentMode = UIViewContentModeScaleAspectFit;
    self.customView.hidden = YES;
    self.customView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.customView];
}

- (void)setValue:(id)value
{
    self.textLabel.text = @"";
    _customView.hidden = NO;

    if ([value isKindOfClass:[NSString class]])
    {
        _customView.hidden = YES;
        self.textLabel.text = value;
    }
    else if ([value isKindOfClass:[UIImage class]])
    {
        _customView.image = value;
    }
    else if ([value isKindOfClass:[UIView class]])
    {
        _customView.image = nil;
        UIView *view = value;
        view.center = CGPointMake(self.cellWidth / 2, self.cellHeight / 2);
        [_customView addSubview:view];
    }
}

@end

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
    
    // Number of items visibles in iPhone / iPod Touch
    _visibleItems = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Number of items visible in iPad
        _visibleItems = 5;
    }
    
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

- (void)update {
    self.cellWidth = self.frame.size.width/self.visibleItems;
    self.backgroundColor = self.cellBackgroundColor;
    
    NSInteger viewWidth = self.frame.size.width;
    CGFloat f = (viewWidth-self.cellWidth)/2;
    [self.tableView setContentInset: UIEdgeInsetsMake(f, 0, f, 0)];
    self.clipsToBounds = YES;
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
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
    APHorizontalMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [APHorizontalMenuCell cellWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"Cell"
                                         cellWidth:self.cellWidth
                                        cellHeight:self.tableView.frame.size.height];
    }
    [cell setValue:[self.values objectAtIndex:indexPath.row]];
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
