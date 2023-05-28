//
//  Household.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Household : Codable {
    
    @DocumentID var docId : String?
    var name : String
    var pinNum : String
    // Changed this! (from [User])
    var members : [Member] = []
    var tasks : [Task] = []
    var admin : User? // Only one user can be admin right now (more admins in the future?)
    
    init(name: String, pinNum: String) {
        self.name = name
        self.pinNum = pinNum
    }
    
}
