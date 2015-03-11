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
    
    //I have no idea why I had to do this like this. touchesbegan was just not working, so fuck it. 
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)messageComposerSendMessageClickedWithMessage:(NSString*)message{
    
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.messageComposerView finishEditing];
}

@end
