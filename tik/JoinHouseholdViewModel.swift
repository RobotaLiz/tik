//
//  JoinHouseholdViewModel.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import Foundation
import Firebase

class JoinHouseViewModel : ObservableObject {
    
    @Published var household : Household
    @Published var currentUser : User?
    let db = Firestore.firestore()
    let auth = Auth.auth()

    
    init(household : Household) {
        self.household = household
        self.currentUser = currentUser
        getCurrentUser()
    }
    
    func printCurrentUser() {
        print(currentUser as Any)
    }
    
    func getCurrentUser() {
        guard let currentUserUID = auth.currentUser?.uid else {
            self.currentUser = nil
            return
        }
        
        let usersRef = db.collection("Users")
        let currentUserRef = usersRef.document(currentUserUID)
        
        currentUserRef.getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error getting current user from Firestore: \(error.localizedDescription)")
                self?.currentUser = nil
                return
            }
            
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    self?.currentUser = user
                } catch {
                    print("Error converting document to User object: \(error)")
                    self?.currentUser = nil
                }
            } else {
                print("Document does not exist")
                self?.currentUser = nil
            }
        }
    }
    
    // Appends current user to household member list
    func addCurrentUserToHousehold(householdId: String) {
        let householdRef = db.collection("Households").document(householdId)
        var updatedHousehold = Household(name: household.name, pinNum: household.pinNum)
        
        updatedHousehold.members.append(currentUser!)
        
        do {
            try householdRef.setData(from: updatedHousehold)
        } catch {
            print("Error updating household: \(error.localizedDescription)")
        }
    }
    
    // Search collection for households matching inputted PIN
    func searchFirebase(inputText: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
        let householdRef = db.collection("Households")
        
        householdRef.whereField("pinNum", isEqualTo: inputText).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error searching Firestore: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No matching documents")
                completion(nil, nil)
                return
            }
            
            completion(documents, nil)
        }
    }
    
    func householdFirestoreListener() {
        guard auth.currentUser != nil else {return}
        let householdRef = db.collection("Households")
        
        householdRef.addSnapshotListener() { snapshot, error in
            guard let snapshot = snapshot else {return}
            if let error = error {
                print("Error listening to database: \(error)")
            } else {
                for document in snapshot.documents {
                    do {
                        let household = try document.data(as: Household.self)
                        self.household = household
                    } catch {
                        print("Error getting docs")
                    }
                }
            }
        }
    }
    
    func createHousehold(name: String) {
        guard auth.currentUser != nil else {return}
        let householdRef = db.collection("Households")
        let household = Household(name: name, pinNum: generatePin())
                
        do {
            print("Adding household \(name) to firebase")
            try householdRef.addDocument(from: household)
        } catch {
            print("Error saving to database")
        }
    }
    
    func generatePin() -> String {
        let lowest = 100_000
        let highest = 999_999
        let pin = Int.random(in: lowest...highest)
        return String(pin)
    }
}
