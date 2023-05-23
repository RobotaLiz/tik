//
//  SidebarView.swift
//  tik
//
//  Created by Antonio on 2023-05-22.
//

import SwiftUI
import FirebaseAuth

struct SidebarView: View {
    @Binding var isSidebarOpen : Bool
    @State var isAdmin = false
    @StateObject var authVM = AuthViewModel()
        
    var body: some View {
        VStack {
            Text("User Settings").dynamicTypeSize(.accessibility3)
            Text("Stats").dynamicTypeSize(.accessibility1)
            if isAdmin {
                Text("Admin Panel").dynamicTypeSize(.accessibility3)
            }

        }
        .onAppear {
            authVM.adminCheck { isAdmin in
                self.isAdmin = isAdmin
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var isSidebarOpen = true
        SidebarView(isSidebarOpen: $isSidebarOpen)
    }
}
