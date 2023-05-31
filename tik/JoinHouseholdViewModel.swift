////
////  JoinHouseholdViewModel.swift
////  tik
////
////  Created by Antonio on 2023-05-18.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestore
//
//class JoinHouseViewModel : ObservableObject {
//    
//    @Published var currentHousehold : Household?
//    @Published var currentUser : User?
//    let db = Firestore.firestore()
//    let auth = Auth.auth()
//    
//    init() {
//        //self.currentHousehold = currentHousehold
//        //self.currentUser = currentUser
//        getCurrentUser()
//    }
//    
//    func printCurrentUser() {
//        print(currentUser as Any)
//    }
//    
//    // ?
//    func userListener() {
//        guard auth.currentUser != nil else {return}
//        let usersRef = db.collection("Users")
//        
//        usersRef.addSnapshotListener() { snapshot, error in
//            guard let snapshot = snapshot else {return}
//            if let error = error {
//                print("Error listening to database: \(error)")
//            } else {
//                for document in snapshot.documents {
//                    do {
//                        let user = try document.data(as: User.self)
//                        self.currentUser = user
//                    } catch {
//                        print("Error getting docs")
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func getCurrentUser() {
//        guard let currentUserUID = auth.currentUser?.uid else {
//            self.currentUser = nil
//            return
//        }
//        
//        let usersRef = db.collection("Users")
//        let currentUserRef = usersRef.document(currentUserUID)
//        
//        currentUserRef.getDocument { [weak self] (document, error) in
//            if let error = error {
//                print("Error getting current user from Firestore: \(error.localizedDescription)")
//                self?.currentUser = nil
//                return
//            }
//            
//            if let document = document, document.exists {
//                do {
//                    let user = try document.data(as: User.self)
//                    self?.currentUser = user
//                } catch {
//                    print("Error converting document to User object: \(error)")
//                    self?.currentUser = nil
//                }
//            } else {
//                print("Document does not exist")
//                self?.currentUser = nil
//            }
//        }
//    }
//    
//    // Appends current user to household member list
//    func addCurrentUserToHousehold(householdId: String) {
//        guard let currentUser = currentUser else {return}
//        let householdRef = db.collection("Households").document(householdId)
//        
//        //var updatedHousehold = Household(name: household.name, pinNum: household.pinNum)
//        //updatedHousehold.members.append(currentUser)
//                
//        /*do {
//            try householdRef.setData(from: updatedHousehold)
//        } catch {
//            print("Error updating household: \(error.localizedDescription)")
//        }*/
//        
//        /*let data: [String: Any] = [
//            "members": updatedHousehold.members
//        ]
//        
//        print("Members: \(updatedHousehold.members)")*/
//        
//        /*householdRef.updateData(data) { error in
//            print("Updating firestore data")
//            if let error = error {
//                print("Error updating household: \(error.localizedDescription)")
//            } else {
//                print("Current user added to household")
//            }
//        }*/
//        
//        let currentUserData: [String: Any] = [
//            "docId": auth.currentUser!.uid,
//            "name": currentUser.name!,
//            "email": currentUser.email!,
//            "isMember": true,
//            "isAdmin": false
//        ]
//        
//        
//        householdRef.updateData([
//            "members": FieldValue.arrayUnion([currentUserData])
//        ]) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document updated successfully")
//            }
//        }
//
//    }
//    
//    // Search collection for households matching inputted PIN
//    func searchFirebase(inputText: String, completion: @escaping ([DocumentSnapshot]?, Error?) -> Void) {
//        let householdRef = db.collection("Households")
//        
//        householdRef.whereField("pinNum", isEqualTo: inputText).getDocuments { (querySnapshot, error) in
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
//    
//    func householdFirestoreListener() {
//        guard auth.currentUser != nil else {return}
//        let householdRef = db.collection("Households")
//        
//        householdRef.addSnapshotListener() { snapshot, error in
//            guard let snapshot = snapshot else {return}
//            if let error = error {
//                print("Error listening to database: \(error)")
//            } else {
//                for document in snapshot.documents {
//                    do {
//                        let household = try document.data(as: Household.self)
//                        self.currentHousehold = household
//                    } catch {
//                        print("Error getting docs")
//                    }
//                }
//            }
//        }
//    }
//    
//    func makeCurrentUserMember() {
//        guard let currentUserUID = auth.currentUser?.uid else {
//            self.currentUser = nil
//            return
//        }
//        
//        let currentUserRef = db.collection("Users").document(currentUserUID)
//        
//        currentUserRef.updateData(["isMember" : true]) { error in
//            if let error = error {
//                print("Cannot make current user a member: \(error.localizedDescription)")
//            } else {
//                print("User \(String(describing: self.currentUser?.name)) has joined the house!")
//            }
//        }
//    }
//    
////    func createHousehold(name: String, pinCode: String) {
////        guard let currentUser = currentUser else { return }
////        let householdRef = db.collection("Households")
////
////
////        var household = Household(name: name, pinNum: pinCode)
////
////        //household.members.append(currentUser)
////
////        do {
////            print("Adding household \(name) to Firestore")
////            try householdRef.addDocument(from: household) { [weak self] error in
////                if let error = error {
////                    print("Error saving household to database: \(error.localizedDescription)")
////                } else {
////                    print("Household created successfully.")
////                    if let docId = household.docId {
////                        self?.addCurrentUserToHousehold(householdId: docId)
////                    }
////                }
////            }
////        } catch {
////            print("Error saving to database: \(error.localizedDescription)")
////        }
////
////    }
//    
//    func generatePin() -> String {
//        let lowest = 100_000
//        let highest = 999_999
//        let pin = Int.random(in: lowest...highest)
//        return String(pin)
//    }
//}
