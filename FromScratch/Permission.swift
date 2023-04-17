//
//  Permission.swift
//  FromScratch
//
//  Created by Pierre Tacchi on 2023-03-27.
//

import SwiftUI

struct Permission: Identifiable {
    
    static var common: [Self] {
        [.accessibility, .addressbook, .calendar, .camera, .microphone, .photos, .screencapture]
    }
    
    static var social: [Self] {
        [.facebook, .linkedin, .sinaweibo, .tencentweibo, .twitter]
    }
    
    static var systemPolicy: [Self] {
        [.systempolicyallfiles, .systempolicydesktopfolder, .systempolicydeveloperfiles, .systempolicydocumentsfolder, .systempolicydownloadsfolder, .systempolicynetworkvolumes, .systempolicyremovablevolumes, .systempolicysysadminfiles]
    }
    
    static var other: [Self] {
        [.appleevents, .contactsfull, .contactslimited, .developertool, .listenevent, .liverpool, .location, .medialibrary, .motion, .photosadd, .postevent, .reminders, .sharekit, .sinaweibo, .siri, .speechrecognition, .ubiquity, .willow]
    }
    
    static let all = Permission(id: "all", systemImage: "staroflife.fill")
    static let accessibility = Permission(id: "accessibility", appImage: "accessibility")
    static let addressbook = Permission(id: "addressbook", displayName: "Address Book", systemImage: "person.crop.square")
    static let calendar = Permission(id: "calendar", systemImage: "calendar")
    static let camera = Permission(id: "camera", systemImage: "camera")
    static let microphone = Permission(id: "microphone", systemImage: "mic")
    static let photos = Permission(id: "photos", systemImage: "photo")
    static let screencapture = Permission(id: "screencapture", displayName: "Screen Capture", systemImage: "rectangle.dashed.badge.record")
    static let systempolicyallfiles = Permission(id: "systempolicyallfiles", displayName: "All Files", commandName: "SystemPolicyAllFiles", systemImage: "doc.on.doc")
    static let systempolicydesktopfolder = Permission(id: "systempolicydesktopfolder", displayName: "Desktop Folder", commandName: "SystemPolicyDesktopFolder", systemImage: "menubar.dock.rectangle")
    static let systempolicydeveloperfiles = Permission(id: "systempolicydeveloperfiles", displayName: "Developer Files", commandName: "SystemPolicyDeveloperFiles", systemImage: "hammer")
    static let systempolicydocumentsfolder = Permission(id: "systempolicydocumentsfolder", displayName: "Documents Folder", commandName: "SystemPolicyDocumentsFolder", systemImage: "doc")
    static let systempolicydownloadsfolder = Permission(id: "systempolicydownloadsfolder", displayName: "Downloads Folder", commandName: "SystemPolicyDownloadsFolder", systemImage: "arrow.down.doc")
    static let systempolicynetworkvolumes = Permission(id: "systempolicynetworkvolumes", displayName: "Network Volumes", commandName: "SystemPolicyNetworkVolumes", systemImage: "externaldrive.connected.to.line.below")
    static let systempolicyremovablevolumes = Permission(id: "systempolicyremovablevolumes", displayName: "Removable Volumes", commandName: "SystemPolicyRemovableVolumes", systemImage: "sdcard")
    static let systempolicysysadminfiles = Permission(id: "systempolicysysadminfiles", displayName: "SysAdmin Files", commandName: "SystemPolicySysAdminFiles", systemImage: "rectangle.stack.badge.person.crop")
    static let appleevents = Permission(id: "appleevents", displayName: "Apple Events", systemImage: "applescript")
    static let contactsfull = Permission(id: "contactsfull", displayName: "Contacts Full", systemImage: "person.crop.circle.badge.checkmark")
    static let contactslimited = Permission(id: "contactslimited", displayName: "Contacts Limited", systemImage: "person.crop.circle")
    static let developertool = Permission(id: "developertool", displayName: "Developer Tool", systemImage: "wrench.and.screwdriver")
    static let facebook = Permission(id: "facebook", appImage: "facebook")
    static let linkedin = Permission(id: "linkedin", displayName: "LinkedIn", appImage: "linkedin")
    static let listenevent = Permission(id: "listenevent", displayName: "Listen Event")
    static let liverpool = Permission(id: "liverpool")
    static let location = Permission(id: "location", systemImage: "location")
    static let medialibrary = Permission(id: "medialibrary", displayName: "Media Library", systemImage: "popcorn")
    static let motion = Permission(id: "motion", systemImage: "figure.walk.motion")
    static let photosadd = Permission(id: "photosadd", displayName: "Photos Add", systemImage: "photo.on.rectangle.angled")
    static let postevent = Permission(id: "postevent", displayName: "Post Event")
    static let reminders = Permission(id: "reminders", systemImage: "checklist")
    static let sharekit = Permission(id: "sharekit", displayName: "Share Kit", systemImage: "square.and.arrow.up")
    static let sinaweibo = Permission(id: "sinaweibo", displayName: "Sina Weibo")
    static let siri = Permission(id: "siri", systemImage: "waveform")
    static let speechrecognition = Permission(id: "speechrecognition", displayName: "Speech Recognition", systemImage: "waveform")
    static let tencentweibo = Permission(id: "tencentweibo", displayName: "Tencent Weibo")
    static let twitter = Permission(id: "twitter", appImage: "twitter")
    static let ubiquity = Permission(id: "ubiquity")
    static let willow = Permission(id: "willow")
    
    let id: String
    let displayName: String
    let commandName: String
    let image: () -> Image
    
    init(id: String, displayName: String? = nil, commandName: String? = nil, systemImage: String? = nil) {
        let resolvedDisplayName = displayName ?? id.capitalized
        
        self.id = id
        self.displayName = resolvedDisplayName
        self.commandName = commandName ?? resolvedDisplayName.replacingOccurrences(of: " ", with: "")
        self.image = {
            Image(systemName: systemImage ?? "gearshape")
        }
    }
    
    init(id: String, displayName: String? = nil, commandName: String? = nil, appImage: String) {
        let resolvedDisplayName = displayName ?? id.capitalized
        
        self.id = id
        self.displayName = resolvedDisplayName
        self.commandName = commandName ?? resolvedDisplayName.replacingOccurrences(of: " ", with: "")
        self.image = {
            Image(appImage)
        }
    }
    
    func button(for app: NSRunningApplication) -> some View {
        PermissionButton(app: app, permission: self)
    }
}

private struct PermissionButton: View {
    
    let app: NSRunningApplication
    let permission: Permission
    
    @State var isResettingPermission = false
    
    var body: some View {
        Button {
            resetPermission()
        } label: {
            Label { Text(permission.displayName) } icon: { permission.image }
        }
        .disabled(app.bundleIdentifier == nil || app.localizedName == nil || isResettingPermission)
    }
    
    private func resetPermission() {
        guard let id = app.bundleIdentifier, let name = app.localizedName else {
            return
        }
        
        isResettingPermission = true
        
        Task.detached {
            let resultId = id + permission.commandName
            let icon = app.icon.map(Image.init(nsImage: ))
            
            do {
                let task = Process()
                task.launchPath = "/bin/zsh"
                task.arguments = ["-c", "tccutil reset \(permission.commandName) \(id)"]
                try task.run()
                task.waitUntilExit()
                
                // `tccutil` exits with a code of 0 if it succeeded
                // if anything went wrong, the value is non-zero
                if task.terminationStatus != 0 {
                    throw ProcessError.other(task.terminationStatus)
                }
                
                await MainActor.run {
                    let message = Text("Successfully reset \(permission.displayName) approval status for \(name)")
                    ActionResultOverlay.postSuccessfulResult(id: resultId, message: message, image: icon)
                    self.isResettingPermission = false
                }
            } catch {
                await MainActor.run {
                    let message = Text("Failed to reset \(permission.displayName) approval status for \(name)")
                    ActionResultOverlay.postFailedResult(id: resultId, message: message, image: icon)
                    self.isResettingPermission = false
                }
            } label: {
                Label { Text(displayName) } icon: { image() }
            }
        } else {
            Button { } label: {
                Label { Text(displayName) } icon: { image() }
            }.disabled(true)
        }
    }
    
}

private enum ProcessError: Error {
    case other(Int32)
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
