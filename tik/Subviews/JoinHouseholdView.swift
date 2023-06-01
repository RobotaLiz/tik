//
//  JoinHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct JoinHouseholdView: View {
    
    @ObservedObject var authViewModel : FirestoreManagerVM
    @Environment(\.presentationMode) var presentationMode
    @State var joinSuccessful = false
    @State var inputPin : String = ""
    @State var pinIsValid = false
    @State var pinAlert = false
    @State var searchResult : [Household?]?
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
                TextField("PIN", text: $inputPin, onEditingChanged: { _ in
                    pinIsValid = inputPin.count == 6
                })
                    .padding(10)
                    .border(pinIsValid ? .black : .red)
                Spacer(minLength: 20)
                Button(action: {
                    if pinIsValid {
                        authViewModel.getHouseholds(pin: inputPin) { households, error in
                            if let error = error {
                                // Handle the error
                                print("Error: \(error.localizedDescription)")
                            } else if let households = households {
                                searchResult = households
                                print(searchResult ?? "No household found")
                            }
                        }
                    } else {
                        pinAlert = true
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderedProminent)
                Spacer(minLength: 40)
            }
            
            if let searchResult = searchResult, let foundHousehold = searchResult[0] {
                VStack {
                    Text(foundHousehold.name)
                        .font(.title)
                    Button(action: {
                        authViewModel.joinHousehold(household: foundHousehold)
                        //householdViewModel.currentUser?.isMember = true
                        //householdViewModel.makeCurrentUserMember()
                        joinSuccessful = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Join")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!pinIsValid)
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
        .alert(isPresented: $pinAlert) {
            Alert(title: Text("Invalid PIN"), message: Text("Please enter a valid 6-digit PIN."), dismissButton: .default(Text("OK")))
        }
        
    }
    

}

struct JoinHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        JoinHouseholdView(authViewModel: vm, inputPin: "inputPin")
    }
}
