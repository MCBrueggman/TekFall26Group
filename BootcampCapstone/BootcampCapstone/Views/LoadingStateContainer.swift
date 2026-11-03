//
//  LoadingStateContainer.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 10/18/26.
//

import SwiftUI

struct LoadingStateContainer<Item, Content: View>: View {
    let loader : LoadingController<Item>
    let content: Content
    
    init(loader: LoadingController<Item>, content: Content) {
        self.loader = loader
        self.content = content
    }

    var body: some View {
        switch loader.state {
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded:
            content
        case .idle:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .refreshing:
            content
        case .empty:
            ContentUnavailableView {
                Label("No content available.", systemImage: "exclamationmark.circle")
            } description: {
                Text("Request successful, but no data was returned.")
            } actions: {
                Button("Try again") {
                    Task {
                        await loader.load(userInitiated: true)
                    }
                }
            }
        case .failed(let error):
            if loader.items.isEmpty {
                ContentUnavailableView {
                    Label("Failed to load.", systemImage: "exclamationmark.circle")
                } description: {
                    Text(error)
                } actions: {
                    Button("Try again") {
                        Task {
                            await loader.load(userInitiated: true)
                        }
                    }
                }
            }
            else {
                VStack {
                    Label("Refresh failed: \(error)", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                    content
                }
            }
        }
    }
    
}
