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
        NavigationView {
            ZStack {
                // Add your image here
                Image("Two Phone Mockup Download App Instagram Post(10)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                // Big yellow circle
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 300, height: 300)
                    .offset(y: -230)

                VStack(alignment: .center) {
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
//                        Spacer()
                        Text("When to do it:")
                            .font(.custom("Roboto-Bold", size: 22))
                        .foregroundColor(.black)
//                        Spacer()
                        DatePicker("", selection: $setDate)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            
                    }
                    .padding()
                    .padding()
                    Spacer()
                    Button("Add", action: {

                        if let currentTikUser = firestoreManagerViewModel.currentTikUser {

                            // save to firestore.
                            let newTask = Task(title: title,
                                               notes: notes,
                                               location: location,
                                               assignedTo: [currentTikUser],
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
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(addTaskIsPresented: .constant(true))
    }
}
