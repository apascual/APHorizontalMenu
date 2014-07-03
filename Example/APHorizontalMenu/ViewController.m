//
//  ViewController.m
//  APHorizontalMenu
//
//  Created by Abel Pascual on 01/05/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.horizontalMenu.values = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6", @"Item 7", @"Item 8", @"Item 9", @"Item 10"];
    self.horizontalMenu.delegate = self;
    
    // Optional settings
    //self.horizontalMenu.cellBackgroundColor = [UIColor brownColor];
    //self.horizontalMenu.cellSelectedColor = [UIColor greenColor];
    //self.horizontalMenu.textColor = [UIColor blackColor];
    //self.horizontalMenu.textSelectedColor = [UIColor blueColor];
    //self.horizontalMenu.selectedIndex = 2;
    //self.horizontalMenu.visibleItems = 3;
    
    APHorizontalMenu *menu2 = [[APHorizontalMenu alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
    menu2.values = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6", @"Item 7", @"Item 8", @"Item 9", @"Item 10"];
    [self.view addSubview:menu2];
}

- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index {
    NSLog(@"APHorizontalMenu selection: %ld", (long)index);
}

@end
