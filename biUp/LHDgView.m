//
//  LHDgView.m
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCollectionReusableView.h"
#import "LHDgView.h"
#import "LHShop.h"
#import "LHShopCell.h"
#import "LHShopFlowLayout.h"
#import "UIImageView+WebCache.h"

#import "AFNetworking.h"
//#import "UIKit+AFNetworking.h"
#import "YiRefreshHeader.h"

@interface LHDgView () <UICollectionViewDelegate, UICollectionViewDataSource, LHShopFlowLayoutDelegate>
{

    YiRefreshHeader *refreshHeader;

}

@property (weak, nonatomic) LHShopFlowLayout* flowLayoutC;
@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic,weak) LHCollectionReusableView *headerView;
//@property (nonatomic, strong) NSArray* arrM;
@end
@implementation LHDgView

- (void)reload:(__unused id)sender
{
    //    self.navigationItem.rightBarButtonItem.enabled = NO;

    //    [self.collectionView.refreshControl setRefreshingWithStateOfTask:task];
    
//    NSURL *URL = [NSURL URLWithString:@"http://app.bilibili.com/bangumi/timeline_v2"];
    
    //    http://www.bilibili.com/api_proxy?app=bangumi&indexType=0&action=site_season_index&pagesize=100&page=1&
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://app.bilibili.com/bangumi/timeline_v2" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray *postsFromResponse = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"list"]];
        
        
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        
        for (NSInteger i = 0; i < postsFromResponse.count ; i++) {
            NSDictionary *dict = postsFromResponse[i];
            LHShop *post = [LHShop shopWithDict:dict];
            [mutablePosts addObject:post];
        }
        
        self.arrDict = mutablePosts;
        
        [self.collectionView reloadData];
        
        [refreshHeader endRefreshing];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        //            NSLog(@"%@",responseObject);
//        
////        NSDictionary *dictO = [responseObject valueForKey:@"result"];
//        
//        NSArray *postsFromResponse = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"list"]];
//        
//        
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        
//        for (NSInteger i = 0; i < postsFromResponse.count ; i++) {
//            NSDictionary *dict = postsFromResponse[i];
//            LHShop *post = [LHShop shopWithDict:dict];
//            [mutablePosts addObject:post];
//        }
//        
//        self.arrDict = mutablePosts;
//        
//         [self.collectionView reloadData];
//        
//        [refreshHeader endRefreshing];
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        
//    }];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        LHShopFlowLayout* flowLayout = [[LHShopFlowLayout alloc] init];

        self.flowLayoutC = flowLayout;

        UICollectionView* collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];

        self.collectionView = collection;

        UINib* cellN = [UINib nibWithNibName:@"LHShopCell" bundle:nil];

        [self.collectionView registerNib:cellN forCellWithReuseIdentifier:@"dgcell"];

        //        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"dgcell"];

        // Do any additional setup after loading the view.
        UINib* head = [UINib nibWithNibName:@"LHCollectionReusableView" bundle:nil];

        [self.collectionView registerNib:head forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"jufanhead"];

        self.flowLayoutC.colNum = 2;
        
//        self.flowLayoutC.estimatedItemSize = CGSizeMake(100, 100);

        //        self.flowLayoutC.estimatedItemSize = CGSizeMake(200, 250);

        self.flowLayoutC.delegate = self;

        //                flowLayout.footerReferenceSize = CGSizeMake(frame.size.width, 120);

        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

        //        self.collectionView
        //                collection.bounces = NO;

        
        __weak typeof (self)weakSelf = self;
        // YiRefreshHeader  头部刷新按钮的使用
        refreshHeader=[[YiRefreshHeader alloc] init];
        refreshHeader.scrollView=self.collectionView;
        [refreshHeader header];
//        typeof(refreshHeader) __weak weakRefreshHeader = refreshHeader;
        refreshHeader.beginRefreshingBlock=^(){
            // 后台执行：
            [weakSelf.headerView getCellDataWithURL];
            [weakSelf.headerView getADataWithURL];
            [weakSelf reload:nil];
           
        };
        
        // 是否在进入该界面的时候就开始进入刷新状态
        [refreshHeader beginRefreshing];
        
        //                NSLog(@"%@----",self.arrDict);
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    LHShopCell *cell = (LHShopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSpController" object:cell.shop];
    
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)shopFlowLayoutWithHight:(LHShopFlowLayout*)flowLayout layoutWitdh:(CGFloat)cellW forIndex:(NSIndexPath*)indexP
{
    LHShop* shop = self.arrDict[indexP.item];

//    return shop.height / shop.width * cellW + 21;
    
    
    return cellW * 1.5 + [shop.title boundingRectWithSize:CGSizeMake(cellW-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0] } context:nil].size.height;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    LHCollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"jufanhead" forIndexPath:indexPath];

    self.headerView = header;
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView.contentOffset.y >= 0) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTopBar" object:@(scrollView.contentOffset.y)];
    }
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
//{
//    //#warning Incomplete implementation, return the number of sections
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    //#warning Incomplete implementation, return the number of items
    return self.arrDict.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    LHShopCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dgcell" forIndexPath:indexPath];
    // Configure the cell
    //    NSLog(@"%@---", self.arrDict);

    cell.backgroundColor = [UIColor whiteColor];

    cell.shop = self.arrDict[indexPath.item];

    return cell;
}

@end
