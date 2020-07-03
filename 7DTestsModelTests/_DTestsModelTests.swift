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

}
