// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreatCircle",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "GreatCircle",
            targets: ["GreatCircle"]),
    ],
    dependencies: [
        // No dependencies!
    ],
    targets: [
        .target(
            name: "GreatCircle",
            dependencies: []),
        .testTarget(
            name: "GreatCircleTests",
            dependencies: ["GreatCircle"]),
    ]
)
