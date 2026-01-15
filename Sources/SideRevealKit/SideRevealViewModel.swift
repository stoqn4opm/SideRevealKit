//
//  SideRevealViewModel.swift
//  SideRevealKit
//
//  Created by stoyan on 14.01.26.
//

import SwiftUI
import Combine

// MARK: - Combine View Model Definition

final class SideRevealViewModel: ObservableObject {
    
    @Published private(set) var isRevealed: Bool = false
    
    private var cancellable: AnyCancellable?
    
    init(isRevealedPublisher: some Publisher<Bool, Never>) {
        
        cancellable = isRevealedPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isRevealed in
            self?.isRevealed = isRevealed
        })
    }
}
