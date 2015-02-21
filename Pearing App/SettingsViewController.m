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
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.year = -18;
    NSDate *eighteenYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                            toDate:now
                                                                           options:0];
    self.datePickerView.maximumDate = eighteenYearsAgo;
    dateComponents.year = -80;
    NSDate *eightyYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                          toDate:now
                                                                         options:0];
    self.datePickerView.minimumDate = eightyYearsAgo;
    [self.datePickerView setDatePickerMode:UIDatePickerModeDate];
    self.ageTextField.inputView = self.datePickerView;
    [self.accessoryView removeFromSuperview];
    self.ageTextField.inputAccessoryView = self.accessoryView;

    //make text view look similar to age/name text fields
    self.bioTextView.delegate = self;
    [self.bioTextView.layer setBorderColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.bioTextView.layer setBorderWidth:.5f];
    self.bioTextView.layer.cornerRadius = 5.0f;
    self.bioTextView.clipsToBounds = YES;
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

    //setup picker view for distance
    self.distancePickerView.delegate = self;
    self.distancePickerView.dataSource = self;
    self.distancePickerView.hidden = YES;
    self.distanceTextField.inputView = self.distancePickerView;
    self.distanceTextField.inputAccessoryView = self.accessoryView;
    
    //fill out all of the information
    self.nameTextField.text = [defaults objectForKey:@"handle"];
    self.ageTextField.text = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"age"]];
    self.ageBegin.text = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ageBegin"]];
    self.ageEnd.text =  [NSString stringWithFormat:@"%@" , [defaults objectForKey:@"ageEnd"] ];
    self.genderSegment.selectedSegmentIndex = [[defaults objectForKey:@"gender"] integerValue];
    self.bioTextView.text = [defaults valueForKey:@"userBio"];
    
    if([[defaults objectForKey:@"gender"] integerValue] == 1){
        self.genderSegment.selectedSegmentIndex = 1;
    }
    else{
        self.genderSegment.selectedSegmentIndex = 2;
    }
    
    self.distanceTextField.text = [defaults objectForKey:@"distance"];
    
    switch ([[defaults objectForKey:@"orientation"] integerValue]) {
        case 1:
            self.womenOrButton.backgroundColor = orangeColor;
            [self.womenOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.womenOrButton setSelected:YES];
            break;
        case 2:
            self.menOrButton.backgroundColor = orangeColor;
            [self.menOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.menOrButton setSelected:YES];
            break;
        case 3:
            self.womenOrButton.backgroundColor = orangeColor;
            [self.womenOrButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
            [self.womenOrButton setSelected:YES];
            self.menOrButton.backgroundColor = orangeColor;
            [self.menOrButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
            [self.menOrButton setSelected:YES];
            break;
            
       default:
            break;
    }
    
    /* open the pearing client */
    _pearingClient = [PearingClient instance];

	// Do any additional setup after loading the view.
}

-(BOOL)saveDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block BOOL retVal = NO;
    
    
    //call server here to save the person
    /*[_pearingClient updateUserDefaultsWithHandle:self.nameTextField.text
                                          gender:(int)self.genderSegment.selectedSegmentIndex
                                        birthday:[defaults objectForKey:@"Birthday"] description:self.bioTextView.text ageBegin:self.ageBegin.text ageEnd:self.ageEnd.text orientation:<#(int)#> distance:<#(NSString *)#>]*/
    //YOU NEED TO FIGURE OUT HOW YOU'RE HANDLING THE ORIENTATION SHIT
    //WHERE ARE YOU SAVING THE VALUES? DEFAULTS. THAT'S WHERE.
    //WHEN YOU SEE THIS YOU'RE SAVING THE BUTTON VALUES INTO DEFAULTS
    //IF THEY'RE ACTIVE!
     
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

#pragma mark UIbutton actions

- (IBAction)womenOrButtonPressed:(id)sender{
    if(self.womenOrButton.selected == YES){
        
        self.womenOrButton.backgroundColor = [UIColor whiteColor];
        [self.womenOrButton
         setTitleColor:[UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f]
         forState:UIControlStateNormal];
        [self.womenOrButton setSelected:NO];
    }
    else if(self.womenOrButton.selected == NO){
        self.womenOrButton.backgroundColor = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
        ;
        [self.womenOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.womenOrButton setSelected:YES];
    }
}

- (IBAction)menOrButtonPressed:(id)sender{
    if(self.menOrButton.selected == YES){
        self.menOrButton.backgroundColor = [UIColor whiteColor];
        [self.menOrButton
         setTitleColor:[UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f]
         forState:UIControlStateNormal];
        [self.menOrButton setSelected:NO];
    }
    else if(self.menOrButton.selected == NO){
        self.menOrButton.backgroundColor = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
        ;
        [self.menOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.menOrButton setSelected:YES];
    }
}

#pragma mark Text field delegate methods:

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.ageTextField){
        self.accessoryView.hidden = NO;
        self.datePickerView.hidden = NO;
        [self.datePickerView removeFromSuperview];

    }

    if( textField == self.ageBegin || textField == self.ageEnd){
        [self animateTextField:textField up:YES distance:70];
    }
    
    if(textField == self.distanceTextField){
        [self animateTextField:textField up:YES distance:70];
        self.accessoryView.hidden = NO;
        self.distancePickerView.hidden = NO;
        [self.distancePickerView removeFromSuperview];

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
    
    if( textField == self.ageBegin || textField == self.ageEnd ){
        /* for backspace */
        if([string length]==0){
            return YES;
        }
        
        /*  limit to only numeric characters  */
        if([string intValue]){
            return YES;
        }
    }
    
    if( textField == self.nameTextField){
        return YES;
    }
    
    //need to add a thing for the distance text field here
    return NO;
}
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == self.nameTextField)
    {
        if([textField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hold on!"
                                                            message:@"You need a name!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            textField.text = @"";
            return NO;
        }
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
    
    
    if(textField == self.ageBegin){
        [self animateTextField:textField up:NO distance:70];
        NSInteger age = [textField.text integerValue];
        NSInteger ageEnd = [self.ageEnd.text integerValue];
        
        if( age < 18 ){
           self.ageBegin.text = @"18";
        }
        if( age > 100 ){
            self.ageBegin.text = @"100";
        }
        if( age > ageEnd ){
            self.ageEnd.text = textField.text;
        }
    }
    
    if(textField == self.ageEnd){
       
        [self animateTextField:textField up:NO distance:70];
        NSInteger age = [textField.text integerValue];
        NSInteger ageBegin = [self.ageBegin.text integerValue];
        
        if( age < 18 ){
            self.ageEnd.text = @"18";
        }
        if( age > 100 ){
            self.ageEnd.text = @"100";
        }
        if( age < ageBegin ){
            self.ageBegin.text = textField.text;
        }
    }
    
    if(textField ==self.distanceTextField){
        [self animateTextField:textField up:NO distance:70];
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
    self.ageTextField.text = [NSString stringWithFormat:@"%ld", (long)age];
    
}

- (IBAction)doneEditing:(id)sender {
    
    [self.distanceTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up distance: (const int)movementDistance
{
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration
                     animations:^{
                         
                         self.view.frame = CGRectOffset(self.view.frame, 0, movement);
                     }];
    
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

#pragma mark Picker view delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *rowName = nil;
    switch (row) {
        case 0:
            rowName = @"10";
            break;
        case 1:
            rowName = @"25";
            break;
        case 2:
            rowName = @"50";
            break;
        case 3:
            rowName = @"100";
            break;
        case 4:
            rowName = @"Any";
            break;
            
        default:
            break;
    }
    return rowName;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.distanceTextField.text = [self pickerView:thePickerView titleForRow:row forComponent:component];
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
    if ([self.ageBegin isFirstResponder] && [touch view] != self.ageBegin) {
        [self.ageBegin resignFirstResponder];
    }
    if ([self.ageEnd isFirstResponder] && [touch view] != self.ageEnd) {
        [self.ageEnd resignFirstResponder];
    }
    if ([self.distanceTextField isFirstResponder] && [touch view] != self.distanceTextField) {
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
