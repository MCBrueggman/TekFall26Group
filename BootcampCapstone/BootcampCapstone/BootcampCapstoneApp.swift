//
//  BootcampCapstoneApp.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI
internal import CoreData

@main
struct SwiftUIDemoApp: App {
    let awAPIURL = "https://api.bootcampcentral.com/api"
    @StateObject var authStatus = AuthStatus()
    
    var body: some Scene {
        WindowGroup {
            if authStatus.isLoggedIn {
                ContentView()
                .environment(\.employeeRepository, RemoteEmployeeRepo(urlBase: awAPIURL, authStatus: authStatus))
                .environmentObject(authStatus)
            } else {
                LoginView()
                    .environmentObject(authStatus)
            }
        }
    }
}
