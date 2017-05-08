//
//  ViewController.m
//  LxNav
//
//  Created by 刘武文 on 2017/4/24.
//  Copyright © 2017年 刘武文. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MJRefresh.h"
#define tableViewHeadHight 200
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIScrollView *scrView;
@property (nonatomic,strong) UIView *tableHeadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;//设置不给系统自动调解
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.edgesForExtendedLayout=UIRectEdgeTop; //设置延伸到导航条下
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self initScr];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(endRefreshMethod) withObject:nil afterDelay:3.0f];
    }];
    [self.tableView sendSubviewToBack:self.tableHeadView]; //这句话必须要 不然你看不到菊花  这是把层次结构至上

}

- (void) endRefreshMethod{
    [self.tableView.mj_header endRefreshing];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}


- (void) initScr{
    NSArray *arr = @[@"A",@"B"];
    for (int i=0; i<arr.count; i++) {
        UIImageView *imgV = [self createHeadView:arr[i] x:i*SCREEN_WIDTH];
        [self.scrView addSubview:imgV];
    }
    self.scrView.contentSize = CGSizeMake(SCREEN_WIDTH*arr.count, 0);
    self.scrView.pagingEnabled = YES;
    [self.tableHeadView addSubview:self.scrView];
    self.tableView.tableHeaderView = self.tableHeadView;
}

- (UIScrollView *)scrView{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    }
    return _scrView;
}

#pragma mark -创建头部视图
- (UIImageView *) createHeadView:(NSString *) imgName x:(float) x{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, 200)];
    //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:imgName];
    return imageView;
}

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeadHight)];
    }
    return _tableHeadView;
}

#pragma mark - 头部黏性图片重要方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect = self.tableHeadView.frame;
        rect.origin.y = offset.y;
        rect.size.height = tableViewHeadHight - offset.y;
        self.scrView.frame = rect;
        self.tableHeadView.clipsToBounds=NO;
    }else{
        self.scrView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tableViewHeadHight);
        
    }
    
    UIColor * color = UIColorFromRGB(0x2eb6aa);
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 49) {
        CGFloat alpha = MIN(1, 1 - ((49 + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    [self offsetTable:scrollView];
}

#pragma mark - 监听tableview的偏移  因为默认延伸到了导航条里面  所以滚动的时候要给sectionView卡在导航条下面
- (void) offsetTable:(UIScrollView *) scrollView{
    CGFloat contentOffsety  = scrollView.contentOffset.y;
    //如果当前的section还没有超出navigationBar，那么就是默认的tableView的contentInset
    if (contentOffsety <= (tableViewHeadHight-64) && contentOffsety >= 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    //当section将要就如navigationBar的后面时，改变tableView的contentInset的top，那么section的悬浮位置就会改变
    else if(contentOffsety>=tableViewHeadHight - 64){
        self.tableView.contentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}



#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierStr = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    cell.textLabel.text = [NSString stringWithFormat:@"这是第几--%ld--行",indexPath.row];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    v.backgroundColor = [UIColor colorWithRed:0.6980 green:0.8392 blue:0.9882 alpha:1];
    v.text = @"这是section headview";
    return v;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
