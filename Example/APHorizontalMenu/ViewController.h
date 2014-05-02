//
//  ViewController.h
//  APHorizontalMenu
//
//  Created by Abel Pascual on 01/05/14.
//  Copyright (c) 2014 Abel Pascual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APHorizontalMenu.h"

@interface ViewController : UIViewController <APHorizontalMenuSelectDelegate>

@property (strong, nonatomic) NSArray *values;
@property (weak, nonatomic) IBOutlet APHorizontalMenu *horizontalMenu;

@end
