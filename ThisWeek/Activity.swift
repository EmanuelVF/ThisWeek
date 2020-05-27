//
//  Activity.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
class Activity{
    
    var name : String
    var priority : Int
    var completed : Bool
    
    init(name: String, priority: Int, completed : Bool){
        self.name = name
        self.priority = priority
        self.completed = completed
    }
    
}
