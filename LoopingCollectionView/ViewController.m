//
//  ViewController.m
//  LoopingCollectionView
//
//  Created by Chen Yue on 1/15/17.
//  Copyright © 2017 MtZendo. All rights reserved.
//

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))
#define COLOR(prmRed, prmGreen, prmBlue, prmAlpha) [UIColor colorWithRed:(CGFloat)prmRed/255    \
                                                            green:(CGFloat)prmGreen/255  \
                                                            blue:(CGFloat)prmBlue/255   \
                                                            alpha:prmAlpha]             \

#import "ViewController.h"
#import "CollectionViewCell.h"

static NSString * const _collectionCellIdentifier = @"COLLECTION_CELL";

@interface ViewController () {
    
}
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) IBOutlet UICollectionView *cvTopEvents;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = @[@1, @2, @3];
    
    id firstItem = [self.dataSource firstObject];
    id lastItem = [self.dataSource lastObject];
    NSMutableArray *workingArray = [self.dataSource mutableCopy];
    [workingArray insertObject:lastItem atIndex:0];
    [workingArray addObject:firstItem];
    self.dataSource = workingArray;
    
    
//    [self.cvTopEvents scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
//                             atScrollPosition:UICollectionViewScrollPositionNone
//                                     animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self.cvTopEvents scrollRectToVisible:CGRectMake(self.cvTopEvents.frame.size.width, 0, self.cvTopEvents.frame.size.width, self.cvTopEvents.frame.size.height) animated:NO];
//    });
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // scroll to the 2nd page, which is showing the first item.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        // scroll to the first page, note that this call will trigger scrollViewDidScroll: once and only once
//        //        [self.cvTopEvents scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
//        //                                 atScrollPosition:UICollectionViewScrollPositionLeft
//        //                                         animated:NO];
//        [self.cvTopEvents scrollRectToVisible:CGRectMake(self.cvTopEvents.frame.size.width, 0, self.cvTopEvents.frame.size.width, self.cvTopEvents.frame.size.height) animated:NO];
//        
//        //        [self.cvTopEvents selectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
//        //                                       animated:YES
//        //                                 scrollPosition:UICollectionViewScrollPositionNone];
    });


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_collectionCellIdentifier forIndexPath:indexPath];
//    float r = RAND_FROM_TO(0,255);
//    float g = RAND_FROM_TO(0,255);
//    float b = RAND_FROM_TO(0,255);
//    cell.backgroundColor = COLOR(r, g, b, 1.0f);
    
//    cell.textLabel.text = [NSString stringWithFormat:@"Index = %ld", indexPath.row];
    NSLog(@"indexPath = %@", indexPath.description);
    
    NSInteger index = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", index]];
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;

}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - <UIScrollViewDelegate>
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat lastContentOffsetX = FLT_MIN;
    
    // We can ignore the first time scroll,
    // because it is caused by the call scrollToItemAtIndexPath: in ViewWillAppear
    if (FLT_MIN == lastContentOffsetX) {
        lastContentOffsetX = scrollView.contentOffset.x;
        //            return;
    }
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat offset = pageWidth * (self.dataSource.count - 2);
    
    // the first page(showing the last item) is visible and user's finger is still scrolling to the right
    if (currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX) {
        lastContentOffsetX = currentOffsetX + offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
        //            [self.pcTopEvents setCurrentPage:4];
    }
    // the last page (showing the first item) is visible and the user's finger is still scrolling to the left
    else if (currentOffsetX > offset && lastContentOffsetX < currentOffsetX) {
        lastContentOffsetX = currentOffsetX - offset;
        scrollView.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
        //            [self.pcTopEvents setCurrentPage:0];
    } else {
        lastContentOffsetX = currentOffsetX;
        //            [self.pcTopEvents setCurrentPage:2];
    }
    
}

@end
