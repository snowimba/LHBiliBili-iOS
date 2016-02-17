//
//  LHAtView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHAtView.h"
#import "LHAtViewCell.h"
#import "LHAtHeaderView.h"
@interface LHAtView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionViewAt;

@end
@implementation LHAtView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bgi = [[UIImageView alloc] init];
        
        bgi.image = [UIImage imageNamed:@"login_forbidden"];
        
        bgi.frame = CGRectMake(0, 0, frame.size.width, frame.size.height-120);
        
        [self addSubview:bgi];
//        self.layer.contents = (__bridge id)[UIImage imageNamed:@"login_forbidden"].CGImage;
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        
        
        flowLayout.itemSize = CGSizeMake(frame.size.width-40, 140);
        
        flowLayout.minimumLineSpacing = 20;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
        flowLayout.headerReferenceSize = CGSizeMake(frame.size.width, 348);
        
//        flowLayout.footerReferenceSize = CGSizeMake(frame.size.width, 120);
        
        self.collectionViewAt = collectionView;
        
//        [self addSubview:collectionView];
        
        collectionView.delegate = self;
        
        collectionView.dataSource = self;
        
        collectionView.backgroundColor = [UIColor clearColor];
        
        UINib *ni = [UINib nibWithNibName:@"LHAtViewCell" bundle:nil];
        
        [collectionView registerNib:ni forCellWithReuseIdentifier:@"atcell"];
        
        UINib *nihead = [UINib nibWithNibName:@"LHAtHeaderView" bundle:nil];
        
        [collectionView registerNib:nihead forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"athead"];
        
//        [collectionView registerClass:[UICollectionElementKindSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"deadd"];
        
    }
    return self;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    LHAtHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"athead" forIndexPath:indexPath];
    
//    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headd" forIndexPath:indexPath];
    
    
    
//    header.layer.contents = (__bridge id)[UIImage imageNamed:@"login_forbidden"].CGImage;
    
//    header.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_forbidden"]];
    
    return header;

}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LHAtViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"atcell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(float)arc4random_uniform(256)/255.0 green:(float)arc4random_uniform(256)/255.0 blue:(float)arc4random_uniform(256)/255.0 alpha:1];
    
    return cell;
    

}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    if (scrollView.contentOffset.y>=0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTopBar" object:@(scrollView.contentOffset.y)];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
