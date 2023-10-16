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
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftConcurrencyExtension",
            targets: ["SwiftConcurrencyExtension"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftConcurrencyExtension"),
        .testTarget(
            name: "SwiftConcurrencyExtensionTests",
            dependencies: ["SwiftConcurrencyExtension"]),
    ]
)
