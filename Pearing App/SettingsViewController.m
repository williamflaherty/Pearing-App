//
//  SettingsViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 7/21/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    _navigationBar.title = @"Settings";
    _navigationBar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Matches" style:UIBarButtonItemStylePlain target:self action:@selector(finishSegue:)];
    
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
    self.ageEnd.delegate = self;
    self.ageBegin.delegate = self;
    self.distanceTextField.delegate = self;
    [self.ageTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.nameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //setup age/datepicker
    self.datePickerView.hidden = YES;
    self.accessoryView.hidden = YES;
    [self.datePickerView setDatePickerMode:UIDatePickerModeDate];
    self.ageTextField.inputView = self.datePickerView;
    self.ageTextField.inputAccessoryView = self.accessoryView;

    //make text view look similar to age/name text fields
    self.bioTextView.delegate = self;
    [self.bioTextView.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.bioTextView.layer setBorderWidth:.5f];
    self.bioTextView.layer.cornerRadius = 5.0f;
    self.bioTextView.clipsToBounds = YES;
    self.bioTextView.text = [defaults valueForKey:@"userBio"];
    self.textViewPlaceholder = @"A short bio...";
    
    //setup color for gender picker
    UIColor * orangeColor = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
    self.genderSegment.tintColor = orangeColor;
    
    //add borders to orientation buttons
    [[self.womenOrButton layer] setBorderWidth:.5f];
    [[self.womenOrButton layer] setBorderColor:[orangeColor CGColor]];
    [[self.womenOrButton layer] setCornerRadius:5.0f];
    [[self.womenOrButton layer] setMasksToBounds:YES];
    [self.womenOrButton setTitleColor:orangeColor forState:UIControlStateNormal];
    
    [[self.menOrButton layer] setBorderWidth:.5f];
    [[self.menOrButton layer] setBorderColor:[orangeColor CGColor]];
    [[self.menOrButton layer] setCornerRadius:5.0f];
    [[self.menOrButton layer] setMasksToBounds:YES];
    [self.menOrButton setTitleColor:orangeColor forState:UIControlStateNormal];

	// Do any additional setup after loading the view.
}

-(BOOL)saveDetails
{
    __block BOOL retVal = NO;
    //call server here to save the person
    return retVal;
}

//this will be the saving of details
-(IBAction)finishSegue:(id)sender
{
    
    //update this to save details
    
    if([self saveDetails]){
        //dismiss view and go to matches view controller
        
        UITableViewController *matchesView = [self.storyboard instantiateViewControllerWithIdentifier:@"Matches"];
        [self.navigationController pushViewController:matchesView animated:YES];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Probs"
                                                        message:@"We had trouble saving your updates :(."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

#pragma mark Text field delegate methods:


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.ageTextField){
        self.accessoryView.hidden = NO;
        self.datePickerView.hidden = NO;
    }
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == self.ageTextField){
        return NO;
    }
    return YES;
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
}

- (IBAction)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:picker.date];
    
    NSString *birthday = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    //save the birthday for later.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:birthday forKey:@"Birthday"];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:picker.date
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.ageTextField.text = [NSString stringWithFormat:@"%d", age];
    
}

- (IBAction)doneEditing:(id)sender {
    [self.ageTextField resignFirstResponder];
}

-(void)textFieldChanged:(UITextField *)textField
{
    if (textField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Field"
                                                        message:@"This field is required!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [textField isFirstResponder];
        
    }

}



#pragma mark Text view delegate methods:

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
    if ([self.ageBegin isFirstResponder] && [touch view] != self.ageTextField) {
        [self.ageBegin resignFirstResponder];
    }
    if ([self.ageEnd isFirstResponder] && [touch view] != self.ageTextField) {
        [self.ageEnd resignFirstResponder];
    }
    if ([self.distanceTextField isFirstResponder] && [touch view] != self.ageTextField) {
        [self.distanceTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
