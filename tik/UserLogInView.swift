
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserLogInView: View {
    enum Field: Hashable {
        case usernameField
        case passwordField
        case emailField
    }
    
    let db = Firestore.firestore()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    
    var body: some View {
        ZStack {
            // Add your image here
            Image("Two Phone Mockup Download App Instagram Post(10) copy 2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            // Logo in the bottom center
            VStack {
                Spacer()
                Image("Two Phone Mockup Download App Instagram Post(14)")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom)
            }
            .edgesIgnoringSafeArea(.all)
            
            //Form and Buttons in a semi-transparent box
            VStack {
                Form {
                    VStack{
                        TextField("Name", text: $name)
                            .textFieldStyle(AuthTextFieldStyle())
                        
                            .focused($focusedField, equals: .usernameField)
                            .textInputAutocapitalization(.never)
                        
                        TextField("Email:", text: $email)
                            .textFieldStyle(AuthTextFieldStyle())
                            .keyboardType(.emailAddress).font(.title3)
                            .focused($focusedField, equals: .emailField)
                            .textInputAutocapitalization(.never)
                        
                        SecureField("Password:", text: $password)
                            .textFieldStyle(AuthTextFieldStyle())
                            .focused($focusedField, equals: .passwordField)
                    }
                }
                .padding()
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                
                
                HStack {
                    Button("Add account", action: {
                        firestoreManagerViewModel.addAccount(name: name, email: email, password: password)

                            
                    }
                           
                    )
                    .font(.custom("Roboto-Bold", size: 20))
                    .foregroundColor(.appBlack)
                    Image(systemName: "person.fill.badge.plus")
                        .foregroundColor(.appBlack)
                    
                }
                .padding(.top)
                
                Button("Sign In") {
                    firestoreManagerViewModel.signIn(email: email, password: password)
                }
                .font(.custom("Roboto-Bold", size: 18))
                .padding(9)
                .background(.yellow)
                .foregroundColor(.black)
                .clipShape(Capsule())
                .padding(.top, 20)
            }
            .frame(width: 300, height: 370)
           
            
            .padding()
            .toastView(toast: $firestoreManagerViewModel.toast)
        }
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        UserLogInView().environmentObject(vm)
    }
}
