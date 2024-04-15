//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    // my tests
    func testSubtotalOfOneItem() {
        register.scan(Item(name: "200 Page Notebook", priceEach: 200))
        XCTAssertEqual(200, register.subtotal())
    }
    
    func testTwoForOneBeans() {
        register.clear()
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        var receipt = register.getReceipt()
        var expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
TOTAL: $3.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
        XCTAssertEqual(398, register.subtotal())
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        
        receipt = register.total()
        expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
DISCOUNT: -$2.99
------------------
TOTAL: $2.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
        XCTAssertEqual(298, receipt.total())
    }
    
    func testGroupDiscountForKetchupAndBeer() {
        register.clear()
        register.scan(Item(name: "Ketchup (20oz Bottle)", priceEach: 230))
        register.scan(Item(name: "Beer (12oz Bottle)", priceEach: 157))  // total 387
        var receipt = register.getReceipt()
        var expectedReceipt = """
Receipt:
Ketchup (20oz Bottle): $2.30
Beer (12oz Bottle): $1.57
------------------
DISCOUNT: -$0.39
------------------
TOTAL: $3.48
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
        XCTAssertEqual(348, register.subtotal())
    }
}
