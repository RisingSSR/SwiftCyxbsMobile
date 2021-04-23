//
//  NewQAMainPageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewQAMainPageViewController.h"
#import "FuncView.h"
#import "PostModel.h"
#import "ReportModel.h"
#import "GroupModel.h"
#import "FuncView.h"
#import "PostItem.h"
#import "PostModel.h"
#import "PostTableViewCell.h"
#import "MGDRefreshTool.h"
#import "StarPostModel.h"
#import "HotSearchModel.h"
#import "PostArchiveTool.h"
#import "FollowGroupModel.h"
#import "ShieldModel.h"
#import "ClassTabBar.h"
#import "GroupBtn.h"
#import "SearchBeginVC.h"   //搜索初始界面
#import "SZHReleaseDynamic.h" // 发布动态界面
#import "YYZTopicGroupVC.h"
#import "DynamicDetailMainVC.h" //动态详情页
#import "YYZTopicDetailVC.h"
#import "NewCountModel.h"


@interface NewQAMainPageViewController ()<ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,UITableViewDelegate,UITableViewDataSource,PostTableViewCellDelegate,TopFollowViewDelegate>
//帖子列表数据源数组
@property (nonatomic, strong) NSMutableArray *tableArray;
//headerView的控件高度
@property (nonatomic, assign) CGFloat TopViewHeight;
@property (nonatomic, assign) CGFloat NavHeight;
@property (nonatomic, assign) CGFloat recommendHeight;
@property (nonatomic, assign) CGFloat lineHeight;
//headerView控件
@property (nonatomic, strong) UIView *topBackView;
//列表顶部底部刷新控件
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
//热搜词汇模型
@property (nonatomic, strong) HotSearchModel *hotWordModel;
@property (nonatomic, strong) NSMutableArray *hotWordsArray;
@property (nonatomic, assign) int hotWordIndex;
//帖子模型
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PostModel *postmodel;
@property (nonatomic, strong) NSMutableArray<PostItem *> *postArray;
//我的关注模型
@property (nonatomic, strong) GroupModel *groupModel;
@property (nonatomic, strong) NSMutableArray<GroupItem *> *dataArray;
//加载视图菊花
@property (nonatomic, strong) MBProgressHUD *loadHUD;
//获取cell里item数据的NSDictionary
@property (nonatomic, strong) NSDictionary *itemDic;

@property (nonatomic, strong) NewCountModel *countModel;

@property(nonatomic,strong ) NSArray *topicArray;  //所有圈子信息

@end

@implementation NewQAMainPageViewController

// 加载邮问时隐藏底部课表
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    
    self.tableArray = [PostArchiveTool getPostList];
    self.dataArray = [PostArchiveTool getMyFollowGroup].dataArray;
    self.hotWordsArray = [PostArchiveTool getHotWords].hotWordsArray;
    
    //我的关注View高度
    _TopViewHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 191/375 : (SCREEN_WIDTH * 116/375);
    //推荐Label高度
    _recommendHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 54/375 : SCREEN_WIDTH * 43/375;
    _NavHeight = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    
    // 如果是退出登陆后再次登陆，由于程序还在运行，因此移除原来的界面，重新加载UI，判断用户是否为第一次登陆
    if ([UserItemTool defaultItem].firstLogin == YES) {
        NSLog(@"通过网络请求刷新页面");
        [self releaseView];
        self.page = 0;
        self.loadHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadHUD.labelText = @"正在加载中...";
        _tableView.contentInset = UIEdgeInsetsMake(_TopViewHeight, 0, 0, 0);
    
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
            dispatch_queue_t queue = dispatch_queue_create(0, DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadHotWords];
                    dispatch_semaphore_signal(semaphore);
                });
            });
            
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadMyStarGroupList];
                    dispatch_semaphore_signal(semaphore);
                });
            });
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self setMainViewUI];
                    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.topBackView.mas_bottom);
                        make.left.right.bottom.mas_equalTo(self.view);
                    }];
                    dispatch_semaphore_signal(semaphore);
                });
            });
            
            dispatch_async(queue, ^{
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_signal(semaphore);
            });
        }
    [[UserItemTool defaultItem] setFirstLogin:NO];
    [self getTopicID];
}

- (void)noDataInList {
    UIView *noListBackView = [[UIView alloc] init];
    noListBackView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    noListBackView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height-(_TopViewHeight));
    [self.tableView addSubview:noListBackView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"还没有相关动态哦～";
    noticeLabel.font = [UIFont fontWithName:PingFangSCLight size:12];
    noticeLabel.textColor = [UIColor colorNamed:@"CellDateColor"];
    [noListBackView addSubview:imageView];
    [noListBackView addSubview:noticeLabel];
    imageView.image = [UIImage imageNamed:@"图层 11"];
    CGSize size = [UIImage imageNamed:@"图层 11"].size;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noListBackView.top).mas_offset(SCREEN_WIDTH * 0.28 * 45.5/105);
        make.left.mas_equalTo(noListBackView.left).mas_equalTo(SCREEN_WIDTH * 0.28);
        make.size.mas_equalTo(size);
    }];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(noListBackView);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.2387 * 11.5/89.5);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(SCREEN_WIDTH * 0.38 * 33/142.5);
    }];
}

//邮问视图消失时显示底部课表
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

// 移除所有控件，重新加载控件并且通过缓存刷新数据，并再次请求新的数据
- (void)reSetTopFollowUI {
    NSLog(@"接收到用户关注圈子的操作，刷新此页面");
    [self releaseView];
    self.tableArray = [PostArchiveTool getPostList];
    self.dataArray = [PostArchiveTool getMyFollowGroup].dataArray;
    self.hotWordsArray = [PostArchiveTool getHotWords].hotWordsArray;
    [self setMainViewUI];
    [self.tableView reloadData];
    if ([self.tableArray count] == 0) {
        [self noDataInList];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        
    }
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    ((ClassTabBar *)self.tabBarController.tabBar).backgroundColor = [UIColor colorNamed:@"TABBARCOLOR"];
    //设置通知中心
    [self setNotification];
    //设置背景蒙版
    [self setBackViewWithGesture];
    //热搜词汇的索引
    self.hotWordIndex = 0;
    /**
        逻辑：首先取得缓存数据，如果有数据，则加载缓存的数据，同时根据帖子的条数来判断当前的page，下拉加载，上拉刷新
        如果缓存没有数据，则进行网络请求
     */
    /*
     tableArray:帖子列表数据源数组
     dataArray:我的关注数据源数组
     hotWordsArray:热搜词汇数据源数组
     */
    self.tableArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
    self.dataArray = [NSMutableArray arrayWithArray:[PostArchiveTool getMyFollowGroup].dataArray];
    self.hotWordsArray = [NSMutableArray arrayWithArray:[PostArchiveTool getHotWords].hotWordsArray];
    
    self.hotWordModel = [[HotSearchModel alloc] init];
    self.groupModel = [[GroupModel alloc] init];
    self.postmodel = [[PostModel alloc] init];
    self.countModel = [[NewCountModel alloc] init];
    
    
    // 如果用户是登陆的状态，再次打开此应用，则直接加载缓存数据，否则为第一次登陆，加载网络请求数据
    if ([UserItemTool defaultItem].firstLogin == NO && self.tableArray != nil && self.dataArray != nil && self.hotWordsArray != nil) {
        NSLog(@"初始化通过缓存加载页面");
        self.page = floor(self.tableArray.count / 6.0);
        [self setMainViewUI];
        [self loadHotWords];
        [self loadMyStarGroupList];
        if ([self.hotWordsArray count] != 0) {
            self->_searchBtn.searchBtnLabel.text = self.hotWordsArray[self->_hotWordIndex];
        } else {
            self->_searchBtn.searchBtnLabel.text = @"大家都在搜：红岩网校";
        }
    }else {
        NSLog(@"初始化通过网络请求加载页面");
        self.page = 0;
        self.loadHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadHUD.labelText = @"正在加载中...";
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        dispatch_queue_t queue = dispatch_queue_create(0, DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"热搜词汇网络请求");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadHotWords];
                dispatch_semaphore_signal(semaphore);
            });
        });
        
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"我的关注网络请求");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadMyStarGroupList];
                dispatch_semaphore_signal(semaphore);
            });
        });
        
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"帖子列表网络请求");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadData];
                dispatch_semaphore_signal(semaphore);
            });
        });
        
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"执行完成");
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationStyle = 0;
    
    ///每隔三秒钟调用一次变换热搜词汇的方法
    [NSTimer scheduledTimerWithTimeInterval:3.0
        target:self
        selector:@selector(refreshHotWords)
        userInfo:nil
        repeats:YES];
    
    [self funcPopViewinit];
    
}
//设置通知中心的监听
- (void)setNotification{
    ///帖子列表请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadSuccess)
                                                 name:@"NewQAListPageDataLoadSuccess" object:nil];
    ///帖子列表请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadError)
                                                 name:@"NewQAListDataLoadFailure" object:nil];
    ///热搜词汇请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadSuccess)
                                                 name:@"HotWordsDataLoadSuccess" object:nil];
    ///热搜词汇请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadError)
                                                 name:@"HotWordsDataLoadError" object:nil];
    ///我的关注请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadSuccess)
                                                 name:@"MyFollowGroupDataLoadSuccess" object:nil];
    ///我的关注请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadError)
                                                 name:@"MyFollowGroupDataLoadError" object:nil];
    
    ///通知刷新View
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reSetTopFollowUI)
                                                 name:@"reSetTopFollowUI" object:nil];
    ///通知刷新我的关注列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLoadGroupList)
                                                 name:@"reLoadGroupList" object:nil];
    
}

- (void)releaseView {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    _topFollowView = nil;
    _tableView = nil;
}

# pragma mark 初始化功能弹出页面
- (void)funcPopViewinit {
    // 创建分享页面
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    
    // 创建功能页面
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    
    // 创建举报页面
    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
    _reportView.delegate = self;
    
}

#pragma mark -热搜词汇相关
///热搜词汇的网络请求
- (void)loadHotWords {
    [self.hotWordModel getHotSearchArray];
}

///热搜词汇请求完成后数组赋值
- (void)howWordsLoadSuccess {
    self.hotWordsArray = self.hotWordModel.hotWordsArray;
    [PostArchiveTool saveHotWordsWith:self.hotWordModel];
}

///3s刷新热搜词汇
-(void)refreshHotWords {
    if ([self.hotWordsArray count] == 0) {
        return;
    }
    if (_hotWordIndex < [self.hotWordsArray count] - 1) {
        _hotWordIndex++;
    }else {
        _hotWordIndex = 0;
    }
    [UIView transitionWithView:_searchBtn.searchBtnLabel
                      duration:0.25f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        self->_searchBtn.searchBtnLabel.text = [NSString stringWithFormat:@"%@:%@",@"大家都在搜", self.hotWordsArray[self->_hotWordIndex]];

      } completion:nil];
}

- (void)howWordsLoadError {
    [NewQAHud showHudWith:@"热搜词汇请求失败～" AddView:self.view];
}

#pragma mark -我的关注相关
///我的关注的网络请求
- (void)loadMyStarGroupList {
    [self.groupModel loadMyFollowGroup];
    
}

///我的关注网络请求成功后数据源数组赋值
- (void)topFollowViewLoadSuccess {
    self.dataArray = self.groupModel.dataArray;
    [PostArchiveTool saveMyFollowGroupWith:self.groupModel];
    NSLog(@"我的关注请求成功");
}

///我的关注请求失败
- (void)topFollowViewLoadError {
    [NewQAHud showHudWith:@"  我的关注请求失败～  " AddView:self.view];
}

- (void)reLoadGroupList {
    [self.groupModel loadMyFollowGroup];
    [self refreshData];
}

#pragma mark- 帖子列表的网络请求

///下拉加载
- (void)loadData{
    NSLog(@"此时的page:%ld",(long)self.page);
    self.page += 1;
    [self.postmodel loadMainPostWithPage:self.page AndSize:6];
    NSLog(@"此时数据源数组的count===%lu",(unsigned long)[self.tableArray count]);
}

///上拉刷新
- (void)refreshData{
    [self.tableArray removeAllObjects];
    self.page = 1;
    NSLog(@"此时的page:%ld",(long)self.page);
    [self.postmodel loadMainPostWithPage:self.page AndSize:6];
}

///成功请求数据
- (void)NewQAListLoadSuccess {
    [self.loadHUD removeFromSuperview];
    if (self.page == 1) {
        self.tableArray = self.postmodel.postArray;
    }else {
        [self.tableArray addObjectsFromArray:self.postmodel.postArray];
    }
    
    [PostArchiveTool savePostListWith:self.tableArray];
    if(!self.tableView){
        [self setMainViewUI];
    }
    //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
    if (self.page == 1) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
    NSLog(@"成功请求列表数据");
}

///请求失败
- (void)NewQAListLoadError {
    [_loadHUD removeFromSuperview];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

- (RecommendedTableView *)tableView {
    if (!_tableView) {
        _tableView = [[RecommendedTableView alloc] initWithFrame:CGRectMake(0, NVGBARHEIGHT + STATUSBARHEIGHT + SCREEN_WIDTH * 14/375, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_WIDTH * 14/375 + NVGBARHEIGHT + STATUSBARHEIGHT))];
        _tableView.showsVerticalScrollIndicator = NO;
        //增加Observer，监听列表滑动
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        _tableView.contentInset = UIEdgeInsetsMake(_TopViewHeight, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (TopFollowView *)topFollowView {
    if (!_topFollowView) {
        self.topFollowView = [[TopFollowView alloc] initWithFrame:CGRectMake(0, _NavHeight, SCREEN_WIDTH , _TopViewHeight) And:self.dataArray];
        if (@available(iOS 11.0, *)) {
            self.topFollowView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            self.topFollowView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
        }
        self.topFollowView.delegate = self;
    }
    return _topFollowView;
}

- (RecommentLabel *)recommendedLabel {
    if (!_recommendedLabel) {
        _recommendedLabel = [[RecommentLabel alloc] init];
    }
    return _recommendedLabel;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topBackView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            _topBackView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
        }
    }
    return _topBackView;
}

- (SearchBtn *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[SearchBtn alloc] init];
        [_searchBtn addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotWords) name:@"refreshHotWords" object:nil];
    }
    return _searchBtn;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _publishBtn.backgroundColor = [UIColor clearColor];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"发布动态"] forState:UIControlStateNormal];
        [_publishBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_publishBtn addTarget:self action:@selector(clickedPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

///设置UI界面
- (void)setMainViewUI {
    //我的关注View高度
    _TopViewHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 191/375 : (SCREEN_WIDTH * 116/375);
    //推荐Label高度
    _recommendHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 54/375 : SCREEN_WIDTH * 43/375;
    _NavHeight = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    
    [self tableView];
    [self.view addSubview:self.tableView];
    [self setUpRefresh];

    self.topFollowView = [[TopFollowView alloc] initWithFrame:CGRectMake(0, _NavHeight, SCREEN_WIDTH , _TopViewHeight) And:self.dataArray];
    if (@available(iOS 11.0, *)) {
        self.topFollowView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        self.topFollowView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
    }
    self.topFollowView.delegate = self;
    [self.view addSubview:self.topFollowView];
    if ([self.dataArray count] == 0) {
        [self.view bringSubviewToFront:self.topFollowView.followBtn];
    }

    [self recommendedLabel];
    [self.topFollowView addSubview:_recommendedLabel];
    
    [self topBackView];
    [self.view addSubview:_topBackView];

    [self searchBtn];
    [_topBackView addSubview:_searchBtn];
    
    [self publishBtn];
    [self.view addSubview:_publishBtn];
    
    [self setMainViewFrame];
    
    _recommendedLabel.lineView.hidden = self.dataArray.count == 0 ? YES : NO;
}


- (void)setMainViewFrame {
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT);
    }];
    
    [_searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 37.5/343);
    }];
    _searchBtn.layer.cornerRadius = SCREEN_WIDTH * 0.9147 * 37.5/343 * 1/2;
    
    [_recommendedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_topFollowView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(_recommendHeight);
    }];
    
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(SCREEN_HEIGHT * 0.7256);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.17);
    }];
    _publishBtn.layer.cornerRadius = SCREEN_WIDTH * 0.17 * 1/2;
    _publishBtn.layer.masksToBounds = YES;
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_header = _header;
    
    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}

///监控滑动
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (-offset.y >= _TopViewHeight) {
            self.topFollowView.frame = CGRectMake(0, _NavHeight, SCREEN_WIDTH, _TopViewHeight);
        }
        else if (-offset.y > _recommendHeight && -offset.y < _TopViewHeight) {
            self.topFollowView.frame = CGRectMake(0, -offset.y - _TopViewHeight + _NavHeight, SCREEN_WIDTH, _TopViewHeight);
        }
        else if (-offset.y <= _NavHeight + _recommendHeight) {
            self.topFollowView.frame = CGRectMake(0, _NavHeight -_TopViewHeight  + _recommendHeight, SCREEN_WIDTH, _TopViewHeight);
        }
    }
}

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -RecommendedTableView的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"post%ldcell",indexPath.row];
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
        //这里
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.item = _item;
        cell.commendBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.starBtn.tag = indexPath.row;
        cell.tag = indexPath.row;
        if (cell.tag == 0) {
            cell.layer.cornerRadius = 10;
        }
    }
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - Cell中的相关事件
///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    StarPostModel *model = [[StarPostModel alloc] init];
    _itemDic = self.tableArray[cell.starBtn.tag];
    [model starPostWithPostID:[NSNumber numberWithString:_itemDic[@"post_id"]]];
}

///点击评论按钮跳转到具体的帖子详情:(可以通过帖子id跳转到具体的帖子页面，获取帖子id的方式如下方注释的代码)
- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.tableArray[cell.commendBtn.tag]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

///分享帖子
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    [self.view.window addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    _itemDic = self.tableArray[cell.shareBtn.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"redrock.zscy.youwen.share://token=%@&id=%@",[UserDefaultTool getToken],_itemDic[@"post_id"]];
    pasteboard.string = shareURL;
}

///点击标签跳转到相应的圈子
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell {
    _itemDic = self.tableArray[cell.groupLabel.tag];
    NSString *groupName = _itemDic[@"topic"];
    YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc] init];
    detailVC.topicIdString = groupName;
    int topicID;
    for(int i=0;i<self.topicArray.count;i++){
        NSDictionary *dic = self.topicArray[i];
        if([dic[@"topic_name"]isEqualToString:groupName])
            topicID = i+1;
    }
    detailVC.topicID = topicID;
    detailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)getTopicID {
    [[HttpClient defaultClient]requestWithPath:NEW_QA_TOPICGROUP method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"];
        self.topicArray = array;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"请求失败,请检查网络" AddView:self.view];
        }];
}
/**
 举报和屏蔽的多能按钮
 此处的逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
 */
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    UIWindow* desWindow=self.view.window;
    CGRect frame = [cell.funcBtn convertRect:cell.funcBtn.bounds toView:desWindow];
    [self showBackViewWithGesture];

    _itemDic = self.tableArray[cell.tag];
    if ([_itemDic[@"is_follow_topic"] intValue] == 1) {
        NSLog(@"取消关注");
        [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }else {
        NSLog(@"关注圈子");
        [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
    }
    _popView.layer.cornerRadius = 6;
    _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
    [self.view.window addSubview:_popView];
}

#pragma mark- 配置相关弹出View和其蒙版的操作
///设置相关蒙版

- (void)setBackViewWithGesture {
    _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backViewWithGesture.backgroundColor = [UIColor blackColor];
    _backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)showBackViewWithGesture {
    [self.view.window addSubview:_backViewWithGesture];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [_popView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_reportView removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

#pragma mark -多功能View的代理方法
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    _itemDic = self.tableArray[sender.tag];
    FollowGroupModel *model = [[FollowGroupModel alloc] init];
    [model FollowGroupWithName:_itemDic[@"topic"]];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showUnStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    }
}

///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    ShieldModel *model = [[ShieldModel alloc] init];
    _itemDic = self.tableArray[sender.tag];
    [model ShieldPersonWithUid:_itemDic[@"uid"]];
    [model setBlock:^(id  _Nonnull info) {
        if ([info[@"info"] isEqualToString:@"success"]) {
            [self showShieldSuccessful];
        }
    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [_popView removeFromSuperview];
    _itemDic = self.tableArray[sender.tag];
    _reportView.postID = _itemDic[@"post_id"];
    _reportView.frame = CGRectMake(MAIN_SCREEN_W * 0.1587, SCREEN_HEIGHT * 0.1, MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587,MAIN_SCREEN_W * 0.6827 * 329/256);
    [self.view.window addSubview:_reportView];
//    [_reportView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 0.2309);
//        make.left.mas_equalTo(self.view.window.mas_left).mas_offset(SCREEN_WIDTH * 0.1587);
//        make.right.mas_equalTo(self.view.window.mas_right).mas_offset(-SCREEN_WIDTH * 0.1587);
//        make.height.mas_equalTo(self.view.window.width * 0.6827 * 329/256);
//    }];
}

#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    ReportModel *model = [[ReportModel alloc] init];
    [model ReportWithPostID:_reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:_reportView.textView.text];
    [model setBlock:^(id  _Nonnull info) {
        [self showReportSuccessful];
    }];
}

///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}


#pragma mark- 配置相关操作成功后的弹窗
- (void)showStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view AndToDo:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
    }];
}

- (void)showUnStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view AndToDo:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
    }];
}

- (void)funcViewFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
}

- (void)showShieldSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  将不再推荐该用户的动态给你  " AddView:self.view];
}

- (void)showReportSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  举报成功  " AddView:self.view];
}

- (void)showReportFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  网络繁忙，请稍后再试  " AddView:self.view];
}

- (void)shareSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  已复制链接，可以去分享给小伙伴了～  " AddView:self.view];
}

#pragma mark -分享View的代理方法
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

#pragma mark 跳转到别的页面的方法

#pragma mark- 我的关注页面的代理方法
///关注更多--跳转到圈子广场
- (void)FollowGroups {
    YYZTopicGroupVC *topVc = [[YYZTopicGroupVC alloc]init];
    topVc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:topVc animated:YES];
}

///点击我的关注中的已关注的圈子跳转到具体的圈子里去
- (void)ClickedGroupBtn:(GroupBtn *)sender {
    NSString *groupName = sender.groupBtnLabel.text;
    if (sender.tag == 0) {
        [_countModel queryNewCountWithTimestamp:[self currentTimeStr]];
        YYZTopicGroupVC *topVc = [[YYZTopicGroupVC alloc]init];
        topVc.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:topVc animated:YES];
    }else {
        [_countModel queryNewCountWithTimestamp:[self currentTimeStr]];
        YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc]init];
        detailVC.topicID = [sender.item.topic_id intValue];
        detailVC.topicIdString = groupName;
        detailVC.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


#pragma mark -发布动态和搜索的跳转
///点击了发布按钮，跳转到发布动态的页面8i7k
- (void)clickedPublishBtn {
    SZHReleaseDynamic *vc = [[SZHReleaseDynamic alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"跳转到发布界面");
}

///点击了搜索按钮，跳转到搜索页面
- (void)searchPost {
    SearchBeginVC *vc = [[SearchBeginVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"跳转到搜索页面");
}

// 获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", time];
    return timeString;
}

@end


