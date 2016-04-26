//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


///declare "customizeAppearance" method. once application finished launching, we call customizeAppearance method. customizeAppearance is responsible to theme the app. Implemented in .m file

-(void)customizeAppearance;



@end
