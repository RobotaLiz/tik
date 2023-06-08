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
            .overlay(RoundedRectangle(cornerRadius: 20)
                .frame(height: 2)
            .padding(.top, 35)
            )
            .foregroundColor(.yellow)
            .padding(10)
            
        
//            .shadow(color: .purple, radius: 10)
//            .font(.title3)
    }
    
}
