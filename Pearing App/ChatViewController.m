//
//  ChatViewController.m
//  Pearing
//
//  Created by Dwayne Flaherty on 3/10/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import "ChatViewController.h"

@implementation ChatViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    self.messageComposerView = [[MessageComposerView alloc] init];
    self.messageComposerView.delegate = self;
    //[self.view addSubview:self.messageComposerView];
    [self.navigationController.view addSubview:self.messageComposerView];
    
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    self.swipe.direction = UISwipeGestureRecognizerDirectionDown;
    self.swipe.delegate = self;
    [self.conversationView addGestureRecognizer:self.swipe];
    
}

- (void)messageComposerSendMessageClickedWithMessage:(NSString*)message{
    //whe send is clicked, we should take the text from the
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [self.messageComposerView finishEditing];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Needed to prevent UITableView from absorbing swipe gesture recognizer
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Needed to prevent UITableView from absorbing swipe gesture recognizer
    return YES;
}

@end
