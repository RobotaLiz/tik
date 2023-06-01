//
//  HouseholdSelectionView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct HouseholdSelectionView: View {
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    @State var createHouseholdViewPresented = false
    @State var joinHouseholdViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let uid = firestoreManagerViewModel.auth.currentUser?.uid {
                    
                    Text("Firestore UID: \(uid)")
                } else {
                    Text("UID: N/A")
                }
                
                if let currentTikUser = firestoreManagerViewModel.currentTikUser {
                    HStack {
                        if let email = currentTikUser.email {
                            Text("Tik user: \(email)")
                        }
                        if let docID = currentTikUser.docId {
                            Text(("ID: \(docID)"))
                        }
                    }
                }
                
                if let currentHousehold = firestoreManagerViewModel.currentHousehold {
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
                CreateHouseholdView()
            }
            .sheet(isPresented: $joinHouseholdViewPresented) {
                JoinHouseholdView()
            }
            .navigationTitle("Activity List")
            .navigationBarItems(
                leading: NavigationLink(destination: UserLogInView()
                    .navigationBarHidden(true)) {
                Text("Back")
            })
        }
    }
}

struct HouseholdSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        HouseholdSelectionView()
    }
}
