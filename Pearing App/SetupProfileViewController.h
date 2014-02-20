//
//  SetupProfileViewController.h
//  Pearing App
//
//  Created by Nathan Ziebart on 12/31/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SetupProfileViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (strong, nonatomic) NSString *textViewPlaceholder;
@property (strong, nonatomic) NSMutableArray *selectedPictures;
@property (strong, nonatomic) NSMutableArray *profilePictures;
@property (strong, nonatomic) IBOutlet UIView *transparentUIView;

-(IBAction)editingIsComplete:(id)sender;


@end
