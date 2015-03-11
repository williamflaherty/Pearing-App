//
//  ChatViewController.h
//  Pearing
//
//  Created by Dwayne Flaherty on 3/10/15.
//  Copyright (c) 2015 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"

@interface ChatViewController : UIViewController <MessageComposerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property (strong, nonatomic) IBOutlet UITableView *conversationView;

@end
