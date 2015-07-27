//
//  ViewController.m
//  WhereAmI
//
//  Created by limao on 15/7/21.
//  Copyright (c) 2015年 limaofuyuanzhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (strong,nonatomic) CLLocationManager *locationManager; /**< 地理位置管理器 */
@property (strong,nonatomic) CLLocation *previousPoint; /**< 最后一次更新得到的位置*/
@property (assign,nonatomic) CLLocationDistance totalMovementDistance;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel; /**< 纬度 */
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel; /**< 经度 */
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel; /**< 水平精度 */
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel; /**< 海拔高度 */
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel; /**< 垂直精度 */
@property (weak, nonatomic) IBOutlet UILabel *distanceTraveledLabel; /**< 距离 */


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建地理位置管理对象
    self.locationManager = [[CLLocationManager alloc] init];
    //申请授权
    [self.locationManager requestAlwaysAuthorization];
    //设置管理器委托
    self.locationManager.delegate = self;
    //设置精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //启动位置管理器
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - CLLocationManagerDelegate Methods

//地理位置发生更新时
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //如果在一段比较短的时间发生了多次位置更新，这几次位置更新有可能会被一次性全部上报。无论何时，最后一项表示当前位置
    CLLocation *newLocation = [locations lastObject];
    
    //显示纬度
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
    self.latitudeLabel.text = latitudeString;
    
    //显示经度
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.longitude];
    self.longitudeLabel.text = longitudeString;
    
    //显示水平精度
    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.horizontalAccuracy];
    self.horizontalAccuracyLabel.text = horizontalAccuracyString;
    
    //显示海拔高度
    NSString *altitudeString = [NSString stringWithFormat:@"%gm",newLocation.altitude];
    self.altitudeLabel.text = altitudeString;
    
    //显示垂直精度
    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm",newLocation.verticalAccuracy];
    self.verticalAccuracyLabel.text = verticalAccuracyString;
    
    if (newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    if (newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50) {
        return;
    }
    
    if (self.previousPoint == nil) {
        return;
    } else {
        self.totalMovementDistance += [newLocation distanceFromLocation:self.previousPoint];
    }
    self.previousPoint = newLocation;
    
    NSString *distanceString = [NSString stringWithFormat:@"%gm",self.totalMovementDistance];
    self.distanceTraveledLabel.text = distanceString;

}

//获取地理位置失败时
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied": @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location" message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
