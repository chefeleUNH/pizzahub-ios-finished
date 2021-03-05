//
//  MenuItemDetailView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/14/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MenuItemDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var session: FirebaseSession
    @State private var imageURL = URL(string: "")
    @EnvironmentObject var cart: ShoppingCart
    @ObservedObject var menuItem: MenuItem
    @ObservedObject var pizzeria: Pizzeria
    @State private var showingCartAlert = false
    
    var body: some View {
        VStack {
            WebImage(url: imageURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(menuItem.name)
                .font(.largeTitle)
                .padding()
            if (session.isSignedIn) {
                Button("Add to cart") {
                    self.addToCart()
                }.font(.headline)
            } else {
                Button("Sign in to add items to the cart") {
                    appState.selectedTab = Tab.profile
                }.font(.headline)
            }
            Spacer()
        }
        .onAppear(perform: loadImageFromFirebase)
        .navigationBarTitle(Text(menuItem.name), displayMode: .inline)
        .alert(isPresented: $showingCartAlert) {
            Alert(title: Text("Invalid Request"), message: Text("The item you are trying to add to the shopping cart is from a different pizzeria. Only one pizzeria is allowed in the shopping cart at a time."), dismissButton: .default(Text("OK")))
        }
    }
    
    func loadImageFromFirebase() {
        let storage = Storage.storage().reference(withPath: menuItem.photo)
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!
        }
    }
    
    func addToCart() {
        do {
            try self.cart.add(item: self.menuItem, pizzeria: self.pizzeria)
        } catch ShoppingCartError.menuItemDoesNotMatchPizzeria {
            print("menu item doesn't match pizzeria")
            showingCartAlert.toggle()
        } catch {
            print("failed for another reason")
        }
    }
}

struct MenuItemDetailView_Previews: PreviewProvider {
    static let cart = ShoppingCart()
    
    static var previews: some View {
        MenuItemDetailView(menuItem: MenuItem.example, pizzeria: Pizzeria.example).environmentObject(cart)
    }
}
