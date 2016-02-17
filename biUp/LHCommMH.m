//
//  LHCommMH.m
//  biUp
//
//  Created by snowimba on 15/12/22.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCommM.h"
#import "LHCommMH.h"
@implementation LHCommMH

- (void)setCellM:(LHCommM*)cellM
{

    _cellM = cellM;

    if (cellM.reply.count) {

        CGFloat height = 0;

        for (NSDictionary* dict in cellM.reply) {

            NSString* str = [NSString stringWithFormat:@"%@: %@", [dict valueForKey:@"nick"], [dict valueForKey:@"msg"]];

            CGFloat cellHS = MAX(56, [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16 - 56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 20.5 + 8);
            height += cellHS;
        }

        self.cellH = 16 + height + [cellM.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 48 + 8 + 8;
    }
    else {

        self.cellH = [cellM.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 48 + 8 + 8;
    }
}

@end
