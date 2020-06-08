//
//  CloudThisWeekViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 04/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit
import CloudKit

class CloudThisWeekViewController: ThisWeekViewController {
    
    var ckThisWeekRecord : CKRecord{
        get{
            if _ckThisWeekRecord == nil {
                _ckThisWeekRecord = CKRecord(recordType: Cloud.Entity.ThisWeek)
            }
            return _ckThisWeekRecord!
        }
        set{
            _ckThisWeekRecord = newValue
        }
    }
    
    private var _ckThisWeekRecord : CKRecord?{
        didSet{
            print("set")
            let days = ckThisWeekRecord[Cloud.Attribute.Days] as? Data
            if (days != nil) {
                thisWeek = ThisWeek(json: days!)!
                weekTableView.reloadData()
            }
        }
    }

//   MARK: - App Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iCloudFetch()
        iCloudSubscribe()
        print("Subscribing...")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ckThisWeekRecord = CKRecord(recordType: Cloud.Entity.ThisWeek)
            
    //        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
    //            print("leer")
    //            self.iCloudFetch()
    //        }
    //
    //        Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { timer in
    //            print("guadar")
    //            self.iCloudUpdate()
    //        }
            
    //        //TO DO: Load the model
    //        print("Hardcoding model...")
    //        thisWeek.addToDo(activity: Activity(name: "Planchar", hasAReminder: false,completed: true, alarm: nil, futureDay: nil), at: 0)
    //        thisWeek.addToDo(activity: Activity(name: "Ir a comprar", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 0)
    //        thisWeek.addToDo(activity: Activity(name: "Reunion con Pepe", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 1)
    //        thisWeek.addToDo(activity: Activity(name: "Salir a correr", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 2)
    //        thisWeek.addToDo(activity: Activity(name: "Leer", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 3)
    //        thisWeek.addToDo(activity: Activity(name: "Comprar regalo para Pepe", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 3)
    //        thisWeek.addToDo(activity: Activity(name: "Cumpleaños Pepe", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 4)
    //        thisWeek.addToDo(activity: Activity(name: "Cocinar", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 6)
    //        thisWeek.addToDo(activity: Activity(name: "Averiguar sobre algo", hasAReminder: false,completed: false, alarm: nil, futureDay: nil), at: 7)
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        iCloudUnsubscribe()
    }
    
    
//   MARK: - Perform the Save
    override func endEditingTask(_ sender: UndoneActionTableViewCell) {
        super.endEditingTask(sender)
        self.iCloudUpdate()
    }
    
    override func addReminder(_ sender: SetReminderViewController) {
        super.addReminder(sender)
        self.iCloudUpdate()
    }
    
    override func deleteReminder(_ sender: SetReminderViewController) {
        super.deleteReminder(sender)
        self.iCloudUpdate()
    }
    
    override func setAFutureDay(_ sender: SetDateViewController) {
        super.setAFutureDay(sender)
        self.iCloudUpdate()
    }
    
    
    override func deleteAFutureDay(_ sender: SetDateViewController) {
        super.deleteAFutureDay(sender)
        self.iCloudUpdate()
    }
    
    private func iCloudUpdate(){
            if !thisWeek.days.isEmpty{
                ckThisWeekRecord[Cloud.Attribute.Days] = thisWeek.json
                iCloudSaveRecord(recordToSave: ckThisWeekRecord)
            }
       }
        
    private let database = CKContainer.default().privateCloudDatabase
    
    private func iCloudSaveRecord (recordToSave: CKRecord){
        print("try to save")
        database.save(recordToSave) { (savedRecord, error) in
            //parse errors here!
            if let ckError = error as? CKError{
                if ckError.code == CKError.Code.serverRecordChanged{
                    //ignore
                }
            }
        }
    }
    
    
    //   MARK: - Perform the Read
    
    var allWeeks = [CKRecord]() {
        didSet{
            if !allWeeks.isEmpty{
                ckThisWeekRecord = allWeeks.first!
            }
            
//            if let newData = (allWeeks.first![Cloud.Attribute.Days] as? Data){
//                print("hola")
//                //TODO : In here I could change this and assign the record to my record
//                thisWeek = ThisWeek(json: newData)!
//                weekTableView.reloadData()
//            }
        }
    }
    
    private func iCloudFetch(){
        print("read")
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: Cloud.Entity.ThisWeek, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)] // Read the Newest
        database.perform(query,inZoneWith: nil) { (records, error) in
            if records != nil {
                DispatchQueue.main.async {
//                    print(records!)
                    self.allWeeks = records!
                    //                    self.database.delete(withRecordID: records!.first!.recordID) { (recordID, error) in
                    //
                    //                    }
                    
                }
            }
        }
    }
        
    private func iCloudDeleteOldRecors(){
        //Maybe it is needed to fetch all and delete the old ones
    }
    
    //   MARK:- Subscription
    
    private let subscriptionID = "AllUpdatedRecords"
    private var cloudKitObserver : NSObjectProtocol?
    
    
    private func iCloudSubscribe(){
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        let subscription = CKQuerySubscription(
            recordType: Cloud.Entity.ThisWeek,
            predicate: predicate,
            subscriptionID: subscriptionID,
            options: [CloudKit.CKQuerySubscription.Options.firesOnRecordUpdate,CloudKit.CKQuerySubscription.Options.firesOnRecordCreation])
//        subscription.querySubscriptionOptions
        subscription.zoneID = nil
//        print(subscription.querySubscriptionOptions.rawValue)
//        print(subscription)
        
        subscription.notificationInfo = CKSubscription.NotificationInfo()
//        subscription.notificationInfo?.title = "hola"
//        subscription.notificationInfo?.alertBody = "hola"
        subscription.notificationInfo?.shouldSendContentAvailable = true
        subscription.notificationInfo?.shouldBadge = false
        
        
        
        database.save(subscription) { (subscription, error) in
            print("Error while subscribing... is \(error)")
            if let ckError = error as? CKError{
                print(ckError.code.rawValue)
                print(ckError.errorUserInfo)
                if ckError.code == CKError.Code.serverRejectedRequest{
                    print("hola")
                    // ignore
                }
            }
        }
        cloudKitObserver = NotificationCenter.default.addObserver(
            forName: .CloudKitNotifications,
            object: nil,
            queue: OperationQueue.main,
            using: { (notification) in
                if let ckqn = notification.userInfo?[CloudKitNotifications.NotificationKey] as? CKQueryNotification{
                    self.iCloudHandleSubscriptionNotification(ckqn: ckqn)
                }
            }
        )
    }
    
    private func iCloudHandleSubscriptionNotification(ckqn : CKQueryNotification){
        print("Processing Notification")
        if ckqn.subscriptionID == self.subscriptionID{
            if let recordID = ckqn.recordID{
                switch ckqn.queryNotificationReason{
                case .recordCreated:
                    break;
                case .recordUpdated:
                    database.fetch(withRecordID: recordID) { (record, error) in
                        if record != nil {
                            DispatchQueue.main.async {
                                self.allWeeks = [record!]
                            }
                        }
                    }
                default:
                    break;
                }
            }
            
        }
        
    }
    
    private func iCloudUnsubscribe(){
        database.delete(
        withSubscriptionID: subscriptionID) { (subscription, error) in
            //handle this
        }
        
        if let observer = self.cloudKitObserver{
            NotificationCenter.default.removeObserver(observer)
        }
        
    }
}
    
    
