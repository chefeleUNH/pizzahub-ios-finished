//
//  AuthView.swift
//  AuthenticationTutorial
//
//  Created by Charles Hefele on 1/9/21.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        NavigationView {
            SignInView()
        }
    }
}

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                           startPoint: .leading,
                           endPoint: .trailing)
                .mask(Text("PizzaHub")
                        .font(.system(size: 60, weight: .heavy)))
            
            Image("Pizza")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack(spacing: 18) {
                TextField("Email address", text: $email)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.primary, lineWidth: 2))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.primary, lineWidth: 2))
            }
            .padding(.vertical, 16)
            
            Button(action: signIn) {
                Text("Sign in")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint:  .leading, endPoint: .trailing))
                    .cornerRadius(5)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("I'm a new user.")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.primary)
                    
                    Text("Create an account")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                           startPoint: .leading,
                           endPoint: .trailing)
                .mask(Text("Create Account")
                        .font(.system(size: 40, weight: .heavy)))
            
            Text("Sign up to get started")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.primary)
            
            VStack(spacing: 18) {
                TextField("Email address", text: $email)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.primary, lineWidth: 2))
                
                SecureField("Password", text: $password)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.primary, lineWidth: 2))
            }
            .padding(.vertical, 16)
            
            Button(action: signUp) {
                Text("Create Account")
                    .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 50)
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(5)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
        }.padding(.horizontal, 32)
    }
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(FirebaseSession())
    }
}
