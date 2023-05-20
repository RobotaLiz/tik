

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State var loggedIn = false
    
    var body: some View {
        Group {
            if loggedIn {
                TaskListView()
            }else{
                UserLogInView(loggedIn: $loggedIn)
            }
        }
        .onAppear() {
            checkLoggedInStatus()
        }
    }
    
    func checkLoggedInStatus() {
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            loggedIn = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
