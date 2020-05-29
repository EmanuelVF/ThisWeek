//
//  Activity.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
import EventKit
class Activity{
    
//    MARK: Vars
    
    private var name : String?
    private var hasAReminder : Bool?
    private var completed : Bool?
    private var alarm : EKAlarm?
    
//    MARK: Initializer
    
    init(name: String, hasAReminder: Bool, completed : Bool, alarm : EKAlarm?){
        self.name = name
        self.hasAReminder = hasAReminder
        self.completed = completed
        self.alarm = alarm
    }
    
//    MARK: Functions
    
    func setName(with newName: String){
        self.name = newName
    }
    
    func getName() -> String?{
        return self.name
    }
    
    func setAlarm(with newAlarm: EKAlarm?){
        self.alarm = newAlarm
    }
    
    func getAlarm() -> EKAlarm?{
        return self.alarm
    }
    
    func setHasAReminder(with reminder : Bool?){
        self.hasAReminder = reminder
    }
    
    func hasItAReminder() -> Bool?{
        return self.hasAReminder
    }
    
    func complete(){
        self.completed = true
    }
    
    func unComplete(){
        self.completed = false
    }
    
    func isCompleted() -> Bool?{
        return self.completed
    }
}
