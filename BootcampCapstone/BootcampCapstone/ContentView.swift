//
//  ContentView.swift
//  BootcampCapstone
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

struct ContentView: View {
    @State private var current: String = "inventory"
    @EnvironmentObject var authStatus: AuthStatus
    
    private var inventoryRepo: RemoteInventoryRepo {
        RemoteInventoryRepo(
            urlBase: "https://api.bootcampcentral.com/api",
            authStatus: authStatus
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "inventory":
                    InventoryAwarenessView(repository: inventoryRepo)
                default:
                    HomeView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Inventory") { current = "inventory" }
                        Divider()
                        Button("Logout") { authStatus.updateLoginStatus(success: false) }
                    } label: {
                        Label("View", systemImage: "line.3.horizontal")
                    }
                }
            }
        }
    }
}
