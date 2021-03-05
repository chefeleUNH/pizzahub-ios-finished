//
//  PizzaHubApp.swift
//  PizzaHub
//
//  Created by Charles Hefele on 1/12/21.
//  Copyright © 2021 Charles Hefele. All rights reserved.
//

import SwiftUI

@main
struct PizzaHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(AppState())
                .environmentObject(ShoppingCart())
                .environmentObject(FirebaseSession())
        }
    }
}
