

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.loggedIn {
                TaskListView(authViewModel: authViewModel)
                    .onAppear {
                        authViewModel.didSignOut = {
                            authViewModel.loggedIn = false
                        }
                    }
            } else {
                UserLogInView(authViewModel: authViewModel)
            }
        }
        .onAppear {
            authViewModel.checkLoggedInStatus()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
