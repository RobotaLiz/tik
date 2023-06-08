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
            // Add your image here
            ZStack (alignment: .center) {
                
                
                Image("Two Phone Mockup Download App Instagram Post(10)")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    /*
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
                     */
                    
                    
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
                    .buttonStyle(CustomButtonStyle())
                    Button(action: {
                        joinHouseholdViewPresented.toggle()
                    }) {
                        Text("Join")
                    }
                    .buttonStyle(CustomButtonStyle())
                    
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
                                .foregroundColor(.black)
                        })
            }
        }
    }
    
    struct HouseholdSelectionView_Previews: PreviewProvider {
        static var previews: some View {
            let vm = FirestoreManagerVM()
            HouseholdSelectionView().environmentObject(vm)
        }
    }
}
