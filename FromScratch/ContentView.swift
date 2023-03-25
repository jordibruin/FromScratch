//
//  ContentView.swift
//  FromScratch
//
//  Created by Jordi Bruin on 20/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var runningApps: [NSRunningApplication] = []
    
    @State var searchText = ""
    var body: some View {
        List {
            ForEach(runningApps.filter { searchText.isEmpty ? true :  $0.localizedName?.lowercased().contains(searchText.lowercased()) ?? false}, id: \.processIdentifier) { app in
                HStack {
                    if let img = app.icon {
                        Image(nsImage: img)
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    
                    Text(app.localizedName ?? "No name")
                        .font(.title2)
                        
                    Spacer()
                    Menu {
                        ForEach(Permission.allCases) { permission in
                            Button {
                                if let identifier = app.bundleIdentifier {
                                    let task = Process()
                                    task.launchPath = "/bin/zsh"
                                    task.arguments = ["-c", "tccutil reset \(permission.commandName) \(identifier)"]
                                    try? task.run()
                                }
                            } label: {
                                Text(permission.name)
                            }

                        }
                    } label: {
                        Text("Reset")
                    }
                    .menuStyle(.borderedButton)
                    .frame(width: 150)
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear {
            let apps = NSWorkspace.shared.runningApplications.filter{  $0.activationPolicy == .regular }.filter { $0.localizedName != nil }.sorted(by: { $0.localizedName! < $1.localizedName! })
            self.runningApps = apps
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Permission: String, CaseIterable, Identifiable {
    case microphone
    case screencapture
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .microphone:
            return "Microphone"
        case .screencapture:
            return "Screen Capture"
        }
    }
    
    var commandName: String {
        switch self {
        case .microphone:
            return "Microphone"
        case .screencapture:
            return "ScreenCapture"
        }
    }
}

//tccplus [add/reset] SERVICE [BUNDLE_ID]
//Services:
// - All
// - Accessibility
// - AddressBook
// - AppleEvents
// - Calendar
// - Camera
// - ContactsFull
// - ContactsLimited
// - DeveloperTool
// - Facebook
// - LinkedIn
// - ListenEvent
// - Liverpool
// - Location
// - MediaLibrary
// - Microphone
// - Motion
// - Photos
// - PhotosAdd
// - PostEvent
// - Reminders
// - ScreenCapture
// - ShareKit
// - SinaWeibo
// - Siri
// - SpeechRecognition
// - SystemPolicyAllFiles
// - SystemPolicyDesktopFolder
// - SystemPolicyDeveloperFiles
// - SystemPolicyDocumentsFolder
// - SystemPolicyDownloadsFolder
// - SystemPolicyNetworkVolumes
// - SystemPolicyRemovableVolumes
// - SystemPolicySysAdminFiles
// - TencentWeibo
// - Twitter
// - Ubiquity
// - Willow
