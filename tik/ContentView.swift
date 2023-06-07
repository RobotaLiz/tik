

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @EnvironmentObject var firestoreManagerViewModel : FirestoreManagerVM
    
    
    var body: some View {
        // Trying to rebuild this.
        Group {
            if firestoreManagerViewModel.currentTikUser == nil {
                UserLogInView()
            } else if firestoreManagerViewModel.currentTikUser != nil && firestoreManagerViewModel.currentHousehold != nil {
                //TaskListView(authViewModel: authViewModel)
                BottomTabBar()

            } else if firestoreManagerViewModel.currentTikUser != nil && firestoreManagerViewModel.currentHousehold == nil {
                HouseholdSelectionView()
            }
        }
        .onAppear() {
            firestoreManagerViewModel.getCurrentTikUser()
        }
    }
        
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FirestoreManagerVM()
        ContentView().environmentObject(vm)
    }
}
