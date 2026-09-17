//
//  BootcampCapstoneApp.swift
//  BootcampCapstone
//
//  Created by user301385 on 9/17/26.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    let kazooAPIURL = "https://kazoopromotions.com/api"
    @StateObject var authStatus = AuthStatus()
    
    var body: some Scene {
        WindowGroup {
            if authStatus.isLoggedIn {
                ContentView()
                // configure custom dependency injection
                .environmentObject(authStatus)
            } else {
                LoginView()
                    .environmentObject(authStatus)
            }
        }
    }
}
