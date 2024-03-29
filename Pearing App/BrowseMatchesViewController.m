//
//  BrowseMatchesViewController.m
//  Pearing App
//
//  Created by Nathan Ziebart on 1/19/14.
//  Copyright (c) 2014 Pearing. All rights reserved.
//

#import "BrowseMatchesViewController.h"
#import "BrowseMatchesCell.h"
#import "FullSizeImageViewController.h"
#import "PEContainer.h"

@interface BrowseMatchesViewController () <UIAlertViewDelegate, BrowseMatchesCellDelegate>

@end

@implementation BrowseMatchesViewController {
    NSArray *_matches;
}

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
    _navigationBar.title = @"Pearing";
    //set the navigation bar colors
    //UIColor * color = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f]; //too harsh?
    //UIColor * color = [UIColor colorWithRed:237/255.0f green:132/255.0f blue:92/255.0f alpha:1.0f]; //too subdued?
    UIColor * color = [UIColor colorWithRed:239/255.0f green:121/255.0f blue:103/255.0f alpha:1.0f]; //too flat?

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = color;
    //eventually replace with custom images
    
    UIImage *barButtonImage = [UIImage imageNamed:@"settings-button.png"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:barButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *chatListButton = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStylePlain target:self action:@selector(chatButtonPressed:)];
    self.navigationItem.rightBarButtonItem = chatListButton;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    

    
	[self loadMatches];
}

- (void) loadMatches {
    if (!_pearingClient) _pearingClient = [PEContainer APIClient];
    
    [_pearingClient getMatchesWithCompletion:^(NSArray *matches, NSString *error) {
        if (error) {
            [self showAlertWithTitle:@"Error" message:error];
        } else {
            _matches = matches;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction) backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chatButtonPressed:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"]
                                         animated:YES];
}

-(IBAction)onChatButtonTap:(id)sender{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"]
                                         animated:NO];
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"] animated:YES];
}

# pragma mark - tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrowseMatchesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Match"];
    
    cell.match = _matches[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1.0f];;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.chatAndChallengeButton addTarget:self action:@selector(onChatButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _matches.count;
}

# pragma mark - BrowseMatchesCellDelegate

- (void)cell:(id)cell didSelectImage:(PEImage *)image {
    [self performSegueWithIdentifier:@"Image" sender:image];
}

- (void)cellDidToggleFavorite:(id)cell {
    
}

- (void)cellDidReqestChatAndChallenge:(id)cell {
    
}


- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Image"]) {
        PEImage *image = (PEImage *)sender;
        FullSizeImageViewController *imageVC = (FullSizeImageViewController *)segue.destinationViewController;
        imageVC.imageURL = image.fullSizeURL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
