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
    
    let userCollRef = "Users"
    let householdCollRef = "Households"
    let taskCollRef = "tasks"
    
    
    @Published var currentTikUser: User?
    @Published var currentHousehold: Household?
    @Published var tasks: [Task] = []
    @Published var members: [User] = []
    @Published var shoppingItems: [ShoppingItemModel] = []
    @Published var isCurrentUserAdmin : Bool?
    
    init() {
        addTasksSnapshotListener()
    }
    
    func memberListener() {
        guard let currentHouseholdDocID = currentHousehold?.docId else {return}
        let householdRef = db.collection(self.householdCollRef).document(currentHouseholdDocID)
        let membersRef = householdRef.collection("members")
        
        membersRef.addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.members.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let member = try? document.data(as: User.self) {
                        self.members.append(member)
                    }
                }
                
            }
        }
        
        
    }
    
    func makeAdmin(userDocId: String) {
        guard let currentHouseholdDocID = currentHousehold?.docId else {return}
        let householdRef = db.collection(self.householdCollRef).document(currentHouseholdDocID)
        
        householdRef.updateData(["admin": userDocId]) { error in
            if let error = error {
                print("Error updating admin field: \(error.localizedDescription)")
            } else {
                print("Member with docId \(userDocId) is now an admin")
                self.isCurrentUserAdmin = false
            }
        }

    }
    
    func kick(userDocId: String) {
        guard let currentHouseholdDocID = currentHousehold?.docId else {return}
        let householdRef = db.collection(self.householdCollRef).document(currentHouseholdDocID)
        let memberRef = householdRef.collection("members").document(userDocId)
        
        print("Kicked member's docId: \(userDocId)")
        
        memberRef.delete { error in
            if let error = error {
                print("Error kicking member: \(error.localizedDescription)")
            } else {
                print("Member kicked successfully")
            }
        }
        
    }

    
    func printHouseholdMembers() {

        guard let currentMembers = currentHousehold?.members else {return}
        print("Current household members: ")
        for member in currentMembers {
            print(member.name ?? "xxx")
            print(member.docId ?? "dai")
        }
        
    }
    
    func adminCheck() {
        guard let currentHouseholdDocID = currentHousehold?.docId else {return}
        guard let currentTikUser = currentTikUser else { return }
        guard let userId = currentTikUser.docId else {return}
        
        // 1. Gets admin from household document on firestore
        let householdRef = db.collection(self.householdCollRef).document(currentHouseholdDocID)
        
        // 2. Error handling - backend
        
        householdRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching task document: \(error)")
                return
            }

            guard let document = document, document.exists else {
                print("Task document does not exist")
                return
            }
            
            // 3. Gets data and turns it into a variable
            let adminDocId = document.data()?["admin"] as? String ?? ""
            
            // 4. Checks if ids match and switches admin on
            if userId == adminDocId {
                self.isCurrentUserAdmin = true
            }
            
        }
  
    }
    
    /*
     Assigns and removes a user from a task
     */
    
    func toggleUserToTask(taskId: String, member: User) {
        
        guard let currentHouseholdDocID = currentHousehold?.docId else {return}
        
        let taskRef = db.collection(self.householdCollRef)
                        .document(currentHouseholdDocID)
                        .collection(self.taskCollRef)
                        .document(taskId)
        
        // Retrieves task document from firestore (with error handling)
        taskRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching task document: \(error)")
                return
            }

            guard let document = document, document.exists else {
                print("Task document does not exist")
                return
            }

            // Retrieves assignedTo
            var assignedTo = document.data()?["assignedTo"] as? [[String: Any]] ?? []
            
            // Converting User object (named "member") to dictionary using the User properties
            let memberDict: [String: Any] = [
                "docId": member.docId ?? "",
                "name": member.name ?? "",
                "email": member.email ?? "",
                "latestHousehold": member.latestHousehold ?? ""
            ]
            
            // If assignedTo contains a matching dict (index is found), that dict is removed.
            // Else, appends it to the array.
            
            if let index = assignedTo.firstIndex(where: { $0["docId"] as? String == member.docId }) {
                assignedTo.remove(at: index)
            } else {
                assignedTo.append(memberDict)
            }
            
            // Updates assignedTo in firestore doc
            taskRef.updateData([
                "assignedTo": assignedTo
            ]) { error in
                if let error = error {
                    print("Error updating task document: \(error)")
                } else {
                    print("Users added to task")
                }
            }

        }
    }
    
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
        
        let newMember = User(docId: userId, name: currentTikUser.name, email: currentTikUser.email)
        
        print("New Member docId: \(userId)")
        self.members.append(newMember)
        
        let newHousehold = Household(name: name, pin: pin, members: [newMember], admin: userId)
    
        do {
            print("Adding household \(name) to Firestore")
            try householdRef.setData(from: newHousehold) { error in
                if let error = error {
                    print("Error saving household to database: \(error.localizedDescription)")
                } else {
                    print("Household created successfully.")
                    //self.checkInHousehold(docID: docID)
                    
                    let membersCollectionRef = householdRef.collection("members")
                    
                    // Create a new member document in the subcollection
                    let newMemberDocumentRef = membersCollectionRef.document(userId)
                    do {
                        try newMemberDocumentRef.setData(from: newMember) { error in
                            if let error = error {
                                print("Error adding new member to subcollection: \(error.localizedDescription)")
                            } else {
                                print("New member added to subcollection successfully.")
                                self.checkInHousehold(docID: docID)
                            }
                        }
                    } catch {
                        print("Error saving new member to subcollection: \(error.localizedDescription)")
                    }
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
            if member.docId == userID {
                print("Already joined!")
                self.checkInHousehold(docID: householdID)
                return
            }
        }
        
        let newMember = User(docId: userID, name: currentTikUser.name, email: currentTikUser.email)
        
        self.members.append(newMember)
        
        let membersCollectionRef = householdRef.collection("members")
        let newMemberDocumentRef = membersCollectionRef.document(userID)

        do {
            try newMemberDocumentRef.setData(from: newMember) { [weak self] error in
                if let error = error {
                    print("Error adding new member to subcollection: \(error.localizedDescription)")
                } else {
                    print("New member added to subcollection successfully.")
                    self?.checkInHousehold(docID: householdID)
                }
            }
        } catch {
            print("Error saving new member to subcollection: \(error.localizedDescription)")
        }
        
        /*let newMemberData = try? Firestore.Encoder().encode(newMember)
        
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
        }*/
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
                        self.addShoppingItemsSnapshotListener()
                        self.memberListener()
                        self.adminCheck()
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
    
    
    func toggleTikBox(task: Task) {
        guard let taskRef = task.docId else {return}
        guard let householdRef = currentHousehold?.docId else {return}
        var isCompleted = task.isCompleted
        isCompleted = !isCompleted
        
        
        let completedRef = self.db.collection(self.householdCollRef).document(householdRef).collection("tasks").document(taskRef)
        
        completedRef.updateData(["isCompleted" : isCompleted]) { err in
            if let err = err {
                print("Error toggling isCompleted: \(err)")
            } else {
                print("isCompleted succesfully changed")
            }
        }
        
        
    }
    
    
    func checkOutHousehold() {
        currentHousehold = nil
    }
    
    
    func checkInLatestHousehold() {
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
        if password.count < 6 {
            self.toast = Toast(style: .error, message: "Password must contain at least six characters")
            return
        }
        auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user, error == nil else {
                self.toast = Toast(style: .error, message: "could not create account")
                return
            }
            
            let newUser = User(name: name, email: email)
            let newUserRef = self.db.collection(self.userCollRef).document(user.uid)
            
            // This is weird. Why not save the User? Oh, I get it now. Complicated!
            // WHyyy???! I just want to add a User!!!11!!!!!
            if let name = newUser.name, let email = newUser.email {
                newUserRef.setData([
                    "name": name,
                    "email": email,
                    "id": newUser.id.uuidString
                ]) { error in
                    if let error = error {
                        self.toast = Toast(style: .error, message: "could not create account \(error)")
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
                    // Now, let's get the latestHousehold too!
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
            self.isCurrentUserAdmin = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    func saveTaskToFirestore(task: Task) {
        guard let currentHousehold = self.currentHousehold, let docID = currentHousehold.docId else {return}
        let taskRef = db.collection(householdCollRef).document(docID).collection(taskCollRef)
        
        do {
            try taskRef.addDocument(from: task)
        } catch {
            print("Error saving to db.\(error)")
        }
    }
    
    
    func deleteTaskFromFirestore(index: Int) {
        let task = tasks[index]
        guard let currentHousehold = currentHousehold,
              let docID = currentHousehold.docId,
              let taskID = task.docId else {return}
        
        let taskToDeleteRef = db.collection(householdCollRef).document(docID).collection(taskCollRef).document(taskID)
        taskToDeleteRef.delete()
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

