#line 1 "/Users/panda/Documents/github/FloatingWindow/FloatingWindow/FloatingWindow.xm"









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


SBUserInstalledApplicationIcon *_SBUserInstalledApplicationIcon=nil;

SBApplication *mm=nil;
int maxpage=0;
int flag=0;
UIImageView *_imageView =nil;

UIWindow *mwindow=nil;

UIWindow *nwindow=nil;



UIWindow *keywindow =nil;


UIPanGestureRecognizer *point=nil;
CGPoint panPoint;
UIView* aHudV=nil;
UISwitch *switchButton=nil;


#define WIDTH mwindow.frame.size.width
#define HEIGHT mwindow.frame.size.height

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height





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




#include <logos/logos.h>
#include <substrate.h>
@class SpringBoard; 
static void _logos_method$_ungrouped$SpringBoard$click(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$switchAction(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$showresult2(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$changeColor(SpringBoard*, SEL); static void _logos_method$_ungrouped$SpringBoard$locationChange$(SpringBoard*, SEL, UIPanGestureRecognizer *); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(SpringBoard*, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(SpringBoard*, SEL, id); 

#line 182 "/Users/panda/Documents/github/FloatingWindow/FloatingWindow/FloatingWindow.xm"



static void _logos_method$_ungrouped$SpringBoard$click(SpringBoard* self, SEL _cmd){
    NSLog(@"click");
    _imageView.alpha = 1;
}




static void _logos_method$_ungrouped$SpringBoard$switchAction(SpringBoard* self, SEL _cmd) {
        NSLog(@"switchAction");
    
    if([switchButton isOn]){
        notify_post("RecordTouch");
        
    }
    else{
        
    }
}





static void _logos_method$_ungrouped$SpringBoard$showresult2(SpringBoard* self, SEL _cmd) {
    NSLog(@"showresult2");
    
    if(flag==0){
        nwindow.hidden=NO;
        flag=1;
    }
    else if(flag==1){
        nwindow.hidden=YES;
        flag=0;
    }
    
    
}



static void _logos_method$_ungrouped$SpringBoard$changeColor(SpringBoard* self, SEL _cmd) {
    [UIView animateWithDuration:2.0 animations:^{
        _imageView.alpha = 0.3;
    }];
}



static void _logos_method$_ungrouped$SpringBoard$locationChange$(SpringBoard* self, SEL _cmd, UIPanGestureRecognizer * piont){
    
    panPoint = [piont locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    
    if(piont.state == UIGestureRecognizerStateBegan)
    {
        _imageView.alpha = 1;
    }
    
    if(piont.state == UIGestureRecognizerStateChanged)
    {
        mwindow.center = CGPointMake(panPoint.x, panPoint.y);
    }
    
    
    
    else if(piont.state == UIGestureRecognizerStateEnded)
    {
        
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


static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(SpringBoard* self, SEL _cmd, id application) {
    _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
    NSLog(@"-(void)applicationDidFinishLaunching:(id)application");
    
    
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
    
    switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(120, 20, 20, 10)];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
 
    UILabel *switch_Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    switch_Label.text = [NSString stringWithFormat:@"清空内存"];
    switch_Label.textColor = [UIColor whiteColor];
    
    
    
    nwindow = [[UIWindow alloc] initWithFrame:CGRectMake(kScreenWidth/2-150, kScreenHeight/2-150, 300, 300)];
    nwindow.backgroundColor = [UIColor grayColor];
    nwindow.windowLevel = UIWindowLevelStatusBar;
    [nwindow addSubview:switchButton];
    [nwindow addSubview:switch_Label];
    [nwindow makeKeyAndVisible];
    nwindow.hidden=YES;
    
    
    mwindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    mwindow.backgroundColor = [UIColor clearColor];
    mwindow.windowLevel = UIWindowLevelStatusBar;
    [mwindow makeKeyAndVisible];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"/System/Library/CoreServices/SpringBoard.app/panda.png"];
    _imageView.alpha = 0.5;

    [mwindow addSubview:_imageView];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = YES;
    [mwindow addGestureRecognizer:pan];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showresult2)];
    [mwindow addGestureRecognizer:tap];
    

    
    
    [[objc_getClass("SBBacklightController") sharedInstance] turnOnScreenFullyWithBacklightSource:nil];
    [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions: nil];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(click), (IMP)&_logos_method$_ungrouped$SpringBoard$click, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(switchAction), (IMP)&_logos_method$_ungrouped$SpringBoard$switchAction, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(showresult2), (IMP)&_logos_method$_ungrouped$SpringBoard$showresult2, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(changeColor), (IMP)&_logos_method$_ungrouped$SpringBoard$changeColor, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPanGestureRecognizer *), strlen(@encode(UIPanGestureRecognizer *))); i += strlen(@encode(UIPanGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(locationChange:), (IMP)&_logos_method$_ungrouped$SpringBoard$locationChange$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} }
#line 392 "/Users/panda/Documents/github/FloatingWindow/FloatingWindow/FloatingWindow.xm"
