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
    private var priority : Int?
    private var completed : Bool?
    
    init(name: String, priority: Int, completed : Bool){
        self.name = name
        self.priority = priority
        self.completed = completed
    }
    
    func setName(with newName: String){
        self.name = newName
    }
    
    func getName() -> String?{
        return self.name
    }
    
    func setPriority(with newPriority: Int?){
        self.priority = newPriority
    }
    
    func getPriority() -> Int?{
        return self.priority
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
