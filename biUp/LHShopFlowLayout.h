//
//  LHShopFlowLayout.h
//  12-自习瀑布流UP2.0
//
//  Created by snowimba on 15/11/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHShopFlowLayout;
@protocol LHShopFlowLayoutDelegate <NSObject>
@optional
- (CGFloat)shopFlowLayoutWithHight:(LHShopFlowLayout *)flowLayout layoutWitdh:(CGFloat)cellW forIndex:(NSIndexPath *)indexP;

@end
@interface LHShopFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<LHShopFlowLayoutDelegate> delegate;
@property (nonatomic,assign) NSInteger colNum;
@end
