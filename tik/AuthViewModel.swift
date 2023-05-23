//
//  AuthViewModel.swift
//  tik
//
//  Created by Antonio on 2023-05-23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

class AuthViewModel : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var loggedIn: Bool = false
    
    var didSignOut: (() -> Void)?
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("Success")
                self.loggedIn = true
            }
        }
    }
    
    func addAccount(name: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user, error == nil else {
                print("Error creating user: \(error?.localizedDescription ?? "")")
                return
            }
            
            let newUser = User(name: name, email: email)
            let usersRef = self.db.collection("Users").document(user.uid) 
            
            if let name = newUser.name, let email = newUser.email {
                usersRef.setData([
                    "name": name,
                    "email": email
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Document added with ID: \(usersRef.documentID)")
                    }
                }
            }
            
            self.signIn(email: email, password: password)
        }
    }
    
    func adminCheck(completion: @escaping (Bool) -> Void) {
        guard let currentUserUID = auth.currentUser?.uid else {
            completion(false)
            return
        }
        
        let userRef = db.collection("Users").document(currentUserUID)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let isAdmin = document.data()?["isAdmin"] as? Bool ?? false
                completion(isAdmin)
            } else {
                completion(false)
            }
        }
    }
    
    func signOut() {
        do {
          try auth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func checkLoggedInStatus() {
        let user = Auth.auth().currentUser
        if user != nil {
            self.loggedIn = true
        }
    }
}
