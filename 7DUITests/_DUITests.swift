//
//  _DUITests.swift
//  7DUITests
//
//  Created by Emanuel on 07/07/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import XCTest

class _DUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAddOneTask() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        XCTAssertEqual(app.cells.count,1)
    }
    
    func testAddOneTaskandDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.swipeLeft()
        print(localizedString("Delete"))
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddOneTaskMarkAsDoneandDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Done"].tap()
        XCTAssertEqual(app.cells.count,1)
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddOneTaskEditNameAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        XCTAssertEqual(app.cells.count,1)
        
        let textFieldm = app.tables.cells.children(matching: .textField).element
        let clearButton =  tablesQuery/*@START_MENU_TOKEN@*/.textFields.buttons["Clear text"]/*[[".cells",".textFields.buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/
        let rKey = app.keys["R"]
        let uKey = app.keys["u"]
        let nKey = app.keys["n"]
        let DoneKey = app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        
        textFieldm.doubleTap()
        
        clearButton.tap()
    
        rKey.tap()
        uKey.tap()
        nKey.tap()
        DoneKey.tap()
    
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    
    func testAddOneTaskDoneUndoandDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Done"].tap()
        XCTAssertEqual(app.cells.count,1)
        
        tablesQuery.cells.firstMatch.swipeRight()
        tablesQuery.buttons["Undo"].tap()
        XCTAssertEqual(app.cells.count,1)
        
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddsReminderAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables

        XCTAssertEqual(app.cells.count,1)

        let ReminderButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["⏲"]
        let datePickersQuery = app.datePickers
        let setButton = app/*@START_MENU_TOKEN@*/.staticTexts["Set"]/*[[".buttons[\"Set\"].staticTexts[\"Set\"]",".staticTexts[\"Set\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let deleteReminderButton = app/*@START_MENU_TOKEN@*/.staticTexts["Delete reminder"]/*[[".buttons[\"Delete reminder\"].staticTexts[\"Delete reminder\"]",".staticTexts[\"Delete reminder\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let cancelReminderButton = app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        ReminderButton.tap()
        datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "1")
        datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
        datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "AM")
        setButton.tap()

        ReminderButton.tap()
        datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "2")
        datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "15")
        datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "AM")
        setButton.tap()

        ReminderButton.tap()
        cancelReminderButton.tap()

        ReminderButton.tap()
        deleteReminderButton.tap()

        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count,0)
        
    }
    
    func testAddsDateAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.element(boundBy: 7).staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables

        XCTAssertEqual(app.cells.count,1)
        
        let DateButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["🗓"]
        let datePickersQuery = app.datePickers
        let setButton = app/*@START_MENU_TOKEN@*/.staticTexts["Set"]/*[[".buttons[\"Set\"].staticTexts[\"Set\"]",".staticTexts[\"Set\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let deleteDateButton = app.staticTexts["Delete date"]
        let cancelDateButton = app/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let editDateButton = app.staticTexts["Edit"]
        let chooseDateButton = app.staticTexts["Choose"]

        DateButton.tap()
        datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2050")
        datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        
        setButton.tap()

        DateButton.tap()
        editDateButton.tap()
        datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "February")
        datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "23")
        datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2050")
        chooseDateButton.tap()

        DateButton.tap()
        cancelDateButton.tap()

        DateButton.tap()
        deleteDateButton.tap()

        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count,0)
        
    }
}

func localizedString(_ key: String) -> String {
    let result = NSLocalizedString(key, bundle: Bundle(for: _DUITests.self), comment: "")
    return result
}
