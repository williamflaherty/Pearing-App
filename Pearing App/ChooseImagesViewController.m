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
#import "PearingAuth.h"
#import "PEContainer.h"

int s_SelectedCount;

@interface ChooseImagesViewController ()

@end

@implementation ChooseImagesViewController {
    NSMutableArray *_selectedImages;
    id<IImageCache> _imageCache;
    NSString *_nextImagesPageToken;
    BOOL _isLoadingImages;
    PEInstagramService *_instagramService;
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
    
    _instagramService = [PEContainer instagramService];
    
    _selectedImages = @[].mutableCopy;
    _imageCache = [NZImageCache instance];
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    //show the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //don't hide the view behind the bar because it's translucent
    self.navigationController.navigationBar.translucent = NO;
    //set the navigation bar colors
    //UIColor * color = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f]; //too harsh?
    //UIColor * color = [UIColor colorWithRed:237/255.0f green:132/255.0f blue:92/255.0f alpha:1.0f]; //too subdued?
    UIColor * color = [UIColor colorWithRed:239/255.0f green:121/255.0f blue:103/255.0f alpha:1.0f]; //too flat?
    
    self.navigationController.navigationBar.barTintColor = color;
    /*if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"testy.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }*/
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0f green:125/255.0f blue:51/255.0f alpha:1.0f];
    //eventually gonna replace done with a custom "next" button 
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //hide the back button
    self.navigationItem.hidesBackButton = YES;
    //initialize the title
    s_SelectedCount = 0;
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;


    self.instagramPictures = @[].mutableCopy;
    [self loadImages:nil];
    [self updateTitleCount];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
    if (_selectedImages.count >= 5) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        return;
    }
    
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
    self.title = [NSString stringWithFormat:@"%lu of 5", (unsigned long)_selectedImages.count];
    
    if (_selectedImages.count == 5 && self.navigationController.navigationBar.topItem.rightBarButtonItem == nil) {
        //self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(Add:)];
        self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Add:)];
    } else {
        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SetupProfileViewController *setup = (SetupProfileViewController *)segue.destinationViewController;
    setup.selectedPictures = [_selectedImages mutableCopy];
    
}
-(IBAction)Add:(id)sender
{
    [self performSegueWithIdentifier:@"SetupProfile" sender:nil];

}

-(void)updateImagesDataSource
{
    if (_nextImagesPageToken)
    {
        [self loadImages:_nextImagesPageToken];
    }
}


- (void) loadImages:(NSString *)url {
    if (_isLoadingImages) return;
    _isLoadingImages = YES;
    
    [_instagramService loadRecentImages:url completion:^(NSArray *imageURLs, NSString *nextPageToken, NSError *error)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            // TODO: handle error
            if (!error) {
                _nextImagesPageToken = nextPageToken;
                [self.instagramPictures addObjectsFromArray:imageURLs];
                [self.collectionView reloadData];
            }
            
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
