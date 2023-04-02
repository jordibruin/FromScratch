//
//  RunningAppRow.swift
//  FromScratch
//
//  Created by Pierre Tacchi on 2023-03-27.
//

import SwiftUI

struct RunningAppRow: View {
    let app: NSRunningApplication
    
    private var iconImage: Image {
        app.icon.map(Image.init(nsImage: )) ?? Image(systemName: "app.dashed")
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            iconImage
                .resizable()
                .frame(square: 32)
                .alignmentGuide(.firstTextBaseline) { $0[.bottom] * 0.67 }
            Text(app.localizedName!).font(.title2) // it's been filtered so it's not nil.
            Spacer()
            Menu("Reset") {
                ForEach(Permission.common) { $0.button(for: app) }
                Divider()
                Menu("Social") {
                    ForEach(Permission.social) { $0.button(for: app) }
                }
                Menu("System Policy") {
                    ForEach(Permission.systemPolicy) { $0.button(for: app) }
                }
                Menu("Other") {
                    ForEach(Permission.other) { $0.button(for: app) }
                }
                Divider()
                Permission.all.button(for: app)
            }
            .menuStyle(.borderedButton)
            .labelStyle(.titleAndIcon)
            .fixedWidth()
        }
    }
}
