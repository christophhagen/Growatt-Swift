// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Growatt-Swift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "GrowattSwift",
            targets: ["GrowattSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jollyjinx/SwiftLibModbus", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "GrowattSwift",
            dependencies: ["SwiftLibModbus"]),
        .testTarget(
            name: "GrowattSwiftTests",
            dependencies: ["GrowattSwift"]),
    ]
)
