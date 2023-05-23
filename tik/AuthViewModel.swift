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
}
