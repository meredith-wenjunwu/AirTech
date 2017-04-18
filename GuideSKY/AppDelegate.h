//
//  AppDelegate.h
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BLE.h"
#import "JQFMDB.h"
#import "Spirometry.h"
#import "Gas.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,BLEDelegate>

@property BLE *bleShield;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data



@end

