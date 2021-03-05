//
//  SessionStore.swift
//  AuthenticationTutorial
//
//  Created by Charles Hefele on 1/9/21.
//

import FirebaseAuth
import Combine

class FirebaseSession: ObservableObject {
    var didChange = PassthroughSubject<FirebaseSession, Never>()
    @Published var user: User? {didSet {self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    var isSignedIn: Bool {
        return user != nil
    }
    
    init() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.user = User(uid: user.uid, email: user.email)
            } else {
                self.user = nil
            }
        })
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}

struct User {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
