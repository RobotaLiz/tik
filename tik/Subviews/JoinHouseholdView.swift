//
//  JoinHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct JoinHouseholdView: View {
    
    @ObservedObject var viewModel : JoinHouseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var inputPin : String
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
                    viewModel.searchFirebase(inputText: inputPin) { (documents, error) in
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
                            if let pinNum = data!["pinNum"] as? String {
                                print("Matching document with pinNum: \(pinNum)")
                                searchResult = "Household found! Pin number: \(pinNum)"
                            }
                            
                            householdDocId = document.documentID
                            print("Household ID: \(householdDocId)")
                            
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
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
                        viewModel.addCurrentUserToHousehold(householdId: householdDocId)
                    }) {
                        Text("Join")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: 200, height: 150)
                .background(Color.gray)
                .cornerRadius(10)
                .padding()
            }
        }
        .onAppear {
            viewModel.householdFirestoreListener()
        }
    }
}

struct JoinHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = JoinHouseViewModel(household: Household(name: "Test name", pinNum: "666"))
        JoinHouseholdView(viewModel: vm, inputPin: "inputPin")
    }
}
