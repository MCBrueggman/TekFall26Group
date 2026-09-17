//
//  ContentView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

struct ContentView: View {
    @State private var current: String = ""

    @EnvironmentObject var authStatus: AuthStatus
   
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                    default: HomeView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Logout") { authStatus.updateLoginStatus(success: false)}
                    }
                    label: {
                        Label("View", systemImage: "line.3.horizontal")
                    }
                }
            }
        }
    }
}
