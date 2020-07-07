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
        //given
        let addbuttonFirstRow = app.tables["Empty list"].otherElements.firstMatch.staticTexts["⊕"]
        addbuttonFirstRow.tap()
        XCTAssertEqual(app.cells.count,1)
    }
}
