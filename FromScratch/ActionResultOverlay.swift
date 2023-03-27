//
//  ActionResultOverlay.swift
//  FromScratch
//
//  Created by Pierre Tacchi on 2023-03-27.
//

import SwiftUI
import Combine

struct ActionResultOverlayModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .font(.headline)
            .padding(12)
            .background(in: RoundedRectangle(cornerRadius: 8))
            .overlay { RoundedRectangle(cornerRadius: 8).strokeBorder(.separator) }
            .width(320)
            .backgroundStyle(.thinMaterial)
            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
    }
}

struct SuccessfulAction: View {
    let message: Text
    let image: Image?
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "checkmark.circle").foregroundColor(.green)
                message
            }
            Spacer()
            image
        }
        .modifier(ActionResultOverlayModifier())
    }
}

struct FailedAction: View {
    let message: Text
    let image: Image?
    
    var body: some View {
        HStack {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "xmark.circle").foregroundColor(.red)
                message
            }
            Spacer()
            image
        }.modifier(ActionResultOverlayModifier())
    }
}

struct ActionResultOverlay: View {
    private final class Coordinator: ObservableObject {
        enum Entry: Identifiable, Equatable, View {
            case success(String, Text, Image?), fail(String, Text, Image?)
            
            var id: String {
                switch self {
                case .success(let id, _, _): return "1" + id
                case .fail(let id, _, _): return "2" + id
                }
            }
            
            static func ==(lhs: Self, rhs: Self) -> Bool {
                switch (lhs, rhs) {
                case (.success(let lid, _, _), .success(let rid, _, _)): return lid == rid
                case (.fail(let lid, _, _), .fail(let rid, _, _)): return lid == rid
                default: return false
                }
            }
            
            var body: some View {
                switch self {
                case .success(_, let m, let img): SuccessfulAction(message: m, image: img)
                case .fail(_, let m, let img): FailedAction(message: m, image: img)
                }
            }
        }
        
        static let shared = Coordinator()
        
        @Published var stack: [Entry]
        var appendSignal = false
        var dismissSignal = false
        
        private var dismissers: [String: AnyCancellable]
        
        private init() {
            self.stack = []
            self.dismissers = [:]
        }
        
        func append(_ entry: Entry) {
            if !stack.contains(entry) { stack.append(entry) }
            scheduleDismiss(for: entry.id)
            appendSignal.toggle()
        }
        
        private func dismiss(_ id: String) {
            if let i = stack.firstIndex(where: \.id, equalTo: id) {
                stack.remove(at: i)
                dismissers.removeValue(forKey: id)
                dismissSignal.toggle()
            }
        }
        
        private func scheduleDismiss(for id: String) {
            dismissers[id] = Just(())
                .delay(for: .milliseconds(3200), scheduler: RunLoop.main)
                .sink { [weak self] in self?.dismiss(id) }
        }
    }
    
    @StateObject private var coordinator = Coordinator.shared
    
    var body: some View {
        VStack {
            ForEach(coordinator.stack) { $0 }
        }
        .padding(.bottom, 16)
        .expand(alignment: .bottom)
        .clipped()
        .compositingGroup()
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
        .animation(.interactiveSpring(), value: coordinator.appendSignal)
        .animation(.easeIn(duration: 0.8), value: coordinator.dismissSignal)
    }
    
    static func postSuccessfulResult(id: String, message: Text, image: Image?) {
        Coordinator.shared.append(.success(id, message, image))
    }
    
    static func postFailedResult(id: String, message: Text, image: Image?) {
        Coordinator.shared.append(.fail(id, message, image))
    }
}
