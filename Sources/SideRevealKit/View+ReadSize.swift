//
//  View+ReadSize.swift
//  SideRevealKit
//
//  Created by stoyan on 14.01.26.
//

import SwiftUI

// MARK: - Size Reading

private struct _SizePreferenceKey: @MainActor PreferenceKey {
    @MainActor static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func readSize(into binding: Binding<CGSize>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: _SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(_SizePreferenceKey.self) { binding.wrappedValue = $0 }
    }
}
