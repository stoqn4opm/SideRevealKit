import SwiftUI
import Combine

public enum RevealDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            .leading
        case .trailing:
            .trailing
        }
    }
}

public struct SideRevealView<SideContentView: View, MainContentView: View>: View {
    
    private let sideContent: () -> SideContentView
    private let mainContent: () -> MainContentView
    private let revealDirection: RevealDirection
    
    @ObservedObject private var viewModel: SideRevealViewModel
    @State private var sideSize: CGSize = .zero

    public init(sideContent: SideContentView,
                mainContent: MainContentView,
                revealDirection: RevealDirection = .leading,
                isRevealedPublisher: any Publisher<Bool, Never> = Just(true)) {
        self.sideContent = { sideContent }
        self.mainContent = { mainContent }
        self.revealDirection = revealDirection
        self.viewModel = .init(isRevealedPublisher: isRevealedPublisher)
    }
    
    public init(@ViewBuilder sideContent: @escaping () -> SideContentView,
                @ViewBuilder mainContent: @escaping () -> MainContentView,
                revealDirection: RevealDirection = .leading,
                isRevealed: Bool) {
        self.sideContent = sideContent
        self.mainContent = mainContent
        self.revealDirection = revealDirection
        self.viewModel = .init(isRevealedPublisher: Just(isRevealed))
    }
    
    public var body: some View {
        mainContent()
            .overlay(alignment: revealDirection.alignment) {
                sideContent()
                    .readSize(into: $sideSize)
                    .offset(x: viewModel.isRevealed ? 0 : closedOffsetX(for: revealDirection.alignment, sideWidth: sideSize.width))
                    .animation(.smooth, value: viewModel.isRevealed)
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
