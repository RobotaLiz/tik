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
    let userRef = "Test_users"
    
    @Published var currentTikUser: User?
    
    
    func addAccount(name: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user, error == nil else {
                print("Error creating user: \(error?.localizedDescription ?? "")")
                return
            }

            let newUser = User(name: name, email: email)
            let usersRef = self.db.collection(self.userRef).document(user.uid)

            if let name = newUser.name, let email = newUser.email {
                usersRef.setData([
                    "name": name,
                    "email": email,
//                    "isMember": newUser.isMember,
//                    "isAdmin": newUser.isAdmin
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
    
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("Success")
                // Let's try using this
                if let currentUser = self.auth.currentUser {
                    // Let's remove any old logged in user, if we encounter any error
                    self.currentTikUser = nil
                    let docRef = self.db.collection(self.userRef).document(currentUser.uid)

                    docRef.getDocument(as: User.self) { result in
                        
                        switch result {
                            case .success(let user) : self.currentTikUser = user
                            case .failure(let error) : print("Error getting user \(error)")
                        }
//                        guard let result = result else {return}
//                        if error != nil {
//                            print("Error getting user")
//                        } else {
//                            do {
//                                self.currentTikUser = try result
//                            } catch {
//                                print("Error")
//                            }
//                        }
                    }
                }
            }
        }
    }
    
    
    func signOut() {
        do {
            try auth.signOut()
            self.currentTikUser = nil
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
    
//    func signIn(email: String, password: String) {
        
//    }
//
//    func addAccount(name: String, email: String, password: String) {
//        // Seems alright
       
//    }
//
//
//    // Do we need this here?
//    func adminCheck(completion: @escaping (Bool) -> Void) {
//        guard let currentUserUID = auth.currentUser?.uid else {
//            completion(false)
//            return
//        }
//
//        let userRef = db.collection("Users").document(currentUserUID)
//
//        userRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let isAdmin = document.data()?["isAdmin"] as? Bool ?? false
//                completion(isAdmin)
//            } else {
//                completion(false)
//            }
//        }
//    }
//
//    func signOut() {
        
//    }
//
//
//    // Do we need this?
//    func checkLoggedInStatus() {
//        let user = auth.currentUser
//        if user != nil {
//            //self.loggedIn = true
//        }
//    }
//}
