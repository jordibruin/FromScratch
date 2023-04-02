//
//  Permission.swift
//  FromScratch
//
//  Created by Pierre Tacchi on 2023-03-27.
//

import SwiftUI

enum Permission: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case all
    case accessibility, addressbook, calendar, camera, microphone, photos, screencapture
    case systempolicyallfiles, systempolicydesktopfolder, systempolicydeveloperfiles, systempolicydocumentsfolder, systempolicydownloadsfolder, systempolicynetworkvolumes, systempolicyremovablevolumes, systempolicysysadminfiles
    case appleevents, contactsfull, contactslimited, developertool, facebook, linkedin, listenevent, liverpool, location, medialibrary, motion, photosadd, postevent, reminders, sharekit, sinaweibo, siri, speechrecognition, tencentweibo, twitter, ubiquity, willow
    
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
    
    var displayName: String {
        switch self {
        case .addressbook: return "Address Book"
        case .appleevents: return "Apple Events"
        case .contactsfull: return "Contacts Full"
        case .contactslimited: return "Contacts Limited"
        case .developertool: return "Developer Tool"
        case .linkedin: return "LinkedIn"
        case .listenevent: return "Listen Event"
        case .medialibrary: return "Media Library"
        case .photosadd: return "Photos Add"
        case .postevent: return "Post Event"
        case .sharekit: return "Share Kit"
        case .sinaweibo: return "Sina Weibo"
        case .speechrecognition: return "Speech Recognition"
        case .screencapture: return "Screen Capture"
        case .systempolicyallfiles: return "All Files"
        case .systempolicydesktopfolder: return "Desktop Folder"
        case .systempolicydeveloperfiles: return "Developer Files"
        case .systempolicydocumentsfolder: return "Documents Folder"
        case .systempolicydownloadsfolder: return "Downloads Folder"
        case .systempolicynetworkvolumes: return "Network Volumes"
        case .systempolicyremovablevolumes: return "Removable Volumes"
        case .systempolicysysadminfiles: return "SysAdmin Files"
        case .tencentweibo: return "Tencent Weibo"
        default: return rawValue.capitalized
        }
    }
    
    var commandName: String {
        switch self {
        case .systempolicyallfiles: return "SystemPolicyAllFiles"
        case .systempolicydesktopfolder: return "SystemPolicyDesktopFolder"
        case .systempolicydeveloperfiles: return "SystemPolicyDeveloperFiles"
        case .systempolicydocumentsfolder: return "SystemPolicyDocumentsFolder"
        case .systempolicydownloadsfolder: return "SystemPolicyDownloadsFolder"
        case .systempolicynetworkvolumes: return "SystemPolicyNetworkVolumes"
        case .systempolicyremovablevolumes: return "SystemPolicyRemovableVolumes"
        case .systempolicysysadminfiles: return "SystemPolicySysAdminFiles"
        default: return displayName.replacingOccurrences(of: " ", with: "")
        }
    }
    
    fileprivate var image: Image {
        switch self {
        case .all: return Image(systemName: "staroflife.fill")
        case .accessibility: return Image("accessibility")
        case .addressbook: return Image(systemName: "person.crop.square")
        case .calendar: return Image(systemName: "calendar")
        case .camera: return Image(systemName: "camera")
        case .microphone: return Image(systemName: "mic")
        case .photos: return Image(systemName: "photo")
        case .screencapture: return Image(systemName: "rectangle.dashed.badge.record")
        case .systempolicyallfiles: return Image(systemName: "doc.on.doc")
        case .systempolicydesktopfolder: return Image(systemName: "menubar.dock.rectangle")
        case .systempolicydeveloperfiles: return Image(systemName: "hammer")
        case .systempolicydocumentsfolder: return Image(systemName: "doc")
        case .systempolicydownloadsfolder: return Image(systemName: "arrow.down.doc")
        case .systempolicynetworkvolumes: return Image(systemName: "externaldrive.connected.to.line.below")
        case .systempolicyremovablevolumes: return Image(systemName: "sdcard")
        case .systempolicysysadminfiles: return Image(systemName: "rectangle.stack.badge.person.crop")
        case .appleevents: return Image(systemName: "apple.logo")
        case .contactsfull: return Image(systemName: "person.crop.circle.badge.checkmark")
        case .contactslimited: return Image(systemName: "person.crop.circle")
        case .developertool: return Image(systemName: "wrench.and.screwdriver")
        case .facebook: return Image("facebook")
        case .linkedin: return Image("linkedin")
        case .location: return Image(systemName: "location")
        case .medialibrary: return Image(systemName: "popcorn")
        case .motion: return Image(systemName: "figure.walk.motion")
        case .reminders: return Image(systemName: "checklist")
        case .sharekit: return Image(systemName: "square.and.arrow.up")
        case .siri: return Image(systemName: "waveform")
        case .speechrecognition: return Image(systemName: "waveform")
        case .twitter: return Image("twitter")
        default: return Image(systemName: "gearshape")
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
            }
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
