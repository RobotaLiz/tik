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

class FirestoreManagerVM : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    @Published var  toast: Toast? = nil
    
    let userCollRef = "Test_users"
    let householdCollRef = "Test_households"
    
    
    @Published var currentTikUser: User?
    @Published var currentHousehold: Household?
    @Published var tasks: [Task] = []
    @Published var shoppingItems: [ShoppingItemModel] = []
    
    /*
     Takes household name and pin as arguments.
     Adds a new Household to Firestore with currentTikUser as member and admin.
     Checks in the user, by calling checkInHousehold with docID from the newly created Household.
     */
    func addHousehold(name: String, pin: String) {
        
        guard let currentTikUser = currentTikUser else { return }
        guard let userId = currentTikUser.docId else {return}
        
        let householdRef = db.collection(householdCollRef).document()
        let docID = householdRef.documentID
        
        let newMember = Member(userID: userId, admin: true)
        let newHousehold = Household(name: name, pin: pin, members: [newMember])
        
        
        do {
            print("Adding household \(name) to Firestore")
            try householdRef.setData(from: newHousehold) { error in
                if let error = error {
                    print("Error saving household to database: \(error.localizedDescription)")
                } else {
                    print("Household created successfully.")
                    self.checkInHousehold(docID: docID)
                }
            }
        } catch {
            print("Error saving to database: \(error.localizedDescription)")
        }
    }
    
    
    /*
     Takes a pin number and completion handler as arguments. Returns the Household(s) with matching pins.
     */
    func getHouseholds(pin: String, completion: @escaping ([Household]?, Error?) -> Void) {
        
        // Create a reference to the "Households" collection
        let searchRef = db.collection(householdCollRef)
        
        // Query documents where "pin" field matches the specified pin
        let query = searchRef.whereField("pin", isEqualTo: pin)
        
        // Perform the query
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error searching Firestore: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                let noResultsError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No households found"])
                print(noResultsError.localizedDescription)
                completion([], noResultsError)
                return
            }
            
            var households: [Household] = []
            
            for document in snapshot.documents {
                if let household = try? document.data(as: Household.self) {
                    households.append(household)
                }
            }
            
            completion(households, nil)
        }
    }
    
    
    func joinHousehold(household: Household) {
        
        guard let currentTikUser = currentTikUser else { return }
        guard let userID = currentTikUser.docId else {return}
        guard let householdID = household.docId else {return}
        
        let householdRef = db.collection(householdCollRef).document(householdID)
        
        //Let's check if the newMember already is enrolled in the houseHold
        for member in household.members {
            if member.userID == userID {
                print("Already joined!")
                self.checkInHousehold(docID: householdID)
                return
            }
        }
        
        let newMember = Member(userID: userID, admin: false)
        
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
        // Logged in check:
        if self.auth.currentUser != nil {
            // Let's remove any old household, if we should encounter any error.
            self.currentHousehold = nil
            let docRef = self.db.collection(self.householdCollRef).document(docID)
            
            docRef.getDocument(as: Household.self) { result in
                
                switch result {
                case .success(let household) : self.currentHousehold = household
                    // Here we call updateLatestHousehold
                    if let docID = household.docId {
                        self.updateLatestHousehold(householdID: docID)
                        self.addTasksSnapshotListener()
                    }
                    
                case .failure(let error) : print("Error getting household \(error)")
                }
            }
        }
    }
    
    
    func addTasksSnapshotListener() {
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let taskRef = self.db.collection(self.householdCollRef).document(docID).collection("tasks")
        
        taskRef.addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tasks.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let task = try? document.data(as: Task.self) {
                        self.tasks.append(task)
                    }
                }
                print("OHOJ: \(self.tasks)")
            }
        }
    }
    
    
    func checkOutHousehold() {
        currentHousehold = nil
    }
    
    
    func checkInLatestHousehold() {
        // Not done! Error!
        if let currentTikUser = currentTikUser, let docId = currentTikUser.latestHousehold{
            checkInHousehold(docID: docId)
        }
    }
    
    
    func updateLatestHousehold(householdID: String) {
        if let currentTikUser = currentTikUser, let docID = currentTikUser.docId {
            let userRef = self.db.collection(self.userCollRef).document(docID)
            
            userRef.updateData(["latestHousehold" : householdID]) { err in
                if let err = err {
                    print("Error updating latestHousehold: \(err)")
                } else {
                    print("LatestHousehold successfully updated")
                }
            }
        }
    }
    
    
    func generatePin() -> String {
        let lowest = 000_000
        let highest = 999_999
        let pin = Int.random(in: lowest...highest)
        return String(format: "%06d", pin)
    }
    
    
    func addAccount(name: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user, error == nil else {
                self.toast = Toast(style: .error, message: "could not create account")
                return
            }
            
            let newUser = User(name: name, email: email)
            let newUserRef = self.db.collection(self.userCollRef).document(user.uid)
            
            // This is weird. Why not save the User? Oh, I get it now. Complicated!
            if let name = newUser.name, let email = newUser.email {
                newUserRef.setData([
                    "name": name,
                    "email": email,
                    //                    "isMember": newUser.isMember,
                    //                    "isAdmin": newUser.isAdmin
                ]) { error in
                    if let error = error {
                        self.toast = Toast(style: .error, message: "could not create account")
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
                self.toast = Toast(style: .warning, message:"Wrong Email or PassWord")
            } else {
                print("Success")
                // If we successfully logged in, we need to get the currentTikUser from Firestore too
                self.getCurrentTikUser()
            }
        }
    }
    
    
    func getCurrentTikUser() {
        if let currentUser = self.auth.currentUser {
            // Let's remove any old logged in user, if we should encounter any error.
            self.currentTikUser = nil
            let docRef = self.db.collection(self.userCollRef).document(currentUser.uid)
            
            docRef.getDocument(as: User.self) { result in
                
                switch result {
                case .success(let user) :
                    self.currentTikUser = user
                    // Here we should try to get the User's latestHousehold somehow.
                    self.checkInLatestHousehold()
                    
                case .failure(let error) : print("Error getting user \(error)")
                }
            }
        }
    }
    
    
    func signOut() {
        do {
            try auth.signOut()
            self.currentTikUser = nil
            self.currentHousehold = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func saveTaskToFirestore(task: Task) {
        // This is preliminary. Saves to the user - should save to the Household.
        //guard let user = authViewModel.auth.currentUser else {return}
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let taskRef = db.collection(householdCollRef).document(docID).collection("tasks")
        
        do {
            try taskRef.addDocument(from: task)
        } catch {
            print("Error saving to db.\(error)")
        }
    }
    
    
    func removeTaskFromFirestore(task: Task) {
        // To do
    }
    func saveShoppingItem (shoppingItem : ShoppingItemModel) {
        
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let Shoppref = db.collection(householdCollRef).document(docID).collection("shoppingItems")
        
        do {
            try Shoppref.addDocument(from: shoppingItem)
        } catch {
            print("Error saving to db.\(error)")
        }
        
    }
    func deletShoppItem (shoppingItem : ShoppingItemModel) {
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let shopRef = self.db.collection(self.householdCollRef).document(docID).collection("shoppingItems")
        
        shopRef.document(shoppingItem.docId ?? "").delete() { err in
            if let err = err {
                print("Error removing shoppingItem")
            }else{
                print("removing successfully")
            }
            
        }
    }
    func addShoppingItemsSnapshotListener() {
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let shopRef = self.db.collection(self.householdCollRef).document(docID).collection("shoppingItems")
        
        shopRef.addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.shoppingItems.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let shoppingItem = try? document.data(as: ShoppingItemModel.self) {
                        self.shoppingItems.append(shoppingItem)
                    }
                }
                
            }
        }
    }
}

