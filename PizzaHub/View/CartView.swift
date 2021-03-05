//
//  CartView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/11/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        NavigationView {
            Group {
                if (session.isSignedIn) {
                    CartInternalView()
                } else {
                    Button("Sign in to use the cart") {
                        appState.selectedTab = Tab.profile
                    }
                    .font(.headline)
                }
            }
            .navigationBarTitle("Shopping Cart")
        }
    }
}

struct CartInternalView: View {
    @EnvironmentObject var cart: ShoppingCart

    var body: some View {
        List {
            Section {
                ForEach(cart.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price)")
                    }
                }.onDelete(perform: deleteItems)
            }

            Section {
                NavigationLink(destination: CheckoutView()) {
                    Text("Place Order")
                }
            }.disabled(cart.items.isEmpty)
        }
        .listStyle(GroupedListStyle())
        .navigationBarItems(trailing: EditButton())
    }
    
    func deleteItems(at offsets: IndexSet) {
        cart.remove(item: cart.items[offsets.first!])
    }
}

struct CartView_Previews: PreviewProvider {
    static let cart = ShoppingCart()
    
    static var previews: some View {
        CartView().environmentObject(cart)
    }
}
