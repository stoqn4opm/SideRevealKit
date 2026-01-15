/// SideRevealKit
///
/// A lightweight SwiftUI component for revealing a side panel over main content from either the leading or trailing edge.
/// Use `SideRevealView` to overlay side content that can be shown/hidden via a published `Bool`.

import SwiftUI
import Combine

/// The direction from which the side content is revealed.
public enum RevealDirection {
    /// Reveal from the leading edge (left in left-to-right locales).
    case leading
    /// Reveal from the trailing edge (right in left-to-right locales).
    case trailing
    
    /// Maps the reveal direction to an `Alignment` used for the overlay.
    var alignment: Alignment {
        switch self {
        case .leading:
            .leading
        case .trailing:
            .trailing
        }
    }
}

/// A view that overlays side content on top of main content and reveals it from a specified edge.
///
/// Provide `sideContent` and `mainContent` views. Control visibility by supplying an `isRevealed` value
/// or a publisher of `Bool` values. The side view slides in/out while the main content remains visible beneath.
///
/// Example:
/// ```swift
/// SideRevealView(
///     sideContent: { SideMenu() },
///     mainContent: { ContentView() },
///     isRevealed: true
/// )
/// ```
public struct SideRevealView<SideContentView: View, MainContentView: View>: View {
    
    private let sideContent: () -> SideContentView
    private let mainContent: () -> MainContentView
    private let revealDirection: RevealDirection
    private let revealAnimation: Animation
    
    @ObservedObject private var viewModel: SideRevealViewModel
    @State private var sideSize: CGSize = .zero

    /// Creates a side reveal view with concrete side and main views and a publisher controlling reveal state.
    /// - Parameters:
    ///   - sideContent: The side content view instance to overlay and reveal.
    ///   - mainContent: The main content view instance displayed beneath the side content.
    ///   - revealDirection: The edge from which the side content is revealed. Defaults to `.leading`.
    ///   - revealAnimation: The animation used when revealing or hiding the side content. Defaults to `.smooth`.
    ///   - isRevealedPublisher: A publisher that emits the reveal state. Defaults to a publisher that emits `true`.
    public init(sideContent: SideContentView,
                mainContent: MainContentView,
                revealDirection: RevealDirection = .leading,
                revealAnimation: Animation = .smooth,
                isRevealedPublisher: any Publisher<Bool, Never> = Just(true)) {
        self.sideContent = { sideContent }
        self.mainContent = { mainContent }
        self.revealDirection = revealDirection
        self.revealAnimation = revealAnimation
        self.viewModel = .init(isRevealedPublisher: isRevealedPublisher)
    }
    
    /// Creates a side reveal view using view builders and a fixed initial reveal state.
    /// - Parameters:
    ///   - sideContent: A builder that returns the side content to overlay and reveal.
    ///   - mainContent: A builder that returns the main content displayed beneath the side content.
    ///   - revealDirection: The edge from which the side content is revealed. Defaults to `.leading`.
    ///   - revealAnimation: The animation used when revealing or hiding the side content. Defaults to `.smooth`.
    ///   - isRevealed: The initial reveal state.
    public init(@ViewBuilder sideContent: @escaping () -> SideContentView,
                @ViewBuilder mainContent: @escaping () -> MainContentView,
                revealDirection: RevealDirection = .leading,
                revealAnimation: Animation = .smooth,
                isRevealed: Bool) {
        self.sideContent = sideContent
        self.mainContent = mainContent
        self.revealDirection = revealDirection
        self.revealAnimation = revealAnimation
        self.viewModel = .init(isRevealedPublisher: Just(isRevealed))
    }
    
    public var body: some View {
        mainContent()
            .overlay(alignment: revealDirection.alignment) {
                sideContent()
                    .readSize(into: $sideSize)
                    .offset(x: viewModel.isRevealed ? 0 : closedOffsetX(for: revealDirection.alignment, sideWidth: sideSize.width))
                    .animation(revealAnimation, value: viewModel.isRevealed)
            }
    }
    
    private func closedOffsetX(for alignment: Alignment, sideWidth: CGFloat) -> CGFloat {
        // Place the side content exactly outside the visible edge of the main content.
        // Because the overlay is aligned to the main content, offsetting by the side’s own width
        // puts it just off-screen, regardless of how wide the main content is.
        if alignment == .leading {
            return -sideWidth
        }
        if alignment == .trailing {
            return sideWidth
        }
        // Fallback for other alignments.
        return 0
    }
}
