//
//  ChooseImagesViewController.m
//  Pearing App
//
//  Created by Dwayne Flaherty on 12/23/13.
//  Copyright (c) 2013 Pearing. All rights reserved.
//

#import "ChooseImagesViewController.h"
#import "ChooseImagesCell.h"
#import "ImageCache.h"

int s_SelectedCount;

@interface ChooseImagesViewController ()

@end

@implementation ChooseImagesViewController

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
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.selectedPictures = [[NSMutableArray alloc] init];
    //show the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //don't hide the view behind the bar because it's translucent
    self.navigationController.navigationBar.translucent = NO;
    //set the navigation bar color
    UIColor * color = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = color;
    //hide the back button
   // self.navBar.hidesBackButton = YES;
    self.navigationItem.hidesBackButton = YES;
    //initialize the title
    s_SelectedCount = 0;
    NSString *title = [NSString stringWithFormat:@"%d of 5", s_SelectedCount];
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = title;
    
    //get pictures from instagram
    NSString *url = [NSString stringWithFormat:@"%@%@/media/recent?access_token=%@", APIURl, [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID], [[NSUserDefaults standardUserDefaults] valueForKey:ACCESS_TOKEN]];
    self.userImages = [self getUserMedia:url];
    self.instagramPictures = [[self.userImages objectForKey:@"data"] mutableCopy];

}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.instagramPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    if (cell == nil) {

    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    NSDictionary *data = [self.instagramPictures objectAtIndex:indexPath.row];
    NSDictionary *images = [data objectForKey:@"images"];
    NSDictionary *thumbnail = [images objectForKey:@"thumbnail"];
    NSString *strPicUrl = [thumbnail objectForKey:@"url"];
    
    
    if([[ImageCache sharedImageCache] DoesExist:strPicUrl] == YES)
    {
        cell.instagramPicture.image = [[ImageCache sharedImageCache] GetImage:strPicUrl];
    }
    else
    {
        NSURL *picUrl = [NSURL URLWithString:strPicUrl];
        NSURLRequest *reqObj = [NSURLRequest requestWithURL:picUrl];
        //create operation queue to handle an async request so we don't block the main thread
        //while loading the image
        [NSURLConnection sendAsynchronousRequest:reqObj queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                 UIImage *pp = [UIImage imageWithData:[NSData dataWithContentsOfURL: picUrl]];
                 cell.instagramPicture.image = pp;
                 [[ImageCache sharedImageCache] AddImage:strPicUrl:pp];

             }
             else if (error != nil) NSLog(@"Error: %@", error); //should probably actually handle this
         }];
        
    }
    
    if ([self isSelected:cell.instagramPicture.image])
    {
        //[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.selected = YES;
    } else
    {
        //[collectionView deselectItemAtIndexPath:indexPath animated:YES];
        cell.selected = NO;
    }
    
    //if the cell is selected mark it as so.
    //for ( self.selectedPictures )
    //NSLog(@"cell.isSelected: %d", cell.isSelected );
    NSLog(@"cell:%@ indexpath:%@\n\n", cell, indexPath);
    return cell;
    
}

//trying to get the selected cell stuff to work when you choose photos
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseImagesCell *cell = (ChooseImagesCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if( cell.isSelected == YES && s_SelectedCount < 5 && ![self isSelected:cell.instagramPicture.image] )
    {
        s_SelectedCount++;
        UIImageView *screenImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 106, 106)];
        screenImage.image = [UIImage imageNamed:@"screen.png"];
        [cell.instagramPicture addSubview:screenImage];
        [self.selectedPictures addObject:cell.instagramPicture.image];
        //[collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        NSString *title = [NSString stringWithFormat:@"%d of 5", s_SelectedCount];
        self.title = title;
        NSLog(@"Index Path when Selected: %@", indexPath);
        //don't forget to increment/decrement the selected photos number and if 5 are selected pop up a next button.
        //maybe the next button should pop up after 1?

    }
    if( s_SelectedCount == 5 ){
        // self.navBar.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
        self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(Add:)];
        
    }

}

-(void)collectionView:(UICollectionView*)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseImagesCell *cell = (ChooseImagesCell*)[collectionView cellForItemAtIndexPath:indexPath];

    if( cell.isSelected == NO && s_SelectedCount > 0 && s_SelectedCount <= 5 && [self isSelected:cell.instagramPicture.image] )
    {
        for(UIView *subview in [cell.instagramPicture subviews]) {
            [subview removeFromSuperview];
        }
        s_SelectedCount--;
        [self.selectedPictures removeObject:cell.instagramPicture.image];
        NSString *title = [NSString stringWithFormat:@"%d of 5", s_SelectedCount];
        self.title = title;
        if(s_SelectedCount < 5){
            //self.navBar.rightBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            
        }
    }
    else if ( cell.isSelected == YES )
    {
        NSLog(@"Something's weird");
    }
    
}

-(BOOL)isSelected:(UIImage *)image
{
    for ( UIImage *iterImage in self.selectedPictures )
    {
        if([iterImage isEqual:image]) return YES;
    }
    
    return NO;
    
}

-(IBAction)Add:(id)sender
{
    UIViewController *setupProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"SetupProfile"];
    [self.navigationController pushViewController:setupProfile animated:YES];
}

//Should probably add some error checking to this method
-(NSMutableDictionary *)getUserMedia:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSMutableDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dictResponse;
    
}

-(void)updateImagesDataSource
{
    NSString *nextUrl = [[self.userImages objectForKey:@"pagination"] objectForKey:@"next_url"];
    if (nextUrl)
    {
        self.userImages = [[self getUserMedia:nextUrl] mutableCopy];
        NSMutableArray *newImages = [self.userImages objectForKey:@"data"];
        [self.instagramPictures addObjectsFromArray:newImages];
        [self.collectionView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (CGRectIntersectsRect(scrollView.bounds, CGRectMake(0, self.collectionView.contentSize.height, CGRectGetWidth(self.view.frame), 40)) && self.collectionView.contentSize.height > 0)
    {
        [self updateImagesDataSource];
    }
}

//this overrides the set title method called when you set self.title
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont systemFontOfSize:20.0];
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        //wtf why??
        self.navigationController.navigationBar.topItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
