//
//  ThisWeek.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation

class ThisWeek {
    
//    MARK: Vars
    
    var days = [Day]()
    
//    MARK: Functions
    
    func addToDo(activity: Activity ,at day : Int){
        days[day].addActivity(activity: activity)
    }
    
    func removeToDo(at day : Int, position: Int) -> Activity{
        return days[day].removeActivity(at: position)
    }
    
    init(numberOfDays: Int){
        var date = Date()
        let template = Defaults.dateTemplate
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: NSLocale(localeIdentifier:Defaults.localeIdentifier) as Locale )
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
    
    func refresh( basedOn today : Date){
        var currentDay : Int?
        
        if !Calendar.current.isDateInToday(today){
            for index in days.indices{
                if Calendar.current.isDateInToday(days[index].getLongDate()!){
                    currentDay = index
                }
            }
            
            if currentDay != nil {
                //Set the days correctly
                //For the days that are usefull, move them
                //For the days passed, Move all to future deleting done actions
            }else{
                //Move all to future deleting done actions
            }
        }
    }
}

//    MARK: - Defaults values

extension ThisWeek{
    struct Defaults{
        static let dateTemplate = "EEEEddMMM"
        static let numberOfDays = 8
        static let oneDay = 86400
        static let localeIdentifier = "es_AR"
        static let laterText = "Más Tarde"
        static let doneText = "Hecho"
        static let unDoneText = "Deshacer"
        static let newTaskText = "Nueva Tarea"
    }
    
}
