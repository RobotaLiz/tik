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
    var members : [User] = []
    var tasks : [Task] = []
    
    init(name: String, pinNum: String) {
        self.name = name
        self.pinNum = pinNum
    }
    
}
