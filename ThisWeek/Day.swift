//
//  Day.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
class Day{
    
    var Date = ""
    var activities = [Activity] ()
    
    func addActivity(activity : Activity){
        activities.append(activity)
    }
    
    func removeActivity(at index: Int){
        activities.remove(at: index)
    }
    
    
    init(){
        
    }
}
