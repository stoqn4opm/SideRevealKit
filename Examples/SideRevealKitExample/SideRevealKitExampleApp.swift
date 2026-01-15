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
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isRevealed.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var sideContent: some View {
        Form {
            Text("One")
            Text("Two")
            Text("Three")
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .frame(width: 300)
        .cornerRadius(24)
        .glassEffect(.clear.interactive(),
                     in: RoundedRectangle(cornerRadius: 24))
        .padding(.vertical, 50)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(alignment: .leading) {
            Button("", systemImage: "gear") {
                isRevealed.toggle()
            }
            .padding()
            Form {
                Text("One")
                Text("Two")
                Text("Three")
            }
            .scrollContentBackground(.hidden)
        }
        .background(.green)
    }
}
