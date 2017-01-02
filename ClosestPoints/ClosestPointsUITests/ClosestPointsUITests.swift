//
//  ClosestPointsUITests.swift
//  ClosestPointsUITests
//
//  Created by Robert Huston on 1/1/17.
//  Copyright © 2017 Pinpoint Dynamics. All rights reserved.
//

import XCTest

class ClosestPointsUITests: XCTestCase {

    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil

        super.tearDown()
    }

    func test_CanSetNumberOfPointsToFive() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let numberOfPointsScrollView = window.scrollViews.otherElements.children(matching: .textField)

        numberOfPointsBox.children(matching: .button).element.click()
        numberOfPointsScrollView.element(boundBy: 0).click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "5")
    }

    func test_CanSetNumberOfPointsToOneHundred() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let numberOfPointsScrollView = window.scrollViews.otherElements.children(matching: .textField)

        numberOfPointsBox.children(matching: .button).element.click()
        numberOfPointsScrollView.element(boundBy: 4).click()

        let pointsValue = numberOfPointsBox.value as! String

        XCTAssertEqual(pointsValue, "100")
    }

    func test_CanSetNumberOfPointsToOneThousand() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let numberOfPointsScrollView = window.scrollViews.otherElements.children(matching: .textField)

        numberOfPointsBox.children(matching: .button).element.click()
        numberOfPointsScrollView.element(boundBy: 7).click()

        let pointsValue = numberOfPointsBox.value as! String

        XCTAssertEqual(pointsValue, "1000")
    }

    func test_CanSetNumberOfPointsTo1234() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("1234\r")

        let pointsValue = numberOfPointsBox.value as! String

        XCTAssertEqual(pointsValue, "1234")
    }

    func test_LimitsNumberOfPointsToNoLessThan2() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("1\r")

        let pointsValue = numberOfPointsBox.value as! String

        XCTAssertEqual(pointsValue, "2")
    }

    func test_LimitsNumberOfPointsToNoMoreThan10000() {
        let window = XCUIApplication().windows["Window"]
        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("12345\r")

        let pointsValue = numberOfPointsBox.value as! String

        XCTAssertEqual(pointsValue, "10000")
    }

}
