# SideRevealKit

A lightweight SwiftUI component for revealing a side panel over your main content from either the leading or trailing edge. Use `SideRevealView` to overlay side content that can be shown/hidden via a `Bool` or any `Publisher<Bool, Never>`.

![](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20visionOS-blue.svg)
![](https://img.shields.io/badge/language-Swift-brightgreen.svg)
![](https://img.shields.io/badge/UI-SwiftUI-orange.svg)

## What changed?

SideRevealKit has been rewritten from a UIKit container controller into a modern, minimal SwiftUI view. There are no view controller containers, segues, or storyboard setup steps anymore. Instead, you compose your UI with `SideRevealView` and control its reveal state with SwiftUI data flow.

- Old: `SideRevealViewController` with front/side child controllers and storyboard segues.
- New: `SideRevealView<SideContentView, MainContentView>` that overlays your side content on top of your main content.

## Features

- Reveal from `.leading` or `.trailing` via `RevealDirection`
- Drive visibility with a simple `Bool` or any Combine publisher
- Smooth, configurable animation
- Keeps your main content visible; side content slides over it
- Minimal API surface; bring your own UI and styling

## Quick start

```swift
import SwiftUI
import SideRevealKit

struct ContentView: View {
    @State private var isMenuOpen = false

    var body: some View {
        SideRevealView(
            sideContent: { SideMenu() },
            mainContent: {
                VStack {
                    Button("Toggle Menu") { isMenuOpen.toggle() }
                    // ... your main content
                }
            },
            revealDirection: .leading,
            revealAnimation: .smooth,
            isRevealed: isMenuOpen
        )
    }
}

struct SideMenu: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu").font(.largeTitle).padding(.bottom, 16)
            Button("Item 1") {}
            Button("Item 2") {}
            Spacer()
        }
        .frame(maxWidth: 280)
        .padding()
        .background(.ultraThinMaterial)
    }
}

```

# Installation

## Swift Package Manager

`SideRevealKit` is distributed via **Swift Package Manager**.

### Xcode (recommended)

1. Open your project in Xcode
2. Go to **File → Add Packages…**
3. Enter the package URL: `https://github.com/stoqn4opm/SideRevealKit.git`
4. Choose the desired version rule (e.g. *Up to Next Major*)
5. Add **SideRevealKit** to your target

Once added, you can import it in your SwiftUI views:

```swift
import SideRevealKit
```

### Package.swift

If you prefer to add it manually, include `SideRevealKit` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/stoqn4opm/SideRevealKit.git",
        from: "1.0.0"
    )
]
```

And then add it to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["SideRevealKit"]
)
```

# Licence

The framework is licensed under MIT licence. For more information see file `LICENCE`
