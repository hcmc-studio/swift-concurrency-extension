// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConcurrencyExtension",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],
    products: [
        .library(
            name: "SwiftConcurrencyExtension",
            targets: ["SwiftConcurrencyExtension"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftConcurrencyExtension"
        ),
    ]
)
