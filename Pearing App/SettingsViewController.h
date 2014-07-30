//
//  SettingsViewController.h
//  Pearing App
//
//  Created by Dwayne Flaherty on 7/21/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UITextField *ageBegin;
@property (strong, nonatomic) IBOutlet UITextField *ageEnd;
@property (strong, nonatomic) IBOutlet UIButton *womenOrButton;
@property (strong, nonatomic) IBOutlet UIButton *menOrButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryView;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) NSString *textViewPlaceholder;
@property (strong, nonatomic) IBOutlet UITextField *distanceTextField;

@end
