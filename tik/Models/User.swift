//
//  User.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct User {
    
    @DocumentID var docId : String?
    var name : String
    var email : String
    
}
