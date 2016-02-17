//
//  LHSlideView.m
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSlideView.h"
#import "LHHistoryController.h"
#import "LHDownLoadController.h"
#define kSCR [UIScreen mainScreen]
@interface LHSlideView () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView* slideGerView;
@property (weak, nonatomic) IBOutlet UITableView* setTbaleView;
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic, strong) UITableViewCell* last_cell;

@end
@implementation LHSlideView

- (UITableViewCell*)last_cell
{

    if (!_last_cell) {
        _last_cell = [self.setTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return _last_cell;
}

- (NSArray*)arrDict
{

    if (_arrDict == nil) {
        _arrDict = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Setting.plist" ofType:nil]];
    }
    return _arrDict;
}

+ (instancetype)slideViewWith
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHSlideView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{

    UIView* compl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCR.bounds.size.width * 2, kSCR.bounds.size.height)];

    self.shadeView = compl;

    compl.backgroundColor = [UIColor blackColor];

    self.shadeView.alpha = 0.0;

    [self addSubview:compl];

    [self sendSubviewToBack:compl];
    //    [self bringSubviewToFront:self.slideGerView];

    self.slideGerView.backgroundColor = [UIColor clearColor];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];

    
    UIPanGestureRecognizer* pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];

    [self.slideGerView addGestureRecognizer:pan];

    UITapGestureRecognizer* tapTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disSlideBtn)];

    [compl addGestureRecognizer:tapTag];

    [compl addGestureRecognizer:pan1];

    //    --------------------

    self.setTbaleView.delegate = self;
    self.setTbaleView.dataSource = self;
    self.setTbaleView.rowHeight = 54;
    self.setTbaleView.bounces = NO;
    self.setTbaleView.sectionHeaderHeight = 2;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell.textLabel.text isEqualToString:self.last_cell.textLabel.text]) {

         cell.textLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:89 / 255.0 blue:163 / 255.0 alpha:1];
        [self disSlideBtn];
        
    }
    else {

        cell.textLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:89 / 255.0 blue:163 / 255.0 alpha:1];

        if ([cell.textLabel.text isEqualToString:@"    首页"]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"popMain" object:self];

            self.last_cell = cell;
            [self disSlideBtn];
        }
        if ([cell.textLabel.text isEqualToString:@"    我的收藏"]) {
            if (![self.last_cell.textLabel.text isEqualToString:@"    我的收藏"]) {
                self.last_cell.selected = NO;
                
            }
            LHHistoryController* vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CollectionView"];

            vcC.type = @"coll";
            //            [nvc pushViewController:vcC animated:NO];

            if(![self.last_cell.textLabel.text isEqualToString:@"    首页"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"popMain" object:self];
            }
            
            if (self.pushBlock) {
                self.pushBlock(vcC);
            }

            self.last_cell.textLabel.textColor = [UIColor blackColor];
            
            self.last_cell = cell;
            
            [self disSlideBtn];
        }
        
        if ([cell.textLabel.text isEqualToString:@"    历史记录"]) {
            LHHistoryController* vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CollectionView"];
            
            if (![self.last_cell.textLabel.text isEqualToString:@"    历史记录"]) {
                self.last_cell.selected = NO;
                
            }
            vcC.type = @"his";
            
            if(![self.last_cell.textLabel.text isEqualToString:@"    首页"]){
            
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"popMain" object:self];
            }
            
            if (self.pushBlock) {
                self.pushBlock(vcC);
            }
            
            self.last_cell.textLabel.textColor = [UIColor blackColor];
            
            self.last_cell = cell;
            
            [self disSlideBtn];
        }
        if ([cell.textLabel.text isEqualToString:@"    离线管理"]) {
            LHDownLoadController* vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownLoad"];
            
            if(![self.last_cell.textLabel.text isEqualToString:@"    首页"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"popMain" object:self];
            }
            
            if (self.pushBlock) {
                self.pushBlock(vcC);
            }
            
            self.last_cell.textLabel.textColor = [UIColor blackColor];
            
            
            cell.textLabel.textColor = [UIColor blackColor];
            cell.selected = NO;
            self.last_cell = [self.setTbaleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.last_cell.selected = YES;
            self.last_cell.textLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:89 / 255.0 blue:163 / 255.0 alpha:1];
            
            [self disSlideBtn];
        }
        
        
        
        [self disSlideBtn];
    }
}

- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.textLabel.textColor = [UIColor blackColor];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{

    return @" ";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return self.arrDict.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.arrDict[section] valueForKey:@"item"] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* ID = @"set_cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    cell.imageView.image = [UIImage imageNamed:[[self.arrDict[indexPath.section] valueForKey:@"item"][indexPath.row] valueForKey:@"icon"]];

    cell.imageView.alpha = 0.6;

    cell.textLabel.text = [NSString stringWithFormat:@"    %@", [[self.arrDict[indexPath.section] valueForKey:@"item"][indexPath.row] valueForKey:@"title"]];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];

    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row==0&&indexPath.section==0) {
        cell.textLabel.textColor = [UIColor colorWithRed:244 / 255.0 green:89 / 255.0 blue:163 / 255.0 alpha:1];
    }

    return cell;
}

- (void)panGes:(UIPanGestureRecognizer*)recognizer
{

    CGPoint trans = [recognizer translationInView:recognizer.view];

    CGFloat changeX = self.transform.tx + trans.x;

    //            NSLog(@"%f",changeX);

    if (changeX >= 0 && changeX <= (kSCR.bounds.size.width) - 9) {

        self.transform = CGAffineTransformTranslate(self.transform, trans.x, 0);

        //        self.slideBtn.alpha = changeX*0.001*0.5;
        self.shadeView.alpha = changeX * 0.0015;
    }
    

    if (recognizer.state == UIGestureRecognizerStateEnded && self.transform.tx < (kSCR.bounds.size.width) * 0.5 + 100) {
        [self disSlideBtn];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded && self.transform.tx >= (kSCR.bounds.size.width) * 0.5 + 100) {
        if (self.showSlide) {
            self.showSlide();
        }
    }

    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)panGesture:(UIPanGestureRecognizer*)recognizer
{
    CGPoint trans = [recognizer translationInView:recognizer.view];

    CGFloat changeX = self.transform.tx + trans.x;

    //    NSLog(@"%f",changeX);

    if (changeX >= 0 && changeX <= (kSCR.bounds.size.width)) {

        self.transform = CGAffineTransformTranslate(self.transform, trans.x, 0);

        //        self.slideBtn.alpha = changeX*0.001*0.5;
        self.shadeView.alpha = changeX * 0.0015;
    }

    if (recognizer.state == UIGestureRecognizerStateEnded && self.transform.tx < (kSCR.bounds.size.width) * 0.5) {
        [self disSlideBtn];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded && self.transform.tx >= (kSCR.bounds.size.width) * 0.5) {
        if (self.showSlide) {
            self.showSlide();
        }
    }

    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)disSlideBtn
{

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.shadeView.alpha = 0.0;
                         self.transform = CGAffineTransformMakeTranslation(0, 0);

                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
