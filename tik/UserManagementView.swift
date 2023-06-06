//
//  UserManagementView.swift
//  tik
//
//  Created by Antonio on 2023-06-05.
//

import SwiftUI

struct UserManagementView: View {
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Settings")
                Spacer()
            }
            if let isAdmin = firestoreManagerViewModel.isCurrentUserAdmin {
                if isAdmin {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Current user has the power!")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Remove Member")
                            Spacer()
                        }
                    }
                }
            }
            
        }
        .onAppear {
            firestoreManagerViewModel.adminCheck()
        }
    }
}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        UserManagementView()
    }
}
