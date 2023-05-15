//
//  Household.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct Household {
    
    @DocumentID var docId : String?
    var members : [User] = []
    var tasks : [Task] = []
    
}
