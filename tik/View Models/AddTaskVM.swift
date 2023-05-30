//
//  AddTaskVM.swift
//  tik
//
//  Created by Tobias Sörensson on 2023-05-20.
//

//import Foundation
//import Firebase
//import FirebaseAuth
//
//class AddTaskVM: ObservableObject {
////    let auth = Auth.auth()
//    let db = Firestore.firestore()
//    let user : User?
//    var household : Household?
//    var householdRef = "Test_households"
//    
//    
//    init(user: User, household: Household) {
//        self.user = user
//        self.household = household
//    }
//    
//    func saveToFirestore(task: Task) {
//        // This is preliminary. Saves to the user - should save to the Household.
//        //guard let user = authViewModel.auth.currentUser else {return}
//        guard let household = household, let docID = household.docId else {return}
//        let taskRef = db.collection(householdRef).document(docID).collection("tasks")
//        
//        do {
//            try taskRef.addDocument(from: task)
//        } catch {
//            print("Error saving to db.\(error)")
//        }
//    }
//}
