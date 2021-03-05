//
//  AppState.swift
//  PizzaHub
//
//  Created by Charles Hefele on 1/16/21.
//  Copyright © 2021 Charles Hefele. All rights reserved.
//

import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Tab = .pizzerias
}
