//
//  ShoppingItemModel.swift
//  tik
//
//  Created by Liza Hjortling on 2023-05-28.
//

import Foundation

struct ShoppingItemModel : Identifiable,Equatable {
    var id = UUID()
    
    var name : String
    var household : String
    
}
