//
//  LHSaCollectionViewCell.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSaCollectionViewCell.h"
#import "LHSaModel.h"
@interface LHSaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation LHSaCollectionViewCell

- (void)setSaCellM:(LHSaModel *)saCellM{

    _saCellM = saCellM;
    
    self.icon.image = [UIImage imageNamed:saCellM.icon];
    
    self.name.text = saCellM.name;
    
    

}
@end
