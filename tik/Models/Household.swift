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
    var pin : String
    // Changed this! (from [User])
    var members : [User]
    //var tasks : [Task] = [] //Added as sub collection instead
    var admin : String? // String representing admin's user id
    
    //    init(name: String, pinNum: String) {
    //        self.name = name
    //        self.pin = pinNum
    //    }
    
}
