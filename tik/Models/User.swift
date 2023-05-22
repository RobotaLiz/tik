//
//  User.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable {
    
    @DocumentID var docId : String?
    var name : String
    var email : String
    var isMember : Bool = false // Checks if user is member of household. If member, proceed to task list. If not a member, go to create or join household view.
    var isAdmin : Bool?
    
}
