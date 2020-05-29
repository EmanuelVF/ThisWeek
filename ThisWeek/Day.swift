//
//  Day.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
class Day{
    
//    MARK: Vars
    
    private var Date : String? = ""
    private var activities = [Activity] ()
    
//    MARK: Functions
    
    func addActivity(activity : Activity){
        activities.append(activity)
    }
    
    func removeActivity(at index: Int) -> Activity {
        return activities.remove(at: index)
    }
    
    func insertActivity(newElement: Activity, at index: Int){
        activities.insert(newElement,at: index)
    }
    
    func getActivities()-> [Activity]{
        return activities
    }
    
    func sortDay(){
        let completedActivities = activities.filter{$0.isCompleted()!}
        let unCompletedActivities = activities.filter{!$0.isCompleted()!}
        activities = unCompletedActivities + completedActivities
    }
    
    func setDate(with newDate: String){
        self.Date = newDate.capitalized
    }
    
    func getDate() -> String?{
        return self.Date
    }
    
    init(){
        
    }
}
