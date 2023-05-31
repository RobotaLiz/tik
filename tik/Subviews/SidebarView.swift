//
//  SidebarView.swift
//  tik
//
//  Created by Antonio on 2023-05-22.
//  TODO: not usable right now

import SwiftUI
import FirebaseAuth

struct SidebarView: View {
    @Binding var isSidebarOpen : Bool
    @State var isAdmin = false
    @ObservedObject var authViewModel : FirestoreManagerVM
    
    var body: some View {
        VStack {
            Text("User Settings").dynamicTypeSize(.accessibility3)
            Text("Stats").dynamicTypeSize(.accessibility1)
            if isAdmin {
                Text("Admin Panel").dynamicTypeSize(.accessibility3)
            }
            Button("Log out") {
                authViewModel.signOut()
            }
            Button("Sign out household") {
                authViewModel.checkOutHousehold()
            }

        }
//        .onAppear {
//            authViewModel.adminCheck { isAdmin in
//                self.isAdmin = isAdmin
//            }
//        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isSidebarOpen = true
        let authViewModel = FirestoreManagerVM()
        SidebarView(isSidebarOpen: $isSidebarOpen, authViewModel: authViewModel)
    }
}
