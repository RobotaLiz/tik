//
//  tikApp.swift
//  tik
//
//  Created by Liza Hjortling on 2023-05-12.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct tikApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firestoreManagerViewModel = FirestoreManagerVM()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firestoreManagerViewModel)
        }
    }
}
