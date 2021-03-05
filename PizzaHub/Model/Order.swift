//
//  Order.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/23/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Order : FirebaseCodable {
    var id: String
    @Published var items: [String]
    @Published var pizzeria: String
    @Published var total: String
    @Published var timestamp: Timestamp
    @Published var logo: String
    @Published var userId: String
    
    required init?(id: String, data: [String : Any]) {
        guard let items = data["items"] as? [String],
            let pizzeria = data["pizzeria"] as? String,
            let total = data["total"] as? String,
            let timestamp = data["timestamp"] as? Timestamp,
            let logo = data["logo"] as? String,
            let userId = data["user_id"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.items = items
        self.pizzeria = pizzeria
        self.total = total
        self.timestamp = timestamp
        self.logo = logo
        self.userId = userId
    }
    
    #if DEBUG
    static let example = Order(id: "1", data: ["items": ["Cheese Pizza", "Wings"],
                                               "pizzeria": "The Pizza Lady",
                                               "total": "24.99",
                                               "timestamp": Timestamp(),
                                               "logo": "logo/pizza_lady.png",
                                               "user_id": "Ye4CdGcba1duSk5fPD2KJSMc1nh2"])!
    #endif
}
