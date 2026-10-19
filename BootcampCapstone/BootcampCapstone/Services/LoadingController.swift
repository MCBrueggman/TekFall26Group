//
//  LoadingController.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 10/18/26.
//

import Foundation
enum LoadingState: Equatable {
    case loading
    case loaded
    case idle
    case refreshing
    case empty
    case failed(String)
}

@MainActor
@Observable
class LoadingController<Item> {
    private(set) var state: LoadingState = .idle
    private(set) var items: [Item] = []
    
    private let fetch: () async throws -> [Item]
    private var inFlightTask: Task<Void, Never>?
    private var alreadyLoaded: Bool = false
    
    init(fetch: @escaping () async throws -> [Item]) {
        self.fetch = fetch
    }
    
    var isBusy: Bool {
        switch state {
        case .loading, .refreshing:
            return true
        default:
            return false
        }
    }
    
    func load(userInitiated: Bool = false) async {
        if let inFlightTask {
            await inFlightTask.value
            return
        }
        
        if !userInitiated, alreadyLoaded {
            return
        }
        
        if items.isEmpty {
            self.state = .loading
        }
        else {
            self.state = .refreshing
        }
        
        let task = Task { [fetch] in
            do {
                let fetched = try await fetch()
                self.items = fetched
                self.alreadyLoaded = true
                if items.isEmpty {
                    self.state = .empty
                }
                else {
                    self.state = .loaded
                }
            }
            catch is CancellationError {
                if self.items.isEmpty {
                    self.state = .idle
                }
                else {
                    self.state = .loaded
                }
            }
            catch {
                self.state = .failed(error.localizedDescription)
            }
        }
        
        inFlightTask = task
        await task.value
        inFlightTask = nil
    }
}
