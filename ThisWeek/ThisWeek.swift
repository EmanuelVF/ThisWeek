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
    
    func removeToDo(at day : Int, position: Int) -> Activity{
        return days[day].removeActivity(at: position)
    }
    
    init(numberOfDays: Int){
        var date = Date()
        let template = "EEEEddMMM"
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: NSLocale(localeIdentifier:"es_AR") as Locale )
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Defaults.localeIdentifier)
        
        for index in stride(from: 0, to: numberOfDays, by: 1){
            days.append(Day())
            if index == numberOfDays-1 {
                days.last?.setDate(with: Defaults.laterText)
            }else{
                days.last?.setDate(with: formatter.string(from: date))
            }
            date = date.addingTimeInterval(TimeInterval(exactly: Defaults.oneDay) ?? 0)
        }
    }
}

//    MARK: - Defaults values

extension ThisWeek{
    struct Defaults{
        static let numberOfDays = 8
        static let oneDay = 86400
        static let localeIdentifier = "es_AR"
        static let laterText = "Más Tarde"
        static let doneText = "Hecho"
        static let unDoneText = "Deshacer"
        static let newTaskText = "Nueva Tarea"
    }
    
}
