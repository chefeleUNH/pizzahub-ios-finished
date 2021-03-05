//
//  PizzaHubTests.swift
//  PizzaHubTests
//
//  Created by Charles Hefele on 2/11/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import XCTest
@testable import PizzaHub

class PizzaHubTests: XCTestCase {
    
    func testMenuItemInitSucceeds() {
        let smallPepperoniItem = MenuItem(id: "1", data: ["name": "Small Pepperoni", "price": "12.50", "photo": "1"])
        XCTAssertNotNil(smallPepperoniItem)
        
        let largeSupremeItem = MenuItem(id: "1", data: ["name": "Large Supreme", "price": "27.00", "photo": "1"])
        XCTAssertNotNil(largeSupremeItem)
    }
    
    func testMenuItemInitFails() {
        let missingNameItem = MenuItem(id: "1", data: ["price": "12.50", "photo": "1"])
        XCTAssertNil(missingNameItem)
        
        let missingPriceItem = MenuItem(id: "1", data: ["name": "Small Pepperoni", "photo": "1"])
        XCTAssertNil(missingPriceItem)
    }
    
    func testShoppingCartAddItem() {
        let cart = ShoppingCart()
        XCTAssertEqual(0, cart.items.count)
        
        try! cart.add(item: MenuItem.example, pizzeria: Pizzeria.example)
        XCTAssertEqual(1, cart.items.count)
        
        try! cart.add(item: MenuItem.example, pizzeria: Pizzeria.example)
        XCTAssertEqual(2, cart.items.count)
    }
    
    func testShoppingCartReturnTotal() {
        let smallPepperoniItem = MenuItem(id: "1", data: ["name": "Small Pepperoni", "price": "12.50", "photo": "1"])
        let largeSupremeItem = MenuItem(id: "1", data: ["name": "Large Supreme", "price": "27.00", "photo": "1"])
        let cart = ShoppingCart()
        
        try! cart.add(item: smallPepperoniItem!, pizzeria: Pizzeria.example)
        try! cart.add(item: largeSupremeItem!, pizzeria: Pizzeria.example)
        
        XCTAssertEqual(39.50, cart.total)
    }
    
    func testShoppingCartAddIncompatibleMenuItem() {
        let pizzeria1 = Pizzeria.example
        let pizzeria2 = Pizzeria(id: "2", data: ["name": "Vittoria's",
                                                 "city": "Westerly",
                                                 "state": "RI",
                                                 "logo": "logo/vittorias.png"])
        let cart = ShoppingCart()
        
        // add the first item, which should init the shopping cart with pizzeria1
        try! cart.add(item: MenuItem.example, pizzeria: pizzeria1)
        
        // now try to add a menu item from pizzeria2, which should throw an error
        XCTAssertThrowsError(try cart.add(item: MenuItem.example, pizzeria: pizzeria2!))
    }
    
    func testShoppingCartReset() {
        let cart = ShoppingCart()
        
        // it's a new shopping cart so the pizzeria should be nil...
        XCTAssertNil(cart.pizzeria)
        
        // ...and the list of items should also be zero-length
        XCTAssertEqual(0, cart.items.count)
        
        // add the first item, which should make the pizzeria non-nil and increase the length to one
        try! cart.add(item: MenuItem.example, pizzeria: Pizzeria.example)
        XCTAssertNotNil(cart.pizzeria)
        XCTAssertEqual(1, cart.items.count)
        
        // now reset the cart
        cart.reset()
        
        // the pizzeria should once again be nil...
        XCTAssertNil(cart.pizzeria)
        
        // ...and the list of items should be zero-length once again
        XCTAssertEqual(0, cart.items.count)
    }
    
}
