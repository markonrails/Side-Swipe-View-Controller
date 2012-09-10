//
//  AppDelegate.h
//  SideSwipe
//
//  Created by Mark(Yiming) Chen on 7/9/12.
//  Copyright (c) 2012 Zegla. All rights reserved.
//

#import "ViewController.h"

#define kViewWidth  320
#define kViewHeight 460 - 44

#define kNumOfTableviews 3

@interface ViewController ()

- (void)addTableViews; 
- (void)scrollToDefault;
- (void)displayTitle;

@end

@implementation ViewController {
    BOOL pageControlUsed;
    NSArray *titles;
}

@synthesize scrollView;
@synthesize titleLabel;

@synthesize pageControl;
@synthesize pageControlBackground;
@synthesize tableViews;
@synthesize tableIndex;

#pragma mark - Controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* configure title */
    
    titles = [NSArray arrayWithObjects:@"Table 1", @"Table 2", @"Table 3", nil];
    // add your customized titles for the three table views
    
    self.tableIndex = [NSNumber numberWithInt:0];
    // set your preferred index
    
    /* configure scroll view */
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.scrollsToTop  = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kViewWidth * (kNumOfTableviews + 2), kViewHeight);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    
    [self addTableViews];
    [self scrollToDefault];
    
    /* configure page control */
    
    pageControlUsed = NO;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kViewHeight+24, kViewWidth, 20)];
    self.pageControl.numberOfPages = kNumOfTableviews;
    self.pageControl.currentPage   = [tableIndex intValue];
    [self.pageControl addTarget:self action:@selector(changePage) 
               forControlEvents:UIControlEventValueChanged];
    
    self.pageControlBackground = [[UIImageView alloc] initWithFrame:self.pageControl.frame];
    self.pageControlBackground.backgroundColor = [UIColor blackColor];
    self.pageControlBackground.alpha = 0.3;
    
    [self.view addSubview:self.pageControlBackground];
    [self.view addSubview:self.pageControl];
    
    [self displayTitle];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/* Change the following methods to make data for your table views */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellString = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    cell.textLabel.text = cellString;
    
    return cell;
}

#pragma mark - Help methods

- (void)addTableViews
{
    // add table views to the scroll view
    
    self.tableViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < kNumOfTableviews+2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kViewWidth*i, 0, kViewWidth, kViewHeight) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate   = self;
        [self.tableViews addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
}

- (void)scrollToDefault
{
    CGFloat defaultX = [self.tableIndex intValue] * kViewWidth + kViewWidth;
    CGRect frame = CGRectMake(defaultX, 0, kViewWidth, kViewHeight);
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)displayTitle
{
    NSString *title = [titles objectAtIndex:self.pageControl.currentPage];
    [self.titleLabel setText:title];
    // [self.navigationItem setTitle:title];
}

- (void)changePage
{
    int page = pageControl.currentPage + 1;
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
    
    [self displayTitle];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    if (pageControlUsed || theScrollView != self.scrollView) return;

    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((theScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == 0) pageControl.currentPage = 2;
    else if (page > kNumOfTableviews) pageControl.currentPage = 0;
    else pageControl.currentPage = page - 1;
    
    [self displayTitle];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    if (theScrollView == self.scrollView) {
        if (pageControl.currentPage == 0 ||
            pageControl.currentPage == kNumOfTableviews - 1) {
            CGFloat x = pageControl.currentPage * kViewWidth + kViewWidth;
            CGRect frame = CGRectMake(x, 0, kViewWidth, kViewHeight);
            [self.scrollView scrollRectToVisible:frame animated:NO];
        }
        
        pageControlUsed = NO;
    } else {
        UITableView *thisTableView = (UITableView *)theScrollView;
        
        int thisIndex = [tableViews indexOfObject:thisTableView];
        if (thisIndex != 1 && thisIndex != kNumOfTableviews) return;
        int thatIndex;
        if (thisIndex == 1) thatIndex = tableViews.count - 1;
        else thatIndex = 0;
        
        UITableView *thatTableView = [tableViews objectAtIndex:thatIndex];
        
        CGRect frame;
        frame.origin = thisTableView.contentOffset;
        frame.size   = thisTableView.bounds.size;
        
        [thatTableView scrollRectToVisible:frame animated:NO];
    }
}

@end
