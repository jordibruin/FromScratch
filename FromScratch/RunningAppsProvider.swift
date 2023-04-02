//
//  RunningAppsProvider.swift
//  FromScratch
//
//  Created by Pierre Tacchi on 2023-03-27.
//

import SwiftUI
import Combine
import Consequences
import Defaults

final class RunningAppsProvider: ObservableObject {
    static let shared: RunningAppsProvider = .init()
    
    private var cancellables: Set<AnyCancellable>
    
    @Default(.showAll) var showAll {
        didSet { updateRunningApps() }
    }
        
    @Published var runningApps: [NSRunningApplication]
    
    private init() {
        self.cancellables = []
        self.runningApps = []
        
        let notCenter = NSWorkspace.shared.notificationCenter
        let launchPublisher = notCenter.publisher(for: NSWorkspace.didLaunchApplicationNotification)
        let terminatePublisher = notCenter.publisher(for: NSWorkspace.didTerminateApplicationNotification)
        
        launchPublisher.merge(with: terminatePublisher)
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [unowned self] _ in self.updateRunningApps() }
            .store(in: &cancellables)
        
        updateRunningApps()
    }
    
    private func updateRunningApps() {
        var predicates: [Predicate<NSRunningApplication>] = [.onNotNil(\.localizedName)]
        if !showAll { predicates = [.on(\.activationPolicy, equalTo: .regular)] + predicates }
        
        runningApps = NSWorkspace.shared.runningApplications.lazy
            .filter(using: predicates)
            .sorted(localizedCaseInsensitiveBy: \.localizedName)
    }
}
