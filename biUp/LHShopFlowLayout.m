//
//  LHShopFlowLayout.m
//  12-自习瀑布流UP2.0
//
//  Created by snowimba on 15/11/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHShopFlowLayout.h"

@interface LHShopFlowLayout ()
@property (nonatomic, strong) NSMutableArray* shopAttr;
@property (nonatomic, strong) NSMutableDictionary* shopDictM;

@end
@implementation LHShopFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认列数
        self.colNum = 2;
        // 给一个默认的cell间距及行间距
        self.minimumInteritemSpacing = 15;
        self.minimumLineSpacing = 15;

        // foterView 或headerView的默认尺寸
        self.footerReferenceSize = CGSizeMake(50, 50);
        self.headerReferenceSize = CGSizeMake(50, 50);
        self.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        self.minimumLineSpacing = 15;
        self.minimumInteritemSpacing = 15;
        self.colNum = 2;
        self.footerReferenceSize = CGSizeMake(50, 50);
        self.headerReferenceSize = CGSizeMake(50, 50);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self.shopAttr removeAllObjects];

    for (NSInteger i = 0; i < self.colNum; i++) {
        self.shopDictM[[NSString stringWithFormat:@"%zd", i]] = @(self.sectionInset.top + 592);
    }

    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath* index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:index];
        [self.shopAttr addObject:attr];
    }

    NSIndexPath* headIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes* attrHead = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headIndex];
    attrHead.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, 592);

    [self.shopAttr addObject:attrHead];

    //    NSIndexPath *sectionOneIndex = [NSIndexPath indexPathForItem:1 inSection:0];
    //    UICollectionViewLayoutAttributes *attrSec = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:sectionOneIndex];
    //    attrHead.frame = CGRectMake(0, 194, self.collectionView.bounds.size.width, 40);
    //
    //    [self.shopAttr addObject:attrSec];
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{

    NSString* key = [self colMinNum];

    NSInteger col = [key integerValue];

    CGFloat cellW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.colNum - 1)) / self.colNum;

    CGFloat cellH = [self.delegate shopFlowLayoutWithHight:self layoutWitdh:cellW forIndex:indexPath];

    CGFloat cellX = self.sectionInset.left + (cellW + self.minimumInteritemSpacing) * (col % self.colNum);

    CGFloat cellY = [self.shopDictM[key] floatValue];

    self.shopDictM[key] = @(self.minimumLineSpacing + cellY + cellH);

    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attr.frame = CGRectMake(cellX, cellY, cellW, cellH);

    return attr;
}

- (NSString*)colMinNum
{

    __block NSString* min = @"0";

    [self.shopDictM enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        if ([self.shopDictM[min] floatValue] > [obj floatValue]) {
            min = key;
        }
    }];

    return min;
}

- (NSString*)colMaxNum
{

    __block NSString* max = @"0";

    [self.shopDictM enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        if ([self.shopDictM[max] floatValue] < [obj floatValue]) {
            max = key;
        }
    }];

    return max;
}

- (NSArray<UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{

    return self.shopAttr;
}

- (CGSize)collectionViewContentSize
{

    return CGSizeMake(0, [self.shopDictM[[self colMaxNum]] floatValue]+120);
}

#pragma mark - 懒加载

- (NSMutableArray*)shopAttr
{

    if (_shopAttr == nil) {

        _shopAttr = [NSMutableArray array];
    }

    return _shopAttr;
}

- (NSMutableDictionary*)shopDictM
{

    if (_shopDictM == nil) {

        _shopDictM = [NSMutableDictionary dictionaryWithCapacity:_colNum];
    }

    return _shopDictM;
}

@end
