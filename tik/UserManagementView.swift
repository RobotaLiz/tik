//
//  UserManagementView.swift
//  tik
//
//  Created by Antonio on 2023-06-05.
//

import SwiftUI

struct UserManagementView: View {
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    @State var selfKickAlertPresented = false
    
    var body: some View {
        VStack {
            if let isAdmin = firestoreManagerViewModel.isCurrentUserAdmin {
                if isAdmin {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Current user has the power!").font(.headline)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Household Member Management").font(.subheadline)
                            Spacer()
                        }
                        List {
                            ForEach(firestoreManagerViewModel.members, id: \.self) { member in
                                if let name = member.name, let docId = member.docId {
                                    Button(action: {
                                        
                                    }) {
                                        Text(name)
                                        //Text(docId)
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            //firestoreManagerViewModel.kick(userDocId: docId)
                                            if firestoreManagerViewModel.currentTikUser?.docId == docId {
                                                selfKickAlertPresented = true
                                            } else {
                                                firestoreManagerViewModel.kick(userDocId: docId)
                                            }
                                        }) {
                                            Label("Remove member", systemImage: "person.badge.minus")

                                        }
                                        
                                        Button(action: {
                                            firestoreManagerViewModel.makeAdmin(userDocId: docId)
                                        }) {
                                            Label("Make admin", systemImage: "crown")

                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
            } else {
                HStack {
                    Spacer()
                    Text("You are not an admin.")
                    Spacer()
                }
            }
            
        }
        .alert(isPresented: $selfKickAlertPresented) {
            Alert(title: Text("Invalid Action"), message: Text("You can't kick yourself, you dummy."), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            //firestoreManagerViewModel.adminCheck()
            //firestoreManagerViewModel.memberListener()
            firestoreManagerViewModel.printHouseholdMembers()
        }
    }
}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        UserManagementView().environmentObject(vm)
    }
}
