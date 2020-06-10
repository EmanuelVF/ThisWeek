//
//  CloudKitExtension.swift
//  ThisWeek
//
//  Created by Emanuel on 04/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import CloudKit

extension Notification.Name{
    static let DoneNotification = Notification.Name("DoneNotificationReceived")
    static let UndoneNotification = Notification.Name("UndoneNotificationReceived")
}

struct NotificationFromUser{
    static let DoneNotificationKey = "Done"
    static let UndoneNotificationKey = "Undone"
}

extension Notification.Name{
    static let CloudKitNotifications = Notification.Name("iCloudRemoteNotificationReceived")
}
struct CloudKitNotifications{
    static let NotificationKey = "Notification"
}

struct Cloud{
    struct Entity{
        static let ThisWeek = "ThisWeek"
        static let Day = "Day"
        static let Activity = "Activity"
    }
    
    struct Attribute {
        static let Days = "days"
        static let SomethingChangedWhenRefresh = "somethingChangedWhenRefresh"
        
        static let LongDate  = "longDate"
        static let Date = "date"
        static let Activities = "activities"
        
        static let Name = "name"
        static let HasAReminder = "hasAReminder"
        static let Completed = "completed"
        static let Alarm = "alarm"
        static let FutureDay = "futureDay"
    }
    
    struct Defaults {
        static let predicateForAll = "TRUEPREDICATE"
        static let sortKeyModificationDate = "modificationDate"
        static let subscriptionIDAllUpdated = "AllUpdatedRecords"
        
    }
}


extension CKRecord{
    var wasCreatedByThisUser: Bool{
        return (creatorUserRecordID == nil) || (creatorUserRecordID?.recordName == "__defaultOwner__")
    }
}
