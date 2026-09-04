// swift-tools-version: 5.10
//
// A throwaway package that consumes the SDK exactly as a customer does: by
// Swift Package Manager, from this repository's Git URL, at a released tag.
// It deliberately does not reference the local checkout -- the point is to
// prove the published package resolves and links, not that the xcframework
// exists on disk.
import PackageDescription

let package = Package(
    name: "ConsumerSmokeTest",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ConsumerSmokeTest", targets: ["ConsumerSmokeTest"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/insurely/insurely-sdk-ios-distribution.git",
            exact: "__VERSION__"
        )
    ],
    targets: [
        .target(
            name: "ConsumerSmokeTest",
            dependencies: [
                .product(name: "InsurelySDK", package: "insurely-sdk-ios-distribution")
            ]
        )
    ]
)
