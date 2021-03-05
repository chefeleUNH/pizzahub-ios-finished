//
//  OrderDetailView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/23/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct OrderDetailView: View {
    @State private var imageURL = URL(string: "")
    @ObservedObject var order: Order
    private let dateFormatter: DateFormatter
    
    init(order: Order) {
        self.order = order
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: imageURL)
                .resizable()
                .frame(width: 188, height: 150)
                .cornerRadius(38)
            Divider()
            Text("Ordered from: \(order.pizzeria)")
                .font(.headline)
            Text("Ordered on: \(dateFormatter.string(from: order.timestamp.dateValue()))")
                .font(.headline)
            Text("Order total: $\(order.total)")
                .font(.headline)
            Divider()
            Text("Items Ordered")
                .font(.largeTitle)
            List {
                ForEach(order.items, id: \.self) { item in
                    Text(item)
                }
            }
            Spacer()
        }
        .onAppear(perform: loadImageFromFirebase)
        .padding()
        .navigationBarTitle("Order Details")
        .listStyle(GroupedListStyle())
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

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order.example)
    }
}
