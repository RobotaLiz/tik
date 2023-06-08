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
            
            ZStack {
                // Add your image here
                Image("Two Phone Mockup Download App Instagram Post(10) copy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    VStack {
                        
                        Image("Two Phone tik2")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .padding(.bottom)
                    }
                    .edgesIgnoringSafeArea(.all)
                    HStack {
                        Spacer()
                        Text("Input PIN to search")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                    HStack {
                        Spacer(minLength: 90)
                        TextField(" PIN", text: $inputPin, onEditingChanged: { _ in
                            pinIsValid = inputPin.count == 6
                        })
                        .font(.custom("Roboto-Bold", size: 24))
                        .foregroundColor(.white)
                        .frame(height: 50) // <-- Specify your desired height here
                        .background()
                        .border(pinIsValid ? .white : .appYellow)
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
                                pinAlert = true
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .buttonStyle(CustomButtonStyle())
                        Spacer(minLength: 60)
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
                                }) {                               Text("Join")
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
                    Alert(title: Text("Invalid PIN"), message: Text("Please enter a valid 6-digit PIN."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}



struct JoinHouseholdView_Previews: PreviewProvider {
    static var previews: some View {
        JoinHouseholdView()
    }
}
