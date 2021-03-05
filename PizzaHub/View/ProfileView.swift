//
//  ProfileView.swift
//  PizzaHub
//
//  Created by Charles Hefele on 1/12/21.
//  Copyright © 2021 Charles Hefele. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: FirebaseSession
    
    @ViewBuilder
    var body: some View {
        if (session.isSignedIn) {
            SignedInView()
        } else {
            AuthView()
        }
    }
}

struct SignedInView: View {
    @EnvironmentObject var session: FirebaseSession

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(session.user?.email ?? "Not signed in")
                }
                Section {
                    Button(action: session.signOut) {
                        Text("Sign Out")
                    }
                }
            }
            .navigationBarTitle("Profile")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
