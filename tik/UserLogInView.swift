
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserLogInView: View {
    enum Field: Hashable {
        case usernameField
        case passwordField
    }
    
    let db = Firestore.firestore()
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    // Tobbe added this to navigate to the list view on log in: (Also, see content view)
    // loggedIn is changed in signIn function.
    @Binding var loggedIn: Bool
    
    
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
        
        
        Form {
            TextField("Name", text: $name)
                .foregroundColor(.black)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .usernameField)
                .font(.title3)
                .textInputAutocapitalization(.never)
            
            TextField("Username:", text: $username)
            
                .foregroundColor(.black)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .usernameField)
                .font(.title3)
                .textInputAutocapitalization(.never)
            
            SecureField("Password:", text: $password)
                .foregroundColor(.black)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.yellow)
                .padding(10)
                .shadow(color: .purple, radius: 10)
                .focused($focusedField, equals: .passwordField)
                .font(.title3)
            
        }
        HStack{
            Button("Add account", action: {
                addAccount()
            })
            Image(systemName: "person.fill.badge.plus")
                .foregroundColor(.gray)
            
        }
        Button("Sign In") {
            signIn()
            
        }
        
        .padding(9)
        .background(.yellow)
        .foregroundColor(.black)
        .clipShape(Capsule())
        .padding(50)
    }
    
    func signIn() { 
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
                // Tobbe added this:
                loggedIn = true
            } 
        }
    }
    
    func addAccount() {
        Auth.auth().createUser(withEmail:username, password: password) { (result, error) in
            guard let user = result?.user, error == nil else {
                print("Error creating user: \(error!.localizedDescription)")
                return
            }
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
            } else if result != nil {
                // Creates both new auth user and firestore document with auth uid as docID
                let newUser = User(name: self.name, email: self.username)
                let usersRef = self.db.collection("users").document(user.uid)
                
                
                if let name = newUser.name, let email = newUser.email {
                    usersRef.setData([
                        "name": name,
                        "email": email]) { error in
                            if let error = error {
                                print("Error adding document: \(error.localizedDescription)")
                            } else {
                                print("Document added with ID: \(usersRef.documentID)")
                                //self.onUserCreationSuccess?()
                            }
                        }
                }
                
                signIn()
            }
        }
    }
}
