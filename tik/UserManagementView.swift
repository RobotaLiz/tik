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
                            Text("Member Management")
                            Spacer()
                        }
                        List {
                            ForEach(firestoreManagerViewModel.members, id: \.self) { member in
                                if let name = member.name, let docId = member.docId {
                                    Button(action: {
                                        
                                    }) {
                                        Text(name)
                                        Text(docId)
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            firestoreManagerViewModel.kick(userDocId: docId)
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
