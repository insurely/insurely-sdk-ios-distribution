# Insurely iOS SDK

The Insurely iOS SDK lets you embed the Insurely user interface in your iOS app. The SDK loads the Insurely web experience in a `WKWebView` and exposes a SwiftUI `InsurelyView` plus a small surface of configuration, prefill, and callback APIs.

## Requirements

- iOS 15.0 or later
- Xcode 15.0 or later
- Swift 5.10 or later

Access to this repository is granted to authorized Insurely customers. Use of the SDK is governed by the terms of your agreement with Insurely AB. See `LICENSE` for details.

## Access

This SDK is distributed via a private GitHub repository. Anyone who needs to integrate, build against, or resolve the SDK as a Swift Package Manager dependency requires read access to this repository.

### For developers

Send the GitHub usernames of every developer who will integrate the SDK to your Insurely account representative. We will grant each account read access to this repository. Once invited, accept the invitation by email and the SPM dependency will resolve normally when their machine has SSH credentials configured for GitHub.

### For CI/CD systems

CI machines (GitHub Actions, Bitrise, CircleCI, Xcode Cloud, etc.) also need to resolve the package. The recommended pattern is a per-CI **deploy key** — a read-only SSH key tied to the CI infrastructure rather than to any individual developer's account.

1. Generate an SSH keypair on your CI host.
2. Send the **public** key to your Insurely account representative.
3. We will install it as a deploy key on this repository.

This keeps personal developer credentials out of CI configuration and gives you clean access control if a CI service ever needs to be rotated or revoked.

## Installation

The SDK can be installed three ways. All produce an identical, signed binary in your app — they differ only in how the framework reaches your project. Pick the one that fits your team's environment.

### Swift Package Manager (remote)

Best when GitHub is reachable at build time and you want Swift Package Manager to manage version updates.

In Xcode:

1. **File → Add Package Dependencies…**
2. Paste the repository URL:
   ```
   git@github.com:insurely/insurely-sdk-ios-distribution.git
   ```
3. Set the dependency rule to **Exact Version** and enter the version you want, or **Up to Next Major Version** from the same starting version to receive non-breaking updates automatically.
4. Add the `InsurelySDK` library to your app target's **Frameworks, Libraries, and Embedded Content**, with **Embed & Sign** selected.

For projects that use a `Package.swift` manifest:

```swift
.package(
    url: "git@github.com:insurely/insurely-sdk-ios-distribution.git",
    from: "1.2.0"
)
```

And add `"InsurelySDK"` as a dependency of the relevant target.

### Swift Package Manager (local clone)

Best when you want to vendor the SDK in your repository for reproducibility, build in air-gapped CI, or pin to a specific commit without going through GitHub at build time.

1. Clone this repository to a stable location in or alongside your project:
   ```
   git clone git@github.com:insurely/insurely-sdk-ios-distribution.git
   ```
2. In Xcode: **File → Add Package Dependencies… → Add Local…**, and select the cloned directory.
3. Add `InsurelySDK` to your app target's **Frameworks, Libraries, and Embedded Content**, with **Embed & Sign** selected.

Swift Package Manager still handles linking and embedding; the source is just resolved from your local clone instead of GitHub. To update, run `git pull` in the clone (or `git checkout <version-tag>` to pin to an exact version).

### Manual framework integration

Best when you do not use Swift Package Manager.

1. Download `InsurelySDK.xcframework.zip` from the [latest GitHub Release](https://github.com/insurely/insurely-sdk-ios-distribution/releases).
2. Unzip and drag `InsurelySDK.xcframework` into your Xcode project.
3. In the target's **General → Frameworks, Libraries, and Embedded Content**, set **Embed & Sign**.

Version tracking and update notifications are entirely manual with this method.

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
