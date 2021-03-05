//
//  PizzeriaListView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 2/11/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

let pizzeriasCollectionRef = Firestore.firestore().collection("pizzerias")

struct PizzeriaListView: View {
    @ObservedObject private var pizzerias: FirebaseCollection<Pizzeria>
    private var pizzeriasQuery: Query
    
    init() {
        self.pizzeriasQuery = pizzeriasCollectionRef.order(by: "city")
        self.pizzerias = FirebaseCollection<Pizzeria>(query: pizzeriasQuery)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pizzerias.items) { pizzeria in
                    NavigationLink(destination: PizzeriaDetailView(pizzeria: pizzeria)) {
                        PizzeriaRow(pizzeria: pizzeria)
                    }
                }
            }
            .navigationBarTitle("Pizzerias")
        }
    }
}

struct PizzeriaListView_Previews: PreviewProvider {
    static var previews: some View {
        PizzeriaListView()
    }
}
