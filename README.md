# APHorizontalMenu

[![Version](http://cocoapod-badges.herokuapp.com/v/APHorizontalMenu/badge.png)](http://cocoadocs.org/docsets/APHorizontalMenu)
[![Platform](http://cocoapod-badges.herokuapp.com/p/APHorizontalMenu/badge.png)](http://cocoadocs.org/docsets/APHorizontalMenu)

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Installation

APHorizontalMenu is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "APHorizontalMenu"

## Example

![iPhone](https://raw.githubusercontent.com/apascual/APHorizontalMenu/master/Images/APHorizontalMenu.gif)

## Usage

Using APHorizontalMenu is really easy, there is an Example project that you can check, but here are the basics.

You can add APHorizontalMenu programmatically or using Storyboards.

### Programmatically

Just init the APHorizontalMenu, fill it with values and add it to an existing view.

```objc
APHorizontalMenu *horizontalMenu = [[APHorizontalMenu alloc] initWithFrame:CGRectMake(0, 200, 320, 40)];
horizontalMenu.delegate = self;
horizontalMenu.values = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5", @"Item 6", @"Item 7", @"Item 8", @"Item 9", @"Item 10"];
[self.view addSubview:horizontalMenu];
```

### Storyboards

In this case, create a new UIView using the Storyboards UI designer and set the position, size and layout restrictions as desired. Then, go to the Utilities -> Identity inspector -> Custom class -> Class and write down "APHorizontalMenu".

Then, create an outlet as follows in your Controller.

```objc
@property (weak, nonatomic) IBOutlet APHorizontalMenu *horizontalMenu;
````

And in the implementation file of your controller add at least this.

```objc
self.horizontalMenu.delegate = self;
````

### Delegate

Do not forget to add implement the APHorizontalMenuDelegate as follows. First add the Delegate in the header file of your controller, for example:

```objc
@interface ViewController : UIViewController <APHorizontalMenuSelectDelegate>
````

And conform the protocol by creating the method in the implementation file of your controller so you can receive messages:

```objc
- (void)horizontalMenu:(id)horizontalMenu didSelectPosition:(NSInteger)index {
    NSLog(@"APHorizontalMenu selection: %d", index);
    // Do whatever
}
````

### Customization

You can customize some of the properties of APHorizontalMenu like this:

```objc
self.horizontalMenu.cellBackgroundColor = [UIColor brownColor];
self.horizontalMenu.cellSelectedColor = [UIColor greenColor];
self.horizontalMenu.textColor = [UIColor blackColor];
self.horizontalMenu.textSelectedColor = [UIColor blueColor];
self.horizontalMenu.selectedIndex = 2;
self.horizontalMenu.visibleItems = 3;
```

## Contact

Abel Pascual

* Mail: [abelpascual@gmail.com](mailto:abelpascual@gmail.com)
* Twitter: [@Abel_Pascual](https://twitter.com/Abel_Pascual)

## License

APHorizontalMenu is available under the MIT license. See the LICENSE file for more info.

