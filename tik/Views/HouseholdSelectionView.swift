//
//  HouseholdSelectionView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct HouseholdSelectionView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    //@ObservedObject var householdViewModel : JoinHouseViewModel
    @State var createHouseholdViewPresented = false
    @State var joinHouseholdViewPresented = false
    
    var body: some View {
        VStack {
            
            if let uid = authViewModel.auth.currentUser?.uid {
                
                Text("Firestore UID: \(uid)")
            } else {
                Text("UID: N/A")
            }
            
            if let currentTikUser = authViewModel.currentTikUser {
                HStack {
                    if let email = currentTikUser.email {
                        Text("Tik user: \(email)")
                    }
                    if let docID = currentTikUser.docId {
                        Text(("ID: \(docID)"))
                    }
                }
            }
            
            if let currentHousehold = authViewModel.currentHousehold {
                HStack {
                    Text("Household: \(currentHousehold.name), Pin: \(currentHousehold.pin)")
                    if let docID = currentHousehold.docId {
                        Text("ID: \(docID)")
                    }
                }
            }
            
            HStack {
                Spacer()
                Text("In order to use this app, you need to be a member of a household.")
                    .padding(40)
                Spacer()
            }
            Button(action: {
                createHouseholdViewPresented.toggle()
            }) {
                Text("Create")
            }
            .padding(30)
            .buttonStyle(.borderedProminent)
            Button(action: {
                joinHouseholdViewPresented.toggle()
            }) {
                Text("Join")
            }
            .buttonStyle(.borderedProminent)

        }
        .sheet(isPresented: $createHouseholdViewPresented) {
            CreateHouseholdView(authViewModel: authViewModel)
        }
        .sheet(isPresented: $joinHouseholdViewPresented) {
            JoinHouseholdView(authViewModel: authViewModel)
        }
    }
}

struct HouseholdSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let authVM = AuthViewModel()
        HouseholdSelectionView(authViewModel: authVM)
    }
}
