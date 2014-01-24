//
//  SetupProfileViewController.m
//  Pearing App
//
//  Created by Nathan Ziebart on 12/31/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "SetupProfileViewController.h"

@interface SetupProfileViewController ()

@end

@implementation SetupProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Edit Profile";
    
    //setup back button
    self.navigationItem.backBarButtonItem.title = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //setup background color for the view
    UIColor * greyColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
    self.view.backgroundColor = greyColor;
    
    //make the profile picture rounded and set it
    self.profilePictureView.layer.cornerRadius = (self.profilePictureView.frame.size.height)/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *picUrl = [defaults URLForKey:@"profilePictureURL"];
    self.profilePictureView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL: picUrl]];
    
    //set user name
    self.nameTextField.text = [defaults valueForKey:@"userName"];
    
    //make text view look similar to age/name text fields
    self.bioTextView.delegate = self;
    [self.bioTextView.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.bioTextView.layer setBorderWidth:.5];
    self.bioTextView.layer.cornerRadius = 5;
    self.bioTextView.clipsToBounds = YES;
    self.bioTextView.text = [defaults valueForKey:@"userBio"];
    self.textViewPlaceholder = @"A short bio...";
    
    //setup color for gender picker
    UIColor * orangeColor = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
    self.genderSegment.tintColor = orangeColor;
    
    //setup scrollview
    self.imagesScrollView.delegate = self;
    self.imagesScrollView.contentInset = UIEdgeInsetsMake(0, 60.0, 0, 0);
    self.imagesScrollView.pagingEnabled = YES; 
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    self.profilePictures = [self getProfilePictures];
    for(int i = 0; i < [self.profilePictures count]; i++)
    {
        CGRect frame;
        frame.origin.x = self.imagesScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.imagesScrollView.frame.size;
        
       // UIView *subview = [[UIView alloc] initWithFrame:frame];
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        [subview addSubview:[self.profilePictures objectAtIndex:i]];
        [self.imagesScrollView addSubview:subview];
    }
    
   self.imagesScrollView.contentSize = CGSizeMake(self.imagesScrollView.frame.size.width * self.profilePictures.count, self.imagesScrollView.frame.size.height);
    //self.imagesScrollView.contentSize = CGSizeMake(95, 95);
    
	// Do any additional setup after loading the view.
}

-(NSMutableArray *)getProfilePictures
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.selectedPictures count]; i++)
    {
        NSDictionary *imageData = self.selectedPictures[i];
        NSURL *lowResURL = [NSURL URLWithString:imageData[@"images"][@"low_resolution"][@"url"]];
        UIImageView *pictureView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:lowResURL]]];
        pictureView.frame = CGRectMake(0.0f, 0.0f, 280.0f, 260.0f);
        [retArray addObject:pictureView];
    }
    return retArray;
}

//- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //CGFloat pageWidth = self.imagesScrollView.frame.size.width;
    //int page = floor((self.imagesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //self.imagesPageControl.currentPage = page;
//}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.textViewPlaceholder]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.textViewPlaceholder;
        textView.textColor = [UIColor colorWithRed:196/255.0f green:196/255.0f blue:196/255.0f alpha:1.0f];;
    }
    [textView resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.bioTextView isFirstResponder] && [touch view] != self.bioTextView) {
        [self.bioTextView resignFirstResponder];
    }
    
    if ([self.nameTextField isFirstResponder] && [touch view] != self.nameTextField) {
        [self.nameTextField resignFirstResponder];
    }
    
    if ([self.ageTextField isFirstResponder] && [touch view] != self.ageTextField) {
        [self.ageTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
