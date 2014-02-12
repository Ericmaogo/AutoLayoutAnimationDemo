//
//  DemoViewController.m
//  AutoLayoutAnimationDemo
//
//  Created by Jens Schwarzer on 12/02/14.
//  Copyright (c) 2014 marchv. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
{
    UITextView *_hiddenTextView;
    NSArray *_constraintsHiddenState;
    NSArray *_constraintsVisibleState;
}
@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0]];

    NSString *textLoremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    
    _hiddenTextView = [[UITextView alloc] initWithFrame:CGRectNull];
    _hiddenTextView.text = [NSString stringWithFormat:@"%@ %@ %@ %@", textLoremIpsum, textLoremIpsum, textLoremIpsum, textLoremIpsum];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectNull];
    textView.text = [NSString stringWithFormat:@"%@ %@ %@ %@", textLoremIpsum, textLoremIpsum, textLoremIpsum, textLoremIpsum];
    
    UISwitch *switchToggleState = [[UISwitch alloc] initWithFrame:CGRectNull];
    [switchToggleState addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventValueChanged];

    NSDictionary *subviews = NSDictionaryOfVariableBindings(_hiddenTextView, textView, switchToggleState);
    
    for (id view in [subviews allValues]) {
        [[self view] addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    // first add the constraints that are used in both hidden and visible state
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hiddenTextView]-|" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[switchToggleState]-|" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_hiddenTextView]" options:0 metrics:nil views:subviews]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textView]-[switchToggleState]-|" options:0 metrics:nil views:subviews]];
    
    // then prepare constraints specific for both hidden and visible state
    _constraintsHiddenState = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hiddenTextView(==0)][textView]" options:0 metrics:nil views:subviews];
    _constraintsVisibleState = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hiddenTextView(==textView)]-[textView]" options:0 metrics:nil views:subviews];

    // and begin with the hidden state
    [[self view] addConstraints:_constraintsHiddenState];
    [_hiddenTextView setAlpha:0.0f]; // starting point for fading-in
}

-(void)toggleState:(id)uiSwitch
{
    [UIView animateWithDuration:1.0f animations:^{
        if ([uiSwitch isOn])
        {
            [[self view] removeConstraints:_constraintsHiddenState];
            [[self view] addConstraints:_constraintsVisibleState];
            [_hiddenTextView setAlpha:1.0f]; // fade-in
        }
        else
        {
            [[self view] removeConstraints:_constraintsVisibleState];
            [[self view] addConstraints:_constraintsHiddenState];
            [_hiddenTextView setAlpha:0.0f]; // fade-out
        }
        
        [[self view] layoutIfNeeded];
    }];
}

@end
