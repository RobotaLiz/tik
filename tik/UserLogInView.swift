
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
    // Tobbe added this to navigate to the list view on log in: (Also, see content view)
    // loggedIn is changed in signIn function.
    //@Binding var loggedIn: Bool
    
    // Antonio's view model stuff
    @ObservedObject var authViewModel : AuthViewModel
    
    
    var body: some View {
        
        VStack{
            Image("tik")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 2)
                }
                .shadow(radius: 7)
                .padding()
            Label("My Tik Account", systemImage: "home")
                .padding(-50)
                .bold()
                .font(.title3)
                .padding(70)
        }
        
        // I moved the style stuff to theyr own file called TextFieldStyles. Commented out stuff can be safely deleted. /Antonio
        Form {
            TextField("Name", text: $name)
                .textFieldStyle(AuthTextFieldStyle())
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .usernameField)
                .textInputAutocapitalization(.never)
            
            TextField("Email:", text: $email)
                .textFieldStyle(AuthTextFieldStyle())
                .keyboardType(.emailAddress).font(.title3)
                .focused($focusedField, equals: .emailField) // Username or Email?
                .textInputAutocapitalization(.never)
            SecureField("Password:", text: $password)
                .textFieldStyle(AuthTextFieldStyle())
                .focused($focusedField, equals: .passwordField)
        }
        HStack{
            Button("Add account", action: {
                authViewModel.addAccount(name: name, email: email, password: password)
            })
            Image(systemName: "person.fill.badge.plus")
                .foregroundColor(.gray)
        }
        Button("Sign In") {
            authViewModel.signIn(email: email, password: password)
        }
        .padding(9)
        .background(.yellow)
        .foregroundColor(.black)
        .clipShape(Capsule())
        .padding(50)
    }
}
