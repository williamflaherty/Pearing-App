//
//  SetupProfileViewController.h
//  Pearing App
//
//  Created by Nathan Ziebart on 12/31/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PearingClient.h"

@interface SetupProfileViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic) PearingClient *pearingClient;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (strong, nonatomic) NSString *textViewPlaceholder;
@property (strong, nonatomic) NSMutableArray *selectedPictures;
@property (strong, nonatomic) NSMutableArray *profilePictures;
@property (nonatomic, retain) IBOutlet UIToolbar    *accessoryView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) NSString *birthday;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UIView *transparentUIView;

@end
