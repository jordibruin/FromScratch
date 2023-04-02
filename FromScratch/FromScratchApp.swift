//
//  FromScratchApp.swift
//  FromScratch
//
//  Created by Jordi Bruin on 20/03/2023.
//

import SwiftUI

@main
struct FromScratchApp: App {
    var body: some Scene {
        Window(Text("FromScratch"), id: "main") {
            ContentView()
                .width(min: 420, ideal: 512, max: 888)
                .height(min: 420)
                .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
        }
        .windowResizability(.contentSize)
    }
}
