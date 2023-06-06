//
//  TextFieldStyles.swift
//  tik
//
//  Created by Antonio on 2023-05-23.
//

import Foundation
import SwiftUI

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.black)
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color.yellow, lineWidth: 2))
    }
}

