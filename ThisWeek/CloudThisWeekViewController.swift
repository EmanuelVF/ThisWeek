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
            print(ckThisWeekRecord.recordID)
            let days = ckThisWeekRecord[Cloud.Attribute.Days] as? Data
            if (days != nil) {
                thisWeek = ThisWeek(json: days!)!
            }
        }
    }

//   MARK: - App Lifecycle
    
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
    
    
    
    
    
    
    
    var allWeeks = [CKRecord]() {
        didSet{
            thisWeek = ThisWeek(json: (allWeeks.first![Cloud.Attribute.Days] as? Data)!)!
            weekTableView.reloadData()
        }
    }
    
    private func iCloudFetch(){
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: Cloud.Entity.ThisWeek, predicate: predicate)
        database.perform(query,inZoneWith: nil) { (records, error) in
            if records != nil {
                DispatchQueue.main.async {
                    self.allWeeks = records!
                    self.database.delete(withRecordID: records!.first!.recordID) { (recordID, error) in
                        
                    }}
            }
        }
    }
}
