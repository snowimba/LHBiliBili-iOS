//
//  LHShopCell.m
//  12-自习瀑布流UP2.0
//
//  Created by snowimba on 15/11/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHShopCell.h"
#import "LHShop.h"
#import "UIImageView+WebCache.h"

@interface LHShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;



@end
@implementation LHShopCell




-(void)setShop:(LHShop *)shop{

    _shop = shop;
    
//    self.iconView.image = [UIImage imageNamed:shop.icon];
//    self.priceView.text = shop.price;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:shop.cover]];
    self.nameView.text = shop.title;
    
    
}

//+ (instancetype)viewWithNib{
//    
//    return [[[NSBundle mainBundle] loadNibNamed:@"LHShopCell" owner:nil options:nil]lastObject];
//    
//}

@end
