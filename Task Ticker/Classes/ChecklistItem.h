//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"


@interface ChecklistItem : NSObject <NSCoding>

///declare propertis of the items we want to store

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy) NSString *notes;

@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *priorityToDisplay;

@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, assign) BOOL shouldRemind;
@property (nonatomic, assign) int itemId;



///declare method to schedule local notification
- (void)scheduleNotification;

///declare method when user tap on an item to mark it as compelted
- (void)toggleChecked;


@end