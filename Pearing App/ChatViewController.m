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
    //[self.conversationView addSubview:self.messageComposerView];
    [self.navigationController.view addSubview:self.messageComposerView];
    
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    self.swipe.direction = UISwipeGestureRecognizerDirectionDown;
    self.swipe.delegate = self;
    [self.conversationView addGestureRecognizer:self.swipe];
    
}

-(void) viewWillDisappear:(BOOL)animated {
//    My problem is that when I am on the chat screen(the tableview) and the keyboard is open (obviously with the message composer item on top) and I pop the chat screen off of the navigation controller, the keyboard dismisses down instead of sliding out to the right with the chat screen.
//    
//    Now, I believe the actual problem is that I attach the messageComposerView to the navigation controller (line 19) instead of the actual chat screen(the table view) because I if I attach it to the tableview I have not been able to get it to anchor to the bottom of the screen. So of course the keyboard dismisses down because it's not part of the chat screen being popped.
    
    [self.messageComposerView.inputAccessoryView resignFirstResponder];
    [self.messageComposerView removeFromSuperview];
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
