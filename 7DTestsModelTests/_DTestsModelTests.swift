//
//  _DTestsModelTests.swift
//  7DTestsModelTests
//
//  Created by Emanuel on 03/07/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import XCTest
@testable import _D

class _DTestsModelTests: XCTestCase {
    var sut: ThisWeek!
    
    override func setUp() {
        super.setUp()
        sut = ThisWeek(startingWith: Date(), numberOfDays: ThisWeek.Defaults.numberOfDays)
        print("hola")
    }

    override func tearDown() {
      sut = nil
      super.tearDown()
    }
    
    func testActivitiesListEmpty() {
        XCTAssertTrue(sut.days[0].getActivities().isEmpty)
    }
    
    func testAddActivity() {
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        XCTAssertFalse(sut.days[0].getActivities().isEmpty)
    }
    
    func testRemoveActivity() {
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        let activity  = sut.removeToDo(at: 0, position: 0)
        XCTAssertTrue(activity.getName() == "Leer")
        XCTAssertTrue(sut.days[0].getActivities().isEmpty)
    }
    
    func testRefreshToday() {
        sut = ThisWeek(startingWith: Date(), numberOfDays: ThisWeek.Defaults.numberOfDays)
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Saltar", hasAReminder: false, completed: true, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Jugar", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 1)
        sut.refresh(basedOn: (sut.days.first?.getLongDate())!, numberOfDays: ThisWeek.Defaults.numberOfDays)
        XCTAssertTrue(sut.days.first!.getActivities().count == 2)
    }
    
    func testRefreshOneDayPast() {
        sut = ThisWeek(startingWith: Date().addingTimeInterval(TimeInterval(exactly: -ThisWeek.Defaults.oneDay)!), numberOfDays: ThisWeek.Defaults.numberOfDays)
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Saltar", hasAReminder: false, completed: true, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Jugar", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 1)
        sut.refresh(basedOn: (sut.days.first?.getLongDate())!, numberOfDays: ThisWeek.Defaults.numberOfDays)
        XCTAssertTrue(sut.days.last!.getActivities().count == 1)
        XCTAssertTrue(sut.days.first!.getActivities().count == 1)
    }
    
    func testRefreshTooOutOfDate() {
        sut = ThisWeek(startingWith: Date().addingTimeInterval(TimeInterval(exactly: -10.0*Double(ThisWeek.Defaults.oneDay))!), numberOfDays: ThisWeek.Defaults.numberOfDays)
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Saltar", hasAReminder: false, completed: true, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Jugar", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 1)
        sut.refresh(basedOn: (sut.days.first?.getLongDate())!, numberOfDays: ThisWeek.Defaults.numberOfDays)
        XCTAssertTrue(sut.days.last!.getActivities().count == 2)
        XCTAssertTrue(sut.days.first!.getActivities().count == 0)
    }
    
    func testRefreshTooOutOfDateWithfutureDay() {
        sut = ThisWeek(startingWith: Date().addingTimeInterval(TimeInterval(exactly: -10.0*Double(ThisWeek.Defaults.oneDay))!), numberOfDays: ThisWeek.Defaults.numberOfDays)
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Saltar", hasAReminder: false, completed: true, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        sut.addToDo(activity: Activity(name: "Jugar", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 1)
        sut.addToDo(activity: Activity(name: "Roncar", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: Date().addingTimeInterval(TimeInterval(exactly: -8.0*Double(ThisWeek.Defaults.oneDay))!)), at: 7)
        sut.addToDo(activity: Activity(name: "Correr", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: Date().addingTimeInterval(TimeInterval(exactly: 2.0*Double(ThisWeek.Defaults.oneDay))!)), at: 7)
        sut.refresh(basedOn: (sut.days.first?.getLongDate())!, numberOfDays: ThisWeek.Defaults.numberOfDays)
        XCTAssertTrue(sut.days.last!.getActivities().count == 3)
        XCTAssertTrue(sut.days.first!.getActivities().count == 0)
    }
    
    func testJson(){
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        var newSut = ThisWeek(json: Data())
        newSut = ThisWeek(json: sut.json!)
        XCTAssertTrue(newSut!.days[0].getActivities().first!.getName() == "Leer")
        XCTAssertTrue(newSut?.json == sut.json)
    }
    
    func testInits(){
        sut.addToDo(activity: Activity(name: "Leer", hasAReminder: false, completed: false, alarmID: nil, alarmTime: nil, futureDay: nil), at: 0)
        let newSut = ThisWeek(withDays: sut.days, withRefresh: sut.somethingChangedWhenRefresh)
        XCTAssertTrue(newSut.days[0].getActivities().first!.getName() == "Leer")
    }

}
