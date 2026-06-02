# Insurely iOS SDK

The Insurely iOS SDK lets you embed the Insurely user interface in your iOS app. The SDK loads the Insurely web experience in a `WKWebView` and exposes a SwiftUI `InsurelyView` plus a small surface of configuration, prefill, and callback APIs.

## Requirements

- iOS 15.0 or later
- Xcode 15.0 or later
- Swift 5.10 or later

Access to this repository is granted to authorized Insurely customers. Use of the SDK is governed by the terms of your agreement with Insurely AB. See `LICENSE` for details.

## Installation

Add the SDK to your Xcode project as a Swift Package Manager dependency.

### Via Xcode

1. **File → Add Package Dependencies…**
2. Paste the repository URL:
   ```
   git@github.com:insurely/insurely-sdk-ios-distribution.git
   ```
3. Set the dependency rule to **Exact Version** and enter the version you want (e.g. `1.2.0`), or **Up to Next Major Version** from `1.2.0` to receive non-breaking updates automatically.
4. Add the `InsurelySDK` library to your app target's **Frameworks, Libraries, and Embedded Content**, with **Embed & Sign** selected.

### Via `Package.swift`

For projects that use a `Package.swift` manifest:

```swift
.package(
    url: "git@github.com:insurely/insurely-sdk-ios-distribution.git",
    from: "1.2.0"
)
```

And then add `"InsurelySDK"` as a dependency of the relevant target.

## Quickstart

The whole SDK is reached through one SwiftUI view, `InsurelyView`. A minimal integration:

```swift
import SwiftUI
import InsurelySDK

struct InsurelyScreen: View {
    var body: some View {
        InsurelyView(
            context: InsurelyContext(environment: .production),
            configuration: InsurelyConfiguration(
                customerId: "your-customer-id",
                configName: "your-config-name"
            )
        )
        .onInsurelyResults { results in
            // Handle the collected data when the flow completes.
            print(results.data)
        }
        .onInsurelyError { error in
            switch error {
            case .failedToOpenBankID:
                // Optionally surface a fallback UI.
                break
            @unknown default:
                break
            }
        }
    }
}
```

Insurely provides your `customerId` and `configName` during onboarding.

## Theme mode

The SDK supports light, dark, and system-driven theming via the optional `themeMode` parameter on `InsurelyConfiguration`:

```swift
InsurelyConfiguration(
    customerId: "...",
    configName: "...",
    themeMode: .system
)
```

- `.light` or `.dark` — render the corresponding theme variant unconditionally.
- `.system` — follow the host's color scheme via `prefers-color-scheme`.
- Omitted — the embedded web view is forced to a light color scheme. This preserves the SDK's pre-1.2.0 behavior so existing integrations see no change when upgrading.

Dark mode rendering requires your `BlocksConfig` to include at least one `ConnectedTheme`. With both `light` and `dark` identifiers configured server-side, passing `themeMode: .system` will follow the host's color scheme automatically. Contact your Insurely account representative if you need help setting up `ConnectedTheme` rows for your configuration.

## Versioning

The SDK follows [Semantic Versioning](https://semver.org/). Breaking changes happen only on major version bumps. Within a major version, you can safely use the `Up to Next Major Version` SPM requirement to receive new features and fixes automatically.

Release notes for each version are published on the [Releases page](https://github.com/insurely/insurely-sdk-ios-distribution/releases).

## Documentation

Each release attaches an `InsurelySDK.doccarchive` documentation bundle as a release asset. Download it from the [Releases page](https://github.com/insurely/insurely-sdk-ios-distribution/releases), double-click it, and Xcode will add it to its documentation browser (accessible via **Help → Developer Documentation** or `⌥`-click on any SDK symbol).

The bundle contains:

- A Getting Started guide covering setup, the Insurely View, theme modes, and Swedish BankID configuration.
- Full API reference for every public type, property, and callback modifier.

## Support

For integration questions, bug reports, or feature requests, contact your Insurely account representative.
