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
        let window = app.windows["Window"]

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let numberOfPointsScrollView = window.scrollViews.otherElements.children(matching: .textField)

        numberOfPointsBox.children(matching: .button).element.click()
        numberOfPointsScrollView.element(boundBy: 0).click()

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "5")
    }

    func test_CanSetNumberOfPointsToOneHundred() {
        let window = app.windows["Window"]

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let numberOfPointsScrollView = window.scrollViews.otherElements.children(matching: .textField)

        numberOfPointsBox.children(matching: .button).element.click()
        numberOfPointsScrollView.element(boundBy: 4).click()

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "100")
    }

    func test_CanSetNumberOfPointsToOneThousand() {
        let window = app.windows["Window"]

        // Bah! Stupid Apple keeps changing how we do UI testing. Make up yer minds!
        
        window/*@START_MENU_TOKEN@*/.comboBoxes/*[[".groups.comboBoxes",".comboBoxes"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element.click()
        window/*@START_MENU_TOKEN@*/.scrollBars/*[[".groups",".comboBoxes",".scrollViews.scrollBars",".scrollBars"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element(boundBy: 0).click()
        window/*@START_MENU_TOKEN@*/.scrollViews/*[[".groups",".comboBoxes.scrollViews",".scrollViews"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.otherElements.children(matching: .textField).element(boundBy: 7).click()

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)
        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "1000")
    }

    func test_CanSetNumberOfPointsTo1234() {
        let window = app.windows["Window"]

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("1234\r")

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "1234")
    }

    func test_LimitsNumberOfPointsToNoLessThan2() {
        let window = app.windows["Window"]

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("1\r")

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "2")
    }

    func test_LimitsNumberOfPointsToNoMoreThan10000() {
        let window = app.windows["Window"]

        let numberOfPointsBox = window.comboBoxes.element(boundBy: 0)

        window.groups.containing(.button, identifier:"Generate").children(matching: .comboBox).element.typeText("12345\r")

        window/*@START_MENU_TOKEN@*/.buttons["Generate"]/*[[".groups.buttons[\"Generate\"]",".buttons[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

        let pointsValue = numberOfPointsBox.value as! String
        XCTAssertEqual(pointsValue, "10000")
    }

}
