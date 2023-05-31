//
//  AddTaskVM.swift
//  tik
//
//  Created by Tobias Sörensson on 2023-05-20.
//

import Foundation
import Firebase
import FirebaseAuth

class AddTaskVM: ObservableObject {
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    func saveToFirestore(task: Task) {
        // This is preliminary. Saves to the user - should save to the Household.
        guard let user = auth.currentUser else {return}
        
        let taskRef = db.collection("users").document(user.uid).collection("tasks")
        
        do {
            try taskRef.addDocument(from: task)
        } catch {
            print("Error saving to db.\(error)")
        }
    }
}
