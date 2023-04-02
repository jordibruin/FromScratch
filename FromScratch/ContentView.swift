//
//  ContentView.swift
//  FromScratch
//
//  Created by Jordi Bruin on 20/03/2023.
//

import SwiftUI
import Consequences

struct ContentView: View {
    @State var allApps: [NSRunningApplication] = []
    
    @AppStorage("showAll") private var showAll = false
    @State private var searchText = ""
    
    private var runningApps: [NSRunningApplication] {
        var apps = allApps
            .filter { $0.localizedName != nil }
            .sorted(localizedCaseInsensitiveBy: \.localizedName)
        if !showAll {
            apps = apps.filter { $0.activationPolicy == .regular }
        }
        if !searchText.isEmpty {
            apps = apps.filter(on: \.localizedName, localizedCaseInsensitiveContains: searchText)
        }
        return apps
    }
    
    var body: some View {
        List {
            ForEach(runningApps, id: \.processIdentifier, content: RunningAppRow.init)
        }
        .searchable(text: $searchText)
        .overlay { ActionResultOverlay() }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Toggle("Show all processes", isOn: $showAll)
                .expandWidth(alignment: .leading)
                .padding(horizontal: 20, vertical: 10)
                .background(in: Rectangle())
                .overlay(alignment: .top) { Divider() }
                .backgroundStyle(.bar)
        }
        .onReceive(NSWorkspace.shared.publisher(for: \.runningApplications)) {
            self.allApps = $0
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .animation(.default, value: allApps)
        .animation(.default, value: searchText)
        .animation(.default, value: showAll)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}



