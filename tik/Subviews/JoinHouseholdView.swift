//
//  JoinHouseholdView.swift
//  tik
//
//  Created by Antonio on 2023-05-18.
//

import SwiftUI

struct JoinHouseholdView: View {
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    @Environment(\.presentationMode) var presentationMode
    @State var joinSuccessful = false
    @State var inputPin : String = ""
    @State var pinIsValid = false
    @State var pinAlert = false
    @State var searchResult : [Household]?
    @State var householdDocId = ""
    @State var searchStatus: SearchStatus = .idle
    
    enum SearchStatus {
        case idle
        case searching
        case found
        case notFound
    }
    
    //DEBUG
    @State var alertMsg : String?
    
    var body: some View {
        NavigationView {
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
                        pinIsValid = inputPin.count == 6 // Perform validation check
                        
                        if pinIsValid {
                            alertMsg = "PIN is valid"
                            searchStatus = .searching
                            firestoreManagerViewModel.getHouseholds(pin: inputPin) { households, error in
                                if let error = error {
                                    // Handle the error
                                    print("Error: \(error.localizedDescription)")
                                    searchStatus = .notFound
                                } else if let households = households {
                                    searchResult = households
                                    searchStatus = households.isEmpty ? .notFound : .found
                                    print(searchResult ?? "No household found")
                                }
                            }
                        } else {
                            alertMsg = "PIN is not valid"
                            pinAlert = true
                            searchResult = nil
                            searchStatus = .idle
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                    }

                    .buttonStyle(.borderedProminent)
                    Spacer(minLength: 40)
                }

                switch searchStatus {
                case .idle:
                    EmptyView()
                case .searching:
                    ProgressView()
                case .found:
                    if let searchResult = searchResult {
                        VStack {
                            Text(searchResult[0].name)
                                .font(.title)
                            Button(action: {
                                firestoreManagerViewModel.joinHousehold(household: searchResult[0])
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
                case .notFound:
                    Text("No household found")
                        .font(.title)
                        .frame(width: 200, height: 150)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding()
                        .font(.footnote)
                }
            }

            .alert(isPresented: $pinAlert) {
                Alert(title: Text("Test"), message: Text(alertMsg!), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct JoinHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        JoinHouseholdView()
    }
}
