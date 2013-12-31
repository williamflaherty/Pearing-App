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
#import "NZImageCache.h"

int s_SelectedCount;

@interface ChooseImagesViewController ()

@end

@implementation ChooseImagesViewController {
    NSMutableArray *_selectedImages;
    id<IImageCache> _imageCache;
    BOOL _isLoadingImages;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSOperationQueue *) operationQueue {
    static NSOperationQueue *queue = nil;
    if (!queue) {
        queue = [NSOperationQueue new];
    }
    return queue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedImages = @[].mutableCopy;
    _imageCache = [NZImageCache instance];
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
    self.instagramPictures = @[].mutableCopy;
    [self loadImages:url];

}

#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.instagramPictures.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Loading" forIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *imageData = [self.instagramPictures objectAtIndex:indexPath.row];
    NSString *thumbnailUrl = imageData[@"images"][@"thumbnail"][@"url"];

    ChooseImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    [cell.instagramPicture setImageUrl:thumbnailUrl cache:_imageCache];
    
    return cell;
}

//trying to get the selected cell stuff to work when you choose photos
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *imageData = self.instagramPictures[indexPath.row];
    
    if (![_selectedImages containsObject:imageData]) {
        [_selectedImages addObject:imageData];
    }
    
    [self updateTitleCount];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *imageData = self.instagramPictures[indexPath.row];
    
    [_selectedImages removeObject:imageData];
    [self updateTitleCount];
}

- (void) updateTitleCount {
    self.title = [NSString stringWithFormat:@"%d of 5", _selectedImages.count];
    
    if (_selectedImages.count == 5){
        self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(Add:)];
    } else {
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
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
        [self loadImages:nextUrl];
    }
}


- (void) loadImages:(NSString *)url {
    if (_isLoadingImages) return;
    
    _isLoadingImages = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[self operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            self.userImages = jsonDict;
            [self.instagramPictures addObjectsFromArray:jsonDict[@"data"]];
            [self.collectionView reloadData];
            _isLoadingImages = NO;
        }];
    }];
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
