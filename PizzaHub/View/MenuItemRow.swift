//
//  MenuItemRow.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/7/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MenuItemRow: View {
    @State private var imageURL = URL(string: "")
    @ObservedObject var menuItem: MenuItem
    
    var body: some View {
        HStack {
            WebImage(url: imageURL)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            Text(menuItem.name)
            Spacer()
            Text("$\(menuItem.price)")
        }.onAppear(perform: loadImageFromFirebase)
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
}

struct MenuItemRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemRow(menuItem: MenuItem.example)
    }
}
