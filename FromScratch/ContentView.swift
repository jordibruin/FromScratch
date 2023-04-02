//
//  ContentView.swift
//  FromScratch
//
//  Created by Jordi Bruin on 20/03/2023.
//

import SwiftUI
import Consequences

struct ContentView: View {
    @StateObject private var provider = RunningAppsProvider.shared
    @State private var searchText = ""
    
    private var runningApps: [NSRunningApplication] {
        provider.runningApps.filter(on: \.localizedName, localizedCaseInsensitiveContains: searchText)
    }
    
    var body: some View {
        List {
            ForEach(runningApps, id: \.processIdentifier, content: RunningAppRow.init)
        }
        .searchable(text: $searchText)
        .overlay { ActionResultOverlay() }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Toggle("Show all processes", isOn: $provider.showAll)
                .expandWidth(alignment: .leading)
                .padding(horizontal: 20, vertical: 10)
                .background(in: Rectangle())
                .overlay(alignment: .top) { Divider() }
                .backgroundStyle(.bar)
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .animation(.default, observed: provider)
        .animation(.default, value: searchText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}



