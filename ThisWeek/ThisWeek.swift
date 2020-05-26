//
//  ThisWeek.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation

class ThisWeek {
    
     var days = [Day]()
    
    func addToDo(activity: Activity ,at day : Int){
        days[day].addActivity(activity: activity)
    }
    
    func removeToDo(at day : Int, position: Int){
        days[day].removeActivity(at: position)
    }
    
    init(numberOfDays: Int){
        var date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: Defaults.localeIdentifier)
        
        for index in stride(from: 0, to: numberOfDays, by: 1){
            days.append(Day())
            if index == numberOfDays-1 {
                days.last?.Date = "Later"
            }else{
                days.last?.Date = formatter.string(from: date)
            }
            date = date.addingTimeInterval(TimeInterval(exactly: Defaults.oneDay) ?? 0)
        }
    }
}

extension ThisWeek{
    struct Defaults{
        static let numberOfDays = 8
        static let oneDay = 86400
        static let localeIdentifier = "es_ARG"
    }
    
}
