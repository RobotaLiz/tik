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
    let householdRef = "Test_households"
    
    
    @Published var currentTikUser: User?
    @Published var currentHousehold: Household?
    
    
    func addHousehold(name: String, pin: String) {
        
        guard let currentTikUser = currentTikUser else { return }
        guard let userId = currentTikUser.docId else {return}
        
        let householdRef = db.collection(householdRef)
        
        let newMember = Member(userID: userId, admin: true)
        let newHousehold = Household(name: name, pin: pin, members: [newMember])
        
        //household.members.append(currentUser)
        
        do {
            print("Adding household \(name) to Firestore")
            try householdRef.addDocument(from: newHousehold) { error in
                if let error = error {
                    print("Error saving household to database: \(error.localizedDescription)")
                } else {
                    print("Household created successfully.")
                }
            }
        } catch {
            print("Error saving to database: \(error.localizedDescription)")
        }
    }
    
    
    func getHouseholds(pin: String, completion: @escaping ([Household]?, Error?) -> Void) {
        
        // Create a reference to the "Households" collection
        let searchRef = db.collection(householdRef)
        
        // Query documents where "pin" field matches the specified pin
        let query = searchRef.whereField("pin", isEqualTo: pin)
        
        // Perform the query
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error searching Firestore: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            var households: [Household] = []
            
            // Parse each document into a Household object
            for document in snapshot?.documents ?? [] {
                if let household = try? document.data(as: Household.self) {
                    households.append(household)
                }
            }
            
            // Call the completion handler with the resulting households
            completion(households, nil)
        }
    }
    
    
//    func searchFirebase(inputText: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        let searchRef = db.collection(householdRef)
//
//        searchRef.whereField("pin", isEqualTo: inputText).getDocuments() { (querySnapshot, error) in
//            if let error = error {
//                print("Error searching Firestore: \(error.localizedDescription)")
//                completion(nil, error)
//                return
//            }
//
//            guard let documents = querySnapshot?.documents else {
//                print("No matching documents")
//                completion(nil, nil)
//                return
//            }
//
//            completion(documents, nil)
//        }
//    }
    
    
    func joinHousehold(household: Household) {
        
        guard let currentTikUser = currentTikUser else { return }
        guard let userId = currentTikUser.docId else {return}
        guard let householdID = household.docId else {return}
        
        let householdRef = db.collection(householdRef).document(householdID)
        
        let newMember = Member(userID: userId, admin: false)
        
        if household.members.contains(newMember) {
            print("Already joined!")
            // Lets check in anyway!
            self.checkInHousehold(docID: householdID)
            return
        }
        
        let newMemberData = try? Firestore.Encoder().encode(newMember)

        if let newMemberData = newMemberData {
            print("Adding member \(currentTikUser.name ?? "Anon") to Firestore")
            householdRef.updateData(["members" : FieldValue.arrayUnion([newMemberData])]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.checkInHousehold(docID: householdID)
                }
            }
        }
    }
        
        
        
        func checkInHousehold(docID: String) {
            if let currentUser = self.auth.currentUser {
                // Let's remove any old household, if we should encounter any error.
                self.currentHousehold = nil
                let docRef = self.db.collection(self.householdRef).document(docID)
                
                docRef.getDocument(as: Household.self) { result in
                    
                    switch result {
                    case .success(let household) : self.currentHousehold = household
                        // Here we should call updateLatestHousehold
                        
                    case .failure(let error) : print("Error getting household \(error)")
                    }
                }
            }
        }
        
        func checkOutHousehold() {
            currentHousehold = nil
        }
        
        
        func getLatestHousehold() {
            
        }
        
        
        func generatePin() -> String {
            return "000000"
        }
        
        
        func addAccount(name: String, email: String, password: String) {
            auth.createUser(withEmail: email, password: password) { (result, error) in
                guard let user = result?.user, error == nil else {
                    print("Error creating user: \(error?.localizedDescription ?? "")")
                    return
                }
                
                let newUser = User(name: name, email: email)
                let newUserRef = self.db.collection(self.userRef).document(user.uid)
                
                // This is weird. Why not save the User?
                if let name = newUser.name, let email = newUser.email {
                    newUserRef.setData([
                        "name": name,
                        "email": email,
                        //                    "isMember": newUser.isMember,
                        //                    "isAdmin": newUser.isAdmin
                    ]) { error in
                        if let error = error {
                            print("Error adding document: \(error.localizedDescription)")
                        } else {
                            print("Document added with ID: \(newUserRef.documentID)")
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
                    // If we successfully logged in, we need to get the currentTikUser from Firestore too
                    self.getCurrentTikUser()
                }
            }
        }
    
    
    func updateLatestHouseold(householdID: String) {
        // Should update currentUser on Firestore with the current household.
        
    }
        
        
        func getCurrentTikUser() {
            if let currentUser = self.auth.currentUser {
                // Let's remove any old logged in user, if we should encounter any error.
                self.currentTikUser = nil
                let docRef = self.db.collection(self.userRef).document(currentUser.uid)
                
                docRef.getDocument(as: User.self) { result in
                    
                    switch result {
                    case .success(let user) :
                        self.currentTikUser = user
                        // Here we should try to get the User's currentHousehold somehow.
                        
                    case .failure(let error) : print("Error getting user \(error)")
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
//
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
