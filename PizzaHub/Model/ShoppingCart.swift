//
//  ShoppingCart.swift
//  PizzaHub
//
//  Created by Charles Hefele on 2/11/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import Combine

enum ShoppingCartError: Error {
    case menuItemDoesNotMatchPizzeria
}

class ShoppingCart: ObservableObject {
    @Published var pizzeria: Pizzeria?  // a shopping cart can only contain one pizzeria at a time, and won't contain one until the user adds an item to the cart
    @Published var items = [MenuItem]()
    
    var total: Double {
        if items.count > 0 {
            return items.reduce(0) { $0 + Double($1.price)! }
        } else {
            return 0
        }
    }
    
    func add(item: MenuItem, pizzeria: Pizzeria) throws {
        // if the pizzeria hasn't been set yet, set it now
        if self.pizzeria == nil {
            self.pizzeria = pizzeria
        }
        
        // if the pizzerias don't match, throw an error
        if self.pizzeria != pizzeria {
            throw ShoppingCartError.menuItemDoesNotMatchPizzeria
        }
        
        // the pizzerias match, so add the item
        items.append(item)
    }
    
    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            
            // if this was the last item in the list, reset the pizzeria to null (so that a new order can begin)
            if items.isEmpty {
                reset()
            }
        }
    }
    
    func reset() {
        pizzeria = nil
        items = [MenuItem]()
    }
}
