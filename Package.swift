// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "InsurelySDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "InsurelySDK",
            targets: ["InsurelySDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "InsurelySDK",
            path: "InsurelySDK.xcframework"
        )
    ]
)
