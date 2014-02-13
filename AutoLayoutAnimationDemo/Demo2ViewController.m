//
//  Demo2ViewController.m
//  AutoLayoutAnimationDemo
//
//  Created by Jens Schwarzer on 13/02/14.
//  Copyright (c) 2014 marchv. All rights reserved.
//

#import "Demo2ViewController.h"

@interface Demo2ViewController ()
{
    NSMutableArray *_viewList;
    NSDictionary *_metrics;
}
@end

@implementation Demo2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0]];
    
    _metrics = @{@"height": @30,  // height of the views being added
                 @"space":  @15}; // space between two views
    
    // the first view
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectNull];
    _viewList = [[NSMutableArray alloc] initWithObjects:textView, nil];
    textView.text = [NSString stringWithFormat:@"view: %lu", (unsigned long)[_viewList count]];
    
    // a button to add more views
    UIButton *buttonAddView = [[UIButton alloc] initWithFrame:CGRectNull];
    [buttonAddView setTitle:@"add new view" forState:UIControlStateNormal];
    [buttonAddView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonAddView addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchDown];
    
    NSDictionary *subviews = NSDictionaryOfVariableBindings(textView, buttonAddView);
    
    for (id view in [subviews allValues]) {
        [[self view] addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    // initial constraints
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[buttonAddView]-|" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView(==height)]" options:0 metrics:_metrics views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buttonAddView]-|" options:0 metrics:nil views:subviews]];
}

-(void)buttonPushed:(UIButton*)button
{
    UITextView *prevView = [_viewList lastObject]; // get reference to previous view

    // create a new view
    UITextView *newView = [[UITextView alloc] initWithFrame:CGRectNull];
    [[self view] addSubview:newView];
    [newView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_viewList addObject:newView];
    newView.text = [NSString stringWithFormat:@"view: %lu", (unsigned long)[_viewList count]];

    NSDictionary *subviews = NSDictionaryOfVariableBindings(prevView, newView);

    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[newView]-|" options:0 metrics:nil views:subviews]];

#if 0
    // without animation
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]-space-[newView(==height)]" options:0 metrics:_metrics views:subviews]];
    [[self view] layoutIfNeeded];
#else
    // with animation
    
    // to begin with the new view gets zero height and no space to previous view
    NSArray *tempConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][newView(==0)]" options:0 metrics:_metrics views:subviews];

    [[self view] addConstraints:tempConstraints];
    [newView setAlpha:0.0f]; // starting point for fade-in
    [[self view] layoutIfNeeded]; // to ensure zero height is the starting point for the animation

    [UIView animateWithDuration:0.25f animations:^{
        [[self view] removeConstraints:tempConstraints]; // remove zero height constraint
        [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]-space-[newView(==height)]" options:0 metrics:_metrics views:subviews]]; // add final constraints
        [newView setAlpha:1.0f]; // fade-in
        [[self view] layoutIfNeeded];
    }];
#endif
}

@end
