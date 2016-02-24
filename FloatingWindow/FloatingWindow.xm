
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

//#error iOSOpenDev post-project creation from template requirements (remove these lines after completed) -- \
//	Link to libsubstrate.dylib: \
//	(1) go to TARGETS > Build Phases > Link Binary With Libraries and add /opt/iOSOpenDev/lib/libsubstrate.dylib \
//	(2) remove these lines from *.xm files (not *.mm files as they're automatically generated from *.xm files)

#import <notify.h>
#import <xpc/xpc.h>
#import "SBAppswitcherModel.h"
#import "SBApplicationController.h"
#import "SBApplication.h"
#import "SBHUDController.h"
#import "SBHUDView.h"

#import "SBLockScreenManager.h"
#import "SBBacklightController.h"


#import <UIKit/UIPanGestureRecognizer.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UISwitch.h>
#import <UIKit/UILabel.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIView.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UITapGestureRecognizer.h>


#import <objc/runtime.h>

@interface SBIconController {}
+(id)sharedInstance;
-(id)rootIconListAtIndex:(unsigned)index;
@end

@interface SBApplicationIcon {}
-(void)setBadge:(id)badge;
@end

@interface SBIconListView{}
-(id)icons;
@end

@interface SBUserInstalledApplicationIcon:SBApplicationIcon{}
-(id)isKindOfClass:(id)number;
@end

//SBIconListView *_SBIconListView =nil;
SBUserInstalledApplicationIcon *_SBUserInstalledApplicationIcon=nil;
//SBApplicationIcon *_SBApplicationIcon=nil;
SBApplication *mm=nil;
int maxpage=0;
int flag=0;
UIImageView *_imageView =nil;
//悬浮窗
UIWindow *mwindow=nil;
//点击悬浮窗弹出的主窗口
UIWindow *nwindow=nil;

//手势坐标依赖的keywindow
//SBAppWindow加载完成后获取SBAppWindow作为keyWindow
UIWindow *keywindow =nil;


UIPanGestureRecognizer *point=nil;
CGPoint panPoint;
UIView* aHudV=nil;
UISwitch *switchButton=nil;

//悬浮窗长宽
#define WIDTH mwindow.frame.size.width
#define HEIGHT mwindow.frame.size.height
//屏幕长宽
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height




//获取全部页清理角标
void getpage()
{
    id listview=[objc_getClass("SBIconController") sharedInstance];
    while([listview rootIconListAtIndex:maxpage]){maxpage=maxpage+1;}
    for(int pagecount=0;pagecount<maxpage;pagecount++)
    {
        id pagelistview=[listview rootIconListAtIndex:pagecount];
        for (_SBUserInstalledApplicationIcon in [pagelistview icons]){
            if([_SBUserInstalledApplicationIcon isKindOfClass:[objc_getClass("SBApplicationIcon") class]]  )
            {
                [_SBUserInstalledApplicationIcon setBadge:[NSNumber numberWithInt:0]];
            }
            NSLog(@"_SBUserInstalledApplicationIcon = %@",_SBUserInstalledApplicationIcon);
        }
    }
}


//进程清理
void killprocess()
{
    int version = [[[UIDevice currentDevice] systemVersion] intValue];
    NSLog(@"version = %d",version);
    if(version>=7 && version<8 )
    {
        id appSwitcherModel = [objc_getClass("SBAppSwitcherModel") sharedInstance];
        if ([appSwitcherModel respondsToSelector:@selector(snapshot)]) {
            NSMutableArray *appList = [appSwitcherModel snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary];
            for (id identifier in appList) {
                NSLog(@"identifier = %@",identifier);
                mm= [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier];
                int pid=[mm pid];
                NSLog(@"pid = %d",pid);
                if(pid>0){
                    NSString *strKill = [NSString stringWithFormat:@"sptool --exec \"kill -9 %d\"",pid];
                    system([strKill UTF8String]);
                }
                [appSwitcherModel remove:identifier];
            }
        }
    }
    if(version>=8 && version<9)
    {
        id appSwitcherModel = [objc_getClass("SBAppSwitcherModel") sharedInstance];
        if ([appSwitcherModel respondsToSelector:@selector(snapshot)]) {
            NSMutableArray *appList = [appSwitcherModel snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary];
            for (id identifier in appList) {
                NSLog(@"identifier = %@",identifier);
                mm= [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier];
                int pid=[mm pid];
                NSLog(@"pid = %d",pid);
                if(pid>0){
                    NSString *strKill = [NSString stringWithFormat:@"sptool --exec \"kill -9 %d\"",pid];
                    system([strKill UTF8String]);
                }
                [appSwitcherModel remove:identifier];
            }
        }
    }
}


//内存清理完成后显示清理结果
void showresult()
{
    id hudC = [objc_getClass("SBHUDController") sharedHUDController];
    id hudV = objc_getClass("SBHUDView");
    UIView* aHudV = [[hudV alloc] initWithHUDViewLevel:0];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aHudV.frame.size.width, aHudV.frame.size.height)];
    titleLabel.text = @"内存全部释放";
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [aHudV addSubview:titleLabel];
    [hudC presentHUDView:aHudV autoDismissWithDelay:1];
    
}

//监听消息效应事件
void LogEvent(CFNotificationCenterRef center,
              void *observer,
              CFStringRef name,
              const void *object,
              CFDictionaryRef userInfo)
{
    killprocess();
    showresult();
    getpage();
}




%hook SpringBoard

%new
- (void)click{
    NSLog(@"click");
    _imageView.alpha = 1;
}


//点击主窗口上switch button响应事件
%new
-(void)switchAction {
        NSLog(@"switchAction");
    
    if([switchButton isOn]){
        notify_post("RecordTouch");
        //xpc_client();
    }
    else{
        
    }
}


%new
//点击悬浮窗响应事件
-(void)showresult2
{
    NSLog(@"showresult2");
    //xpc_listener();
    if(flag==0){
        nwindow.hidden=NO;
        flag=1;
    }
    else if(flag==1){
        nwindow.hidden=YES;
        flag=0;
    }
    
    
}

%new
-(void)changeColor
{
    [UIView animateWithDuration:2.0 animations:^{
        _imageView.alpha = 0.3;
    }];
}

//悬浮窗被拖动
%new
-(void)locationChange:(UIPanGestureRecognizer *)piont{
    //ipad need global keywindow [[UIApplication sharedApplication] keyWindow]]
    panPoint = [piont locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    //拖动开始
    if(piont.state == UIGestureRecognizerStateBegan)
    {
        _imageView.alpha = 1;
    }
    //拖动中
    if(piont.state == UIGestureRecognizerStateChanged)
    {
        mwindow.center = CGPointMake(panPoint.x, panPoint.y);
    }
    
    //拖动结束悬浮窗停留位置
    //屏幕分为四个象限，根据到边框的距离计算停留位置
    else if(piont.state == UIGestureRecognizerStateEnded)
    {
        //  第一象限
        if(panPoint.x <= kScreenWidth/2 && panPoint.y <= kScreenHeight/2)
        {
            if(panPoint.y <= panPoint.x)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(WIDTH/2, panPoint.y);
                }];
            }
        }
        
        //第三象限
        else if(panPoint.x <= kScreenWidth/2 && panPoint.y > kScreenHeight/2)
        {
            if(kScreenHeight-panPoint.y <= panPoint.x)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(WIDTH/2, panPoint.y);
                }];
            }
            
        }
        
        //第二象限
        else if(panPoint.x > kScreenWidth/2 && panPoint.y <= kScreenHeight/2)
        {
            if(panPoint.y <= kScreenWidth-panPoint.x)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(panPoint.x, HEIGHT/2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(kScreenWidth-WIDTH/2, panPoint.y);
                }];
            }
            
        }
        
        //第四象限
        else if(panPoint.x > kScreenWidth/2 && panPoint.y > kScreenHeight/2)
        {
            if(kScreenHeight-panPoint.y <= kScreenWidth-panPoint.x)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(panPoint.x, kScreenHeight-HEIGHT/2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 animations:^{
                    mwindow.center = CGPointMake(kScreenWidth-WIDTH/2, panPoint.y);
                }];
            }
            
        }
    }
}

-(void)applicationDidFinishLaunching:(id)application
{
    %orig;
    NSLog(@"-(void)applicationDidFinishLaunching:(id)application");
    
    //注册监听消息，收到消息名为 RecordTouch 的消息执行 LogEvent
    if(  [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]  )
    {
        CFNotificationCenterAddObserver(
                                        CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        LogEvent,
                                        (CFStringRef)@"RecordTouch",
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately
                                        );
    }
    //主窗口上的switch button
    switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(120, 20, 20, 10)];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
 
    UILabel *switch_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    switch_Label.text = [NSString stringWithFormat:@"清空内存"];
    switch_Label.textColor = [UIColor whiteColor];
    
    
    //点击悬浮窗弹出的主窗口
    nwindow = [[UIWindow alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, kScreenHeight/2-150, 300, 300)];
    nwindow.backgroundColor = [UIColor grayColor];
    nwindow.windowLevel = UIWindowLevelStatusBar;
    [nwindow addSubview:switchButton];
    [nwindow addSubview:switch_Label];
    [nwindow makeKeyAndVisible];
    nwindow.hidden=YES;
    
    //创建悬浮窗
    mwindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    mwindow.backgroundColor = [UIColor clearColor];
    mwindow.windowLevel = UIWindowLevelStatusBar;
    [mwindow makeKeyAndVisible];
    
    //悬浮窗背景图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"/System/Library/CoreServices/SpringBoard.app/panda.png"];
    _imageView.alpha = 0.5;

    [mwindow addSubview:_imageView];
    
    //创建悬浮窗拖动响应
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = YES;
    [mwindow addGestureRecognizer:pan];
    
    //创建悬浮窗点击响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showresult2)];
    [mwindow addGestureRecognizer:tap];
    
//    NSLog(@"mwindow = %@",mwindow);
    
    //解锁
    [[objc_getClass("SBBacklightController") sharedInstance] turnOnScreenFullyWithBacklightSource:nil];
    [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions: nil];
}

%end
