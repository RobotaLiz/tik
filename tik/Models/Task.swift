//
//  Task.swift
//  tik
//
//  Created by Antonio on 2023-05-15.
//

import Foundation
import FirebaseFirestoreSwift

struct Task : Identifiable, Codable {
    
    @DocumentID var id : String?
    //var id = UUID() //Do we need this? Couldn't we rename docId to id instead?
    var title : String
    var notes : String?
    var location : String?
    var assignedTo : [User] = []
    var isCompleted : Bool = false
    var dateAdded : Date = Date()
    var setDate: Date
    var completedDates : [Date] = []
    
    
}
