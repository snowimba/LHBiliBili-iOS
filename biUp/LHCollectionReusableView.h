//
//  LHCollectionReusableView.h
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCollectionReusableView : UICollectionReusableView
+(instancetype)collectionHeadWith;
- (void)getADataWithURL;
- (void)getCellDataWithURL;
@end
