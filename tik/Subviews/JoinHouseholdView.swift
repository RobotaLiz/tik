//
//  JoinHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct JoinHouseholdView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var joinSuccessful = false
    @State var inputPin : String = ""
    @State var searchResult = ""
    @State var householdDocId = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Input PIN to search")
                    .padding()
                Spacer()
            }
            HStack {
                Spacer(minLength: 40)
                TextField("PIN", text: $inputPin)
                    .padding(10)
                    .border(.black)
                Spacer(minLength: 20)
                Button(action: {
                    authViewModel.searchFirebase(inputText: inputPin) { (documents, error) in
                        if let error = error {
                            print("Error searching Firestore: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let documents = documents else {
                            print("No matching documents")
                            return
                        }
                        
                        for document in documents {
                            let data = document.data()
                            if let pinNum = data!["pin"] as? String {
                                print("Matching document with pinNum: \(pinNum)")
                                searchResult = "Household found! Pin number: \(pinNum)"
                            }
                            
                            householdDocId = document.documentID
                            print("Household ID: \(householdDocId)")
                            
                        }
                    }
                    //presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
                Spacer(minLength: 40)
            }
            
            if !searchResult.isEmpty {
                VStack {
                    Text(searchResult)
                        .font(.title)
                    Button(action: {
                        authViewModel.joinHousehold(pin: inputPin)
                        //householdViewModel.currentUser?.isMember = true
                        //householdViewModel.makeCurrentUserMember()
                        joinSuccessful = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Join")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $joinSuccessful) {
                        ContentView()
                    }

                }
                .frame(width: 200, height: 150)
                .background(Color.gray)
                .cornerRadius(10)
                .padding()
                .font(.footnote)
            }
        }
//        .onAppear {
//            householdViewModel.householdFirestoreListener()
//        }
    }
}

struct JoinHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AuthViewModel()
        JoinHouseholdView(authViewModel: vm, inputPin: "inputPin")
    }
}
