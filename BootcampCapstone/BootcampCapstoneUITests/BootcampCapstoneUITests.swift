//
//  BootcampCapstoneUITests.swift
//  BootcampCapstoneUITests
//
//  Created by user301385 on 9/17/26.
//

import XCTest

final class BootcampCapstoneUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testProductCatalogCriticalPath() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(
            app.navigationBars["Dashboard"].waitForExistence(timeout: 10),
            "Log in to app first"
        )

        // open hamburger
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.08, dy: 0.1)).tap()
        
        // go to products
        let productsMenuItem = app.buttons["Products"]
        XCTAssertTrue(productsMenuItem.waitForExistence(timeout: 5))
        productsMenuItem.tap()
        
        // getting a product
        let productRow = app.cells.firstMatch
        XCTAssertTrue(productRow.waitForExistence(timeout: 30), "No product rows.")

        let productName = productRow.staticTexts.firstMatch.label
        XCTAssertFalse(productName.isEmpty, "Product name is empty.")
        productRow.tap()

        XCTAssertTrue(app.staticTexts[productName].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Product Number:"].exists)
    }

    @MainActor
    func testEmployeeDetailsCriticalPath() throws {
        let app = XCUIApplication()
        app.launch()

        openMenuItem("Employee Info", in: app)

        XCTAssertTrue(app.navigationBars["Employees"].waitForExistence(timeout: 10))
        let employeeSegment = app.buttons["Employees"]
        XCTAssertTrue(employeeSegment.waitForExistence(timeout: 10))
        employeeSegment.tap()

        let employeeRow = app.cells.firstMatch
        XCTAssertTrue(employeeRow.waitForExistence(timeout: 30), "The employee list did not show any employees.")
        employeeRow.tap()

        XCTAssertTrue(app.staticTexts["Employee ID:"].waitForExistence(timeout: 10))
    }

    @MainActor
    func testOrdersDetailsCriticalPath() throws {
        let app = XCUIApplication()
        app.launch()

        openMenuItem("Orders", in: app)

        XCTAssertTrue(app.staticTexts["Active Orders"].waitForExistence(timeout: 10))
        let orderRow = app.cells.firstMatch
        XCTAssertTrue(orderRow.waitForExistence(timeout: 30), "The orders list did not show any orders.")
        orderRow.tap()

        XCTAssertTrue(app.staticTexts["Order Number:"].waitForExistence(timeout: 10))
    }

    @MainActor
    private func openMenuItem(_ title: String, in app: XCUIApplication) {
        XCTAssertTrue(
            app.navigationBars["Dashboard"].waitForExistence(timeout: 10),
            "The app must be logged in and showing the Dashboard before this test starts."
        )
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.08, dy: 0.1)).tap()

        let menuItem = app.buttons[title]
        XCTAssertTrue(menuItem.waitForExistence(timeout: 5), "The View menu did not show \(title).")
        menuItem.tap()
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
