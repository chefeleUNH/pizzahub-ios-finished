//
//  CheckoutView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 4/14/20.
//  Copyright © 2020 Charles Hefele. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct CheckoutView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var cart: ShoppingCart
    @EnvironmentObject var session: FirebaseSession
    @Environment(\.presentationMode) var mode

    @State private var showingPaymentAlert = false
    
    var body: some View {
        VStack {
            if cart.items.isEmpty {
                Text("The shopping cart is empty")
                    .font(.largeTitle)
            } else {
                Text("TOTAL: $\(cart.total, specifier: "%.2f")")
                    .font(.largeTitle)
            }
            Button("Confirm order") {
                confirmOrder()
            }.font(.headline)
            .padding()
            .disabled(cart.items.isEmpty)
        }
        .onAppear(perform: dismissIfNotSignedIn)
        .navigationBarTitle("Checkout")
        .alert(isPresented: $showingPaymentAlert) {
            Alert(title: Text("Order confirmed"), message: Text("Your total was $\(cart.total, specifier: "%.2f") - thank you!"), dismissButton: .default(Text("OK")) {
                self.cart.reset()
                })
        }
    }
    
    func dismissIfNotSignedIn() {
        if (!session.isSignedIn) {
            self.mode.wrappedValue.dismiss()
        }
    }
    
    func confirmOrder() {
        // toggle the payment alert
        self.showingPaymentAlert.toggle()
        
        // null check the pizzeria
        guard let pizzeria = self.cart.pizzeria else {
            return
        }
        
        // define the data
        let data = ["timestamp": Timestamp(),
                    "pizzeria": pizzeria.name,
                    "items": self.cart.items.map({ $0.name }),
                    "total": String(format: "%.2f", cart.total),
                    "logo": pizzeria.logo,
                    "user_id": session.user?.uid ?? "nil"]
            as [String : Any]
        
        // post it to Firebase as a new document
        var ref: DocumentReference? = nil
        ref = ordersCollectionRef.addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        // show pizza ready notification to the user
        let content = UNMutableNotificationContent()
        content.title = "Pizza order ready!"
        content.subtitle = "Your order from \(pizzeria.name) is ready for pickup."
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static let cart = ShoppingCart()
    
    static var previews: some View {
        CheckoutView().environmentObject(cart)
    }
}
