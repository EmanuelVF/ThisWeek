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
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddOneTaskMarkAsDoneandDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Done")].tap()
        XCTAssertEqual(app.cells.count,1)
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddOneTaskEditNameAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        XCTAssertEqual(app.cells.count,1)
        
        let textFieldm = app.tables.cells.children(matching: .textField).element
        let clearButton =  tablesQuery.textFields.buttons[localizedString("Clear text")]
        let rKey = app.keys["R"]
        let uKey = app.keys["u"]
        let nKey = app.keys["n"]
        let DoneKey = app.buttons["Done"]
        
        textFieldm.doubleTap()
        
        clearButton.tap()
    
        rKey.tap()
        uKey.tap()
        nKey.tap()
        DoneKey.tap()
    
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    
    func testAddOneTaskDoneUndoandDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables
        
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Done")].tap()
        XCTAssertEqual(app.cells.count,1)
        
        tablesQuery.cells.firstMatch.swipeRight()
        tablesQuery.buttons[localizedString("Undo")].tap()
        XCTAssertEqual(app.cells.count,1)
        
        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
    }
    
    func testAddsReminderAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables

        XCTAssertEqual(app.cells.count,1)

        let ReminderButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["⏲"]
        let datePickersQuery = app.datePickers
        let setButton = app.staticTexts[localizedString("Set")]
        let deleteReminderButton = app.staticTexts[localizedString("Delete reminder")]
        let cancelReminderButton = app.staticTexts[localizedString("Cancel")]
        
        if(Locale.current.identifier == "en_US"){
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
        }else if (Locale.current.identifier == "es_AR"){
            ReminderButton.tap()
            datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "01")
            datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "10")
            setButton.tap()

            ReminderButton.tap()
            datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "02")
            datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "15")
            setButton.tap()
            
        }else{
            XCTAssertThrowsError("Locale not considered")
        }
    
        ReminderButton.tap()
        cancelReminderButton.tap()

        ReminderButton.tap()
        deleteReminderButton.tap()

        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
        
    }
    
    func testAddsDateAndDeleteIt() throws {
        let addbuttonFirstRow = app.tables.firstMatch.otherElements.element(boundBy: 7).staticTexts["⊕"]
        addbuttonFirstRow.tap()
        let tablesQuery = app.tables

        XCTAssertEqual(app.cells.count,1)
        
        let DateButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["🗓"]
        let datePickersQuery = app.datePickers
        let setButton = app.staticTexts[localizedString("Set")]
        let deleteDateButton = app.staticTexts[localizedString("Delete date")]
        let cancelDateButton = app.staticTexts[localizedString("Cancel")]
        let editDateButton = app.staticTexts[localizedString("Edit")]
        let chooseDateButton = app.staticTexts[localizedString("Choose")]
        
        if(Locale.current.identifier == "en_US"){
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
        }else if(Locale.current.identifier == "es_AR"){
            DateButton.tap()
            datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2050")
            datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "enero")
            datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "1")
            
            setButton.tap()

            DateButton.tap()
            editDateButton.tap()
            datePickersQuery.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "febrero")
            datePickersQuery.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "23")
            datePickersQuery.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2050")
            chooseDateButton.tap()
            
        }else{
            XCTAssertThrowsError("Locale not considered")
        }

        DateButton.tap()
        cancelDateButton.tap()

        DateButton.tap()
        deleteDateButton.tap()

        tablesQuery.cells.firstMatch.swipeLeft()
        tablesQuery.buttons[localizedString("Delete")].tap()
        XCTAssertEqual(app.cells.count,0)
        
    }
}

func localizedString(_ key: String) -> String {
    let result = NSLocalizedString(key, bundle: Bundle(for: _DUITests.self), comment: "")
    return result
}
