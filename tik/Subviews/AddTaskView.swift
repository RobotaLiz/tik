//
//  AddTaskView.swift
//  tik
//
//  Created by Tobias Sörensson on 2023-05-20.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct AddTaskView: View {
    
    @Binding var addTaskIsPresented: Bool
    @State var title = ""
    @State var notes = ""
    @State var location = ""
    @State var setDate = Date()
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    var body: some View {
//        NavigationView {
            ZStack (alignment: .center) {
                
                
                    Image("Two Phone Mockup Download App Instagram Post(10)")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    // Your other views here...
                    
                    
                    
                    
                    
                    
                    // Big yellow circle
                    Circle()
                    
                        .fill(Color.yellow)
                        .frame(width: 300, height: 300)
                        .offset(y: -180)
                    VStack(alignment: .center) {
                        Spacer().frame(height: 90)
                        TextField("What to do:", text: $title)
                            .font(.custom("Roboto-Bold", size: 22))
                            .multilineTextAlignment(.center)
                            .padding()
                        TextField("How to do it:", text: $notes)
                            .font(.custom("Roboto-Bold", size: 22))
                            .multilineTextAlignment(.center)
                            .padding()
                        TextField("Where to do it:", text: $location)
                            .font(.custom("Roboto-Bold", size: 22))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        
                        //                    Text("When to do it:")
                        VStack {
                            Spacer().frame(height: 70)
                            Text("When to do it:")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            DatePicker("", selection: $setDate)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                            
                        }
                        Spacer().frame(height: 70)
                        Button("Add", action: {
                            
                            if let currentTikUser = firestoreManagerViewModel.currentTikUser {
                                
                                // save to firestore.
                                let newTask = Task(title: title,
                                                   notes: notes,
                                                   location: location,
                                                   assignedTo: [],
                                                   setDate: setDate)
                                
                                firestoreManagerViewModel.saveTaskToFirestore(task: newTask)
                                addTaskIsPresented = false
                            }
                        })
                        .buttonStyle(CustomButtonStyle())
                        .navigationBarItems(trailing: Button {
                            addTaskIsPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        })
                        
                    }
                }
                //            VStack {
                //                TextField("What to do:", text: $title)
                //                    .padding()
                //                TextField("How to do it:", text: $notes)
                //                    .padding()
                //                TextField("Where to do it:", text: $location)
                //                    .padding()
                //                HStack {
                //                    Spacer()
                //                    Text("When to do it:")
                //                    DatePicker("", selection: $setDate)
                //                    Spacer()
                //                }
                //                .padding()
                //                Spacer()
                //                Button("Add", action: {
                //
                //                    if let currentTikUser = firestoreManagerViewModel.currentTikUser {
                //
                //
                //                        // save to firestore.
                //                        let newTask = Task(title: title,
                //                                           notes: notes,
                //                                           location: location,
                //                                           assignedTo: [currentTikUser],
                //                                           setDate: setDate)
                //
                //                        firestoreManagerViewModel.saveTaskToFirestore(task: newTask)
                //                        addTaskIsPresented = false
                //                    }
                //
                //                })
                //                .navigationBarItems(trailing: Button {
                //                    addTaskIsPresented = false
                //                } label: {
                //                    Image(systemName: "xmark")
                //                })
                //            }
            }
        }
//    }
    
    struct AddTaskView_Previews: PreviewProvider {
        static var previews: some View {
            AddTaskView(addTaskIsPresented: .constant(true))
        }
    }

