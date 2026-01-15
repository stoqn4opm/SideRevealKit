//
//  SideRevealKitExampleApp.swift
//  SideRevealKitExample
//
//  Created by stoyan on 14.01.26.
//

import SwiftUI
import SideRevealKit
import Combine

@main
struct SideRevealKitExampleApp: App {
    
    @State private var isRevealed: Bool = false
    
    var body: some Scene {
        WindowGroup {
            SideRevealView(
                sideContent: { sideContent },
                mainContent: { mainContent },
                isRevealed: isRevealed
            )
            .task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isRevealed.toggle()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isRevealed.toggle()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isRevealed.toggle()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isRevealed.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var sideContent: some View {
        Color.red.frame(width: 100, height: 300).overlay{ Text("Side") }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        Color.blue.frame(width: 200, height: 600).overlay{ Text("Front") }
    }
}
