//
//  Member.swift
//  tik
//
//  Created by Tobias Sörensson on 2023-05-26.
//

import Foundation

struct Member : Codable, Equatable, Hashable {
    var userID : String
    var admin : Bool
}
