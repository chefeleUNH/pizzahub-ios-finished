//
//  PizzeriaDetailView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 3/14/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI

struct PizzeriaDetailView: View {
    @State private var imageURL = URL(string: "")
    @ObservedObject private var pizzeria: Pizzeria
    @ObservedObject private var menu: FirebaseCollection<MenuItem>
    private var menuQuery: Query
    
    init(pizzeria: Pizzeria) {
        self.pizzeria = pizzeria
        self.menuQuery = pizzeriasCollectionRef.document(pizzeria.id).collection("menu").order(by: "name")
        self.menu = FirebaseCollection<MenuItem>(query: menuQuery)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(pizzeria.city)
                Text(pizzeria.state)
                Spacer()
            }
            WebImage(url: imageURL)
                .resizable()
                .frame(width: 188, height: 150)
                .cornerRadius(38)
            Text("Menu")
                .font(.largeTitle)
            List {
                ForEach(menu.items) { menuItem in
                    NavigationLink(destination: MenuItemDetailView(menuItem: menuItem, pizzeria: self.pizzeria)) {
                        MenuItemRow(menuItem: menuItem)
                    }
                }
            }
            Spacer()
        }
        .onAppear(perform: loadImageFromFirebase)
        .padding()
        .navigationBarTitle(pizzeria.name)
    }
    
    func loadImageFromFirebase() {
        let storage = Storage.storage().reference(withPath: pizzeria.logo)
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!
        }
    }
}

struct PizzeriaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PizzeriaDetailView(pizzeria: Pizzeria.example)
    }
}
