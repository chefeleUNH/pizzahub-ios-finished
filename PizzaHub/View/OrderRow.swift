//
//  OrderRow.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/23/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct OrderRow: View {
    @State private var imageURL = URL(string: "")
    @ObservedObject var order: Order
    private let dateFormatter: DateFormatter
    
    init(order: Order) {
        self.order = order
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    var body: some View {
        HStack {
            WebImage(url: imageURL)
                .resizable()
                .frame(width: 63, height: 50)
                .cornerRadius(13)
            VStack(alignment: .leading) {
                Text(order.pizzeria).font(.headline)
                Text(dateFormatter.string(from: order.timestamp.dateValue()))
            }
            Spacer()
            Text("$\(order.total)")
        }.onAppear(perform: loadImageFromFirebase)
    }
    
    func loadImageFromFirebase() {
        let storage = Storage.storage().reference(withPath: order.logo)
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            self.imageURL = url!
        }
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: Order.example)
    }
}
