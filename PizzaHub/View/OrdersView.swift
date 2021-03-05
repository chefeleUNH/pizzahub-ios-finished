//
//  OrdersView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/23/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

let ordersCollectionRef = Firestore.firestore().collection("orders")

struct OrdersView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        NavigationView {
            Group {
                if (session.isSignedIn) {
                    OrdersInternalView(orders: FirebaseCollection<Order>(query: ordersCollectionRef.whereField("user_id", isEqualTo: session.user?.uid ?? "nil").order(by: "timestamp", descending: true)))
                } else {
                    Button("Sign in to view past orders") {
                        appState.selectedTab = Tab.profile
                    }
                    .font(.headline)
                }
            }.navigationBarTitle("Order History")
        }
    }
    
    struct OrdersInternalView: View {
        @ObservedObject private var orders: FirebaseCollection<Order>
        
        init(orders: FirebaseCollection<Order>) {
            self.orders = orders
        }
        
        var body: some View {
            List {
                ForEach(orders.items) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRow(order: order)
                    }
                }
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
