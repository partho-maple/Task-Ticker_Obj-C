//
//  DataModel.h
//  Task List
//
//  Created by Partho Biswas on 9/9/12.
//  Copyright (c) 2012 Partho Biswas. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DataModel : NSObject



/// We declare nextChecklistItemId method to assign an ID for each notification scheduled.

+ (int)nextChecklistItemId;


@end
