//
//  Activity.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
class Activity{
    
    private var name : String?
    private var hasAReminder : Bool?
    private var completed : Bool?
    
    init(name: String, hasAReminder: Bool, completed : Bool){
        self.name = name
        self.hasAReminder = hasAReminder
        self.completed = completed
    }
    
    func setName(with newName: String){
        self.name = newName
    }
    
    func getName() -> String?{
        return self.name
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
