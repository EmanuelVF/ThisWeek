//
//  ThisWeek.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation

struct ThisWeek:Codable {
    
//    MARK: Vars
    
    var days = [Day]()
    var somethingChangedWhenRefresh : Bool = false
    var json : Data?{
        return try? JSONEncoder().encode(self)
    }
    var shouldUseBackup = false
    
//    MARK: Functions
    
    func addToDo(activity: Activity ,at day : Int){
        days[day].addActivity(activity: activity)
    }
    
    func removeToDo(at day : Int, position: Int) -> Activity{
        return days[day].removeActivity(at: position)
    }
    
    init(startingWith date: Date, numberOfDays: Int){
        setDaysDates(startingWith: date, using : numberOfDays, creating: true)
        
    }
    
    init?(json : Data){
        if let newValue = try? JSONDecoder().decode(ThisWeek.self, from: json){
            self = newValue
        }else{
            return nil
        }
    }
    
    init(withDays days : [Day], withRefresh somethingChangedWhenRefresh : Bool ){
        self.days = days
        self.somethingChangedWhenRefresh = somethingChangedWhenRefresh
        
    }
    
    mutating func refresh( basedOn firstDay : Date, numberOfDays: Int){
        var currentDay : Int?
        
        somethingChangedWhenRefresh = false
        
        let today = Date()
        if !Calendar.current.isDateInToday(firstDay){
            for index in stride(from: 0, to: days.count-2, by: 1){
                if Calendar.current.isDateInToday(days[index].getLongDate()!){
                    currentDay = index
                }
            }
            
            //Set the days correctly
            setDaysDates(startingWith: today, using : numberOfDays, creating : false)
            
            if currentDay != nil {
                
                //Move the uncompleted activities from the passed days to the last section!
                for indexDay in stride(from: 0, to: currentDay!, by: 1){
                    for indexAct in days[indexDay].getActivities().indices{
                        if !days[indexDay].getActivities()[indexAct].isCompleted()!{
                            days[indexDay].getActivities()[indexAct].setAlarm(with: nil)
                            days[indexDay].getActivities()[indexAct].setHasAReminder(with: false)
                            days.last!.appendActivity(newElement: days[indexDay].getActivities()[indexAct])
                            if !(somethingChangedWhenRefresh) {
                                somethingChangedWhenRefresh = true
                            }
                        }
                    }
                    days[indexDay].removeAllActivities()
                }
                
                //Update the days that are coming...
                for indexDay in stride(from: currentDay!, to: days.count-1, by: 1){
                    for indexAct in days[indexDay].getActivities().indices{
                        days[indexDay - currentDay!].appendActivity(newElement: days[indexDay].getActivities()[indexAct])
                    }
                    days[indexDay].removeAllActivities()
                }
                
            }else{
                
                //Move all days' acts to the last section deleting the done activities
                for indexDay in stride(from: 0, through: days.count-1, by:1) {
                    for indexAct in days[indexDay].getActivities().indices{
                        if !days[indexDay].getActivities()[indexAct].isCompleted()!{
                            days[indexDay].getActivities()[indexAct].setAlarm(with: nil)
                            days[indexDay].getActivities()[indexAct].setHasAReminder(with: false)
                            days.last!.appendActivity(newElement: days[indexDay].getActivities()[indexAct])
                            if !(somethingChangedWhenRefresh) {
                                somethingChangedWhenRefresh = true
                            }
                            
                        }
                    }
                    days[indexDay].removeAllActivities()
                }
            }
            days.last!.sortDay()
            
            //TODO: Move a programmed item to the corresponding date
            
            for indexActs in days.last!.getActivities().indices{
                if let futureDay = days.last!.getActivities()[indexActs].getFutureDay(){
                    if futureDay < Date(){
                        days.last!.getActivities()[indexActs].setFutureDay(with: nil)
                    }
                }
            }
            
            var itemsToDelete : [Int] = []
            for indexActs in days.last!.getActivities().indices{
                if let futureDay = days.last!.getActivities()[indexActs].getFutureDay(){
                    for indexDays in stride(from: 0, through: days.count-2, by:1){
                        if Calendar.current.isDate(days[indexDays].getLongDate()!, inSameDayAs: futureDay){
                            days[indexDays].appendActivity(newElement: days.last!.getActivities()[indexActs])
                            itemsToDelete.append(indexActs)
                        }
                    }
                }
            }
            
            for index in itemsToDelete{
                _ = days.last!.removeActivity(at: index)
            }
        }
    }
        
    mutating private func setDaysDates(startingWith date : Date, using numberOfDays : Int, creating : Bool){
        let template = Defaults.dateTemplate
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: NSLocale(localeIdentifier:Defaults.localeIdentifier) as Locale )
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Defaults.localeIdentifier)
        
        var editableDate = date
        
        if creating{
            for index in stride(from: 0, to: numberOfDays, by: 1){
                days.append(Day())
                if index == numberOfDays-1 {
                    days.last?.setDate(with: Defaults.laterText)
                }else{
                    days.last?.setDate(with: formatter.string(from: editableDate))
                    days.last?.setLongDate(with: editableDate)
                }
                editableDate = editableDate.addingTimeInterval(TimeInterval(exactly: Defaults.oneDay) ?? 0)
            }
            
        }else{
            for index in stride(from: 0, to: numberOfDays, by: 1){
                if index == numberOfDays-1 {
                    days[index].setDate(with: Defaults.laterText)
                }else{
                    days[index].setDate(with: formatter.string(from: editableDate))
                    days[index].setLongDate(with: editableDate)
                }
                editableDate = editableDate.addingTimeInterval(TimeInterval(exactly: Defaults.oneDay) ?? 0)
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
        static let oneWeek = 8*86400
        static let localeIdentifier = "es_AR"
        static let laterText = "Más Tarde"
        static let doneText = "Hecho"
        static let unDoneText = "Deshacer"
        static let newTaskText = "Nueva Tarea"
    }
    
}
