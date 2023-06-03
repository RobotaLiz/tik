//
//  ShoppingItemModel.swift
//  tik
//
//  Created by Liza Hjortling on 2023-05-28.
//

import Foundation
import FirebaseFirestoreSwift

struct ShoppingItemModel : Identifiable,Equatable,Codable {
    @DocumentID var docId : String?
    var id = UUID()
    
    var name : String
    var household : String
    
}
