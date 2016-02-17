//
//  LHHistoryController.m
//  biUp
//
//  Created by snowimba on 16/1/3.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import "LHCellController.h"
#import "LHDescModel.h"
#import "LHHistoryController.h"
#import "LHTableCellM.h"
#import "UIImageView+WebCache.h"
#define PATH_CELL [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"collection_cell.data"]

#define PATH_HIS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"his_cell.data"]
@interface LHHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* arrDict;
@property (nonatomic, strong) NSMutableArray* arrDictSp;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel* titelLbl;

@end

@implementation LHHistoryController

- (NSMutableArray*)arrDict
{

    if (!_arrDict) {

        if ([self.type isEqualToString:@"coll"]) {

            if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_CELL]) {
                NSMutableDictionary* dictM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_CELL];
                NSMutableArray* arrM = [NSMutableArray array];
                [dictM enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {

                    [arrM addObject:obj];

                }];
                
                [arrM sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                    return [[obj2 collTime] compare:[obj1 collTime]];
                }];
                
                _arrDict = arrM;
            }
            else {

                _arrDict = [NSMutableArray array];
            }
        }
        else if ([self.type isEqualToString:@"his"]) {

            if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS]) {
                NSMutableDictionary* dictM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS];
                NSMutableArray* arrM = [NSMutableArray array];
                [dictM enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {

                    [arrM addObject:obj];

                }];

                [arrM sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                    return [[obj2 hisTime] compare:[obj1 hisTime]];
                }];

                _arrDict = arrM;
            }
            else {

                _arrDict = [NSMutableArray array];
            }
        }
    }

    return _arrDict;
}

- (IBAction)slideBtn:(UIButton*)sender
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSlideView" object:self userInfo:nil];
}
- (IBAction)clearBtn:(UIButton*)sender
{
    if ([self.type isEqualToString:@"coll"]) {
        if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_CELL]) {

            NSFileManager* fm = [NSFileManager defaultManager];

            [fm removeItemAtPath:PATH_CELL error:nil];

            [self.arrDict removeAllObjects];

            [self.tableView reloadData];
        }
    }
    else if ([self.type isEqualToString:@"his"]) {

        if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS]) {

            NSFileManager* fm = [NSFileManager defaultManager];

            [fm removeItemAtPath:PATH_HIS error:nil];

            [self.arrDict removeAllObjects];

            [self.tableView reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self.type isEqualToString:@"coll"]) {
        self.titelLbl.text = @"我的收藏";
    }
    else if ([self.type isEqualToString:@"his"]) {
        self.titelLbl.text = @"历史记录";
    }
    self.tableView.rowHeight = 80;

    self.tableView.separatorStyle = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootVC) name:@"popMain" object:nil];
    self.count = 0;
}

- (void)popToRootVC
{

    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)dealloc
{

    //    NSLog(@"hisdealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrDict.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    LHTableCellM* cell = [LHTableCellM cellWithTableV:tableView];

    cell.backgroundColor = [UIColor clearColor];

    cell.cellM = self.arrDict[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    LHCellController* cellController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nextView"];

    cellController.cellM = self.arrDict[indexPath.row];
    self.count = 1;
    [self.navigationController pushViewController:cellController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];

    if (self.count == 1) {
        self.arrDict = nil;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
