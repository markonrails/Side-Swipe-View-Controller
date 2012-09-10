//
//  AppDelegate.h
//  SideSwipe
//
//  Created by Mark(Yiming) Chen on 7/9/12.
//  Copyright (c) 2012 Zegla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController 
    <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;  
// reference this to the scroll view you want to do side swipe on

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
// reference this to the label to display the table title

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIImageView *pageControlBackground;
@property (strong, nonatomic) NSMutableArray *tableViews;
@property (retain, nonatomic) NSNumber *tableIndex;

@end
