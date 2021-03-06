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
            let days = ckThisWeekRecord[Cloud.Attribute.Days] as? Data
            if (days != nil) {
                thisWeek = ThisWeek(json: days!) ?? ThisWeek(startingWith: Date(), numberOfDays: ThisWeek.Defaults.numberOfDays)
                thisWeek.refresh(basedOn: thisWeek.days.first!.getLongDate()!, numberOfDays: ThisWeek.Defaults.numberOfDays)
                // Advise that something chaged
                if thisWeek.somethingChangedWhenRefresh{
                    let alert = UIAlertController(
                        title: Defaults.alertTitle,
                        message: Defaults.alertMessage,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: ThisWeek.Defaults.doneText, style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
                saveBackUp()
                syncAllNotifications()
                weekTableView.reloadData()
            }
        }
    }

//   MARK: - App Lifecycle
    
    var activeObserver :NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ckThisWeekRecord = CKRecord(recordType: Cloud.Entity.ThisWeek)
        NotificationCenter.default.addObserver(self, selector: #selector(didActivate), name: UIScene.didActivateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didInactivate), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iCloudSubscribe()
    }
    
    @objc func didActivate() {
        readBackUp()
        if !thisWeek.shouldUseBackup{
            iCloudFetch()
        }else{
            self.iCloudUpdate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didInactivate() {
        self.iCloudUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.iCloudUpdate()
        iCloudUnsubscribe()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
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
    
    override func doneActions() {
        super.doneActions()
        self.iCloudUpdate()
    }
    
    override func undoneActions() {
        super.undoneActions()
        self.iCloudUpdate()
    }
    
    override func deleteActions() {
        super.deleteActions()
        self.iCloudUpdate()
    }
    
    override func insertActions() {
        super.insertActions()
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
    
    override func saveModel() {
        super.saveModel()
        self.iCloudUpdate()
    }
    
    func saveBackUp(){
        if let json = thisWeek.json{
            if let url = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create : true).appendingPathComponent(ThisWeekViewController.Defaults.backUpFile){
                do{
                   try json.write(to: url)
                }catch{ //let error{

                }
            }
        }
    }
    
    func readBackUp(){
        if let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(ThisWeekViewController.Defaults.backUpFile){
            if let jsonData = try? Data(contentsOf: url){
                thisWeek = ThisWeek(json: jsonData) ?? ThisWeek(startingWith: Date(), numberOfDays: ThisWeek.Defaults.numberOfDays)
                thisWeek.refresh(basedOn: thisWeek.days.first!.getLongDate()!, numberOfDays: ThisWeek.Defaults.numberOfDays)
                // Advise that something chaged
                if thisWeek.somethingChangedWhenRefresh{
                    let alert = UIAlertController(
                        title: Defaults.alertTitle,
                        message: Defaults.alertMessage,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: ThisWeek.Defaults.doneText, style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
                syncAllNotifications()
                weekTableView.reloadData()
            }
        }
        
    }
    
    
    private func iCloudUpdate(){
            if !thisWeek.days.isEmpty{
                ckThisWeekRecord[Cloud.Attribute.Days] = thisWeek.json
                iCloudSaveRecord(recordToSave: ckThisWeekRecord)
            }
       }
        
    private let database = CKContainer.default().privateCloudDatabase
    
    private func iCloudSaveRecord (recordToSave: CKRecord){
        database.save(recordToSave) { (savedRecord, error) in
            if error == nil{
                self.thisWeek.shouldUseBackup = false
                self.saveBackUp()
            }else{
                if let ckError = error as? CKError{
                    self.thisWeek.shouldUseBackup = true
                    self.saveBackUp()
                    if ckError.code == CKError.Code.serverRecordChanged{
                        //ignore
                    }
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
        }
    }
    
    private func iCloudFetch(){
        let predicate = NSPredicate(format: Cloud.Defaults.predicateForAll)
        let query = CKQuery(recordType: Cloud.Entity.ThisWeek, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: Cloud.Defaults.sortKeyModificationDate, ascending: false)] // Read the Newest
        database.perform(query,inZoneWith: nil) { (records, error) in
            if records != nil {
                DispatchQueue.main.async {
                    self.allWeeks = records!
                }
            }
        }
    }
    
    //   MARK:- Subscription
    
    private let subscriptionID = Cloud.Defaults.subscriptionIDAllUpdated
    private var cloudKitObserver : NSObjectProtocol?
    
    private func iCloudSubscribe(){
        let predicate = NSPredicate(format: Cloud.Defaults.predicateForAll)
        
        let subscription = CKQuerySubscription(
            recordType: Cloud.Entity.ThisWeek,
            predicate: predicate,
            subscriptionID: subscriptionID,
            options: [CloudKit.CKQuerySubscription.Options.firesOnRecordUpdate,CloudKit.CKQuerySubscription.Options.firesOnRecordCreation])
        subscription.zoneID = nil
        
        subscription.notificationInfo = CKSubscription.NotificationInfo()
        subscription.notificationInfo?.shouldSendContentAvailable = true
        subscription.notificationInfo?.shouldBadge = false
        
        database.save(subscription) { (subscription, error) in
            if let ckError = error as? CKError{
                if ckError.code == CKError.Code.serverRejectedRequest{
                    //TODO: Handle errors.
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
        if ckqn.subscriptionID == self.subscriptionID{
            if let recordID = ckqn.recordID{
                switch ckqn.queryNotificationReason{
                case .recordCreated:
                    break;
                case .recordUpdated:
                    database.fetch(withRecordID: recordID) { (record, error) in
                        //TODO: Handle errors.
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
            //TODO: Handle errors.
        }
        
        if let observer = self.cloudKitObserver{
            NotificationCenter.default.removeObserver(observer)
        }
        
    }
}
    
    
