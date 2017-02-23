//
//  OnlineCatalogueUITests.swift
//  OnlineCatalogueUITests
//
//  Created by Azinec Development on 2/23/17.
//  Copyright © 2017 Azinec Development. All rights reserved.
//

import XCTest

class OnlineCatalogueUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFiltering() {
      
      let app = XCUIApplication()
      let filtersButton = app.buttons["Filters..."]
      filtersButton.tap()
      
      let tablesQuery = app.tables
      tablesQuery.buttons["MCU"].tap()
      tablesQuery.buttons["Plata"].tap()
      tablesQuery.sliders["49%"].tap()
      
      let applyButton = tablesQuery.buttons["Apply"]
      applyButton.tap()
      filtersButton.tap()
      
      let mptCellsQuery = tablesQuery.cells.containing(.button, identifier:"MPT")
      mptCellsQuery.children(matching: .button).matching(identifier: "MHN").element(boundBy: 0).tap()
      tablesQuery.buttons["Oro Premium"].tap()
      applyButton.tap()
      filtersButton.tap()
      mptCellsQuery.children(matching: .button).matching(identifier: "MCO").element(boundBy: 0).tap()
      tablesQuery.buttons["Premium"].tap()
      applyButton.tap()
      
    }
  func testDetailsView() {
    
    let app = XCUIApplication()
    app.buttons["Filters..."].tap()
    
    let tablesQuery = app.tables
    tablesQuery.cells.containing(.button, identifier:"MPT").children(matching: .button).matching(identifier: "MCO").element(boundBy: 0).tap()
    
    let tablesQuery2 = tablesQuery
    tablesQuery2.buttons["Oro"].tap()
    tablesQuery.buttons["Apply"].tap()
    tablesQuery2.staticTexts["Apple Iphone 5s Nuevo Sellado +obsequio ! Promoción !"].tap()
    app.buttons["Close"].tap()
    
  }
    
}
