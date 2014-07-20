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
    
    //stop back up swiping
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //setup back button
    self.navigationItem.backBarButtonItem.title = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    //and done button
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem.title = @"";

    
    //setup background color for the view
    UIColor * greyColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1.0f];
    self.view.backgroundColor = greyColor;
    self.transparentUIView.backgroundColor = greyColor;
    
    //make the profile picture rounded and set it
    self.profilePictureView.layer.cornerRadius = (self.profilePictureView.frame.size.height)/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *picUrl = [defaults URLForKey:@"profilePictureURL"];
    self.profilePictureView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL: picUrl]];
    
    //set user name
    self.nameTextField.text = [defaults valueForKey:@"userName"];
    
    //set the text field delegates as this controller
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
    [self.ageTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
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
    self.imagesScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.showsHorizontalScrollIndicator = NO;
    self.imagesScrollView.showsVerticalScrollIndicator = NO;
    self.imagesScrollView.clipsToBounds = NO;
    self.profilePictures = [self getProfilePictures];
    for(int i = 0; i < [self.profilePictures count]; i++)
    {
        
        CGRect frame;
        frame.origin.x = (self.imagesScrollView.frame.size.width * i);
        frame.origin.y = 60;
        frame.size = self.imagesScrollView.frame.size;
        
       // UIView *subview = [[UIView alloc] initWithFrame:frame];
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        [subview addSubview:[self.profilePictures objectAtIndex:i]];
        [self.imagesScrollView addSubview:subview];
    }
    
   self.imagesScrollView.contentSize = CGSizeMake(self.imagesScrollView.frame.size.width * self.profilePictures.count, self.imagesScrollView.frame.size.height);
    
    /* open the pearing client */
    _pearingClient = [PearingClient instance];
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
        pictureView.frame = CGRectMake(45.0f, 0.0f, 230.0f, 230.0f);
        [retArray addObject:pictureView];
    }
    return retArray;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self.transparentUIView pointInside:point withEvent:event]) {
		return self.imagesScrollView;
	}
	return nil;
}

-(IBAction)editingIsComplete:(id)sender {
    if( ![_nameTextField.text isEqualToString:@""] && ![_ageTextField.text isEqualToString:@""] ){
        self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(finishSegue:)];
    }
    else {
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
}

-(IBAction)finishSegue:(id)sender
{

    if([self savePerson]){
        //dismiss view and go to matches view controller
    UIViewController *openVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Matches"];
    [self presentViewController:openVC animated:YES completion:nil];

    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Problem"
                                                        message:@"We couldn't save you :( Try again?"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
}

-(BOOL)savePerson
{
    __block BOOL retVal = NO;
    //call server here to save the person
    [_pearingClient createNewUserWithName:_nameTextField.text
                    gender:(int)_genderSegment.selectedSegmentIndex
                    age:[_ageTextField.text integerValue]
                    description:_bioTextView.text
                    completion:^(BOOL success, NSString *error){
                        if (success) {
                            //do stuff
                            retVal = success;
                        }
                        else{
                            NSLog(@"%@", error);
                            retVal = NO;
                        }
    }];
    
    return retVal;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.ageTextField){
        NSInteger age = [textField.text integerValue];
        if(age < 18 && ![textField.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Age Restriction"
                                                            message:@"You must be over 18 to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            textField.text = @"";
        }
        else if(age > 100){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Age Restriction"
                                                            message:@"You must be alive to use this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            textField.text = @"";
            
        }
    }
    
    if(textField == self.nameTextField){
        if([textField.text isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hold on!"
                                                            message:@"You need a name!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            textField.text = @"";
        }
    }
    if([textField.text isEqualToString:@""]){
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldChanged:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
    
    if(textField == self.ageTextField){
        NSInteger age = [textField.text integerValue];
    
        if (textField.text.length > 1 && age >= 18 && age <= 100 && ![_nameTextField.text isEqualToString:@""]){
            self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(finishSegue:)];
        }
    }
}

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
