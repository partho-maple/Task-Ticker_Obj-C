//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

///synthesize the declared properties

@synthesize text, checked, notes, priority, priorityToDisplay;
@synthesize dueDate, shouldRemind, itemId;


///method to decode


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.notes = [aDecoder decodeObjectForKey:@"Notes"];
        self.priority = [aDecoder decodeObjectForKey:@"Priority"];
        self.priorityToDisplay = [aDecoder decodeObjectForKey:@"PriorityToDisplay"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntForKey:@"ItemID"];
    }
    return self;
}


///method to encode

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeObject:self.notes forKey:@"Notes"];
    [aCoder encodeObject:self.priority forKey:@"Priority"];
    [aCoder encodeObject:self.priorityToDisplay forKey:@"PriorityToDisplay"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInt:self.itemId forKey:@"ItemID"];
}




///method that records whether an item is checked

- (void)toggleChecked
{
    self.checked = !self.checked;
}


///We need to assign an id for each item. 

- (id)init
{
    if (self = [super init]) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}



///We need to assign an id for each item so that we can easily identify.
- (UILocalNotification *)notificationForThisItem
{
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotifications) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number != nil && [number intValue] == self.itemId) {

            return notification;
        }
    }
    return nil;
}


///We schedule notification here for the selected item. If there is any existing notification for this item, we remove them so that only latest alarm time will be fired.

- (void)scheduleNotification
{
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        
        NSLog(@"Found an existing notification %@", existingNotification);
       
        [[UIApplication sharedApplication] cancelLocalNotification:[self notificationForThisItem]];
        
    }
    
    
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.itemId] forKey:@"ItemID"];
        

        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
           NSLog(@"Scheduled notification %@ for itemId %d", localNotification, self.itemId);
    }
}




- (void)dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        //   NSLog(@"Removing existing notification %@", existingNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:
         existingNotification];
    }
}





@end
