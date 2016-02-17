//
//  LHSaControllerView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSaControllerView.h"
#import "LHSaModel.h"
#import "LHSaCollectionViewCell.h"
@interface LHSaControllerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionViewSa;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSArray *arrDict;

@end
@implementation LHSaControllerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScreen *scr = [UIScreen mainScreen];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout = flowLayout;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 0, 40);
        
        CGFloat margin = (scr.bounds.size.width - 82*3-30*2)*0.5;
        
        flowLayout.minimumInteritemSpacing = margin;
        
        flowLayout.minimumLineSpacing = margin;
        
        flowLayout.itemSize = CGSizeMake(62, 70);
        
        self.collectionViewSa = collectionView;
        
        [self addSubview:collectionView];
        
        self.collectionViewSa.delegate = self;
        
        self.collectionViewSa.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:@"LHSaCollectionViewCell" bundle:nil];
        
        [self.collectionViewSa registerNib:nib forCellWithReuseIdentifier:@"sacell"];
        
        self.collectionViewSa.backgroundColor = [UIColor clearColor];
    }
    return self;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of items
    return self.arrDict.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LHSaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sacell" forIndexPath:indexPath];
    // Configure the cell
    
    LHSaModel *cellM = self.arrDict[indexPath.item];
    
    cell.saCellM = cellM;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSArray *)arrDict{
    
    if (_arrDict==nil) {
        NSArray *arrD = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"SaCell.plist" ofType:nil]];
        NSMutableArray *arrM =[NSMutableArray arrayWithCapacity:arrD.count];
        for (NSDictionary *dict in arrD) {
            [arrM addObject:[LHSaModel saCellWithDict:dict]];
        }
        _arrDict = arrM;
        
    }
    return _arrDict;
}

@end
