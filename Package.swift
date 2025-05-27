// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TimePickerKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "TimePickerKit",
            targets: ["TimePickerKit"]),
    ],
    targets: [
        .target(
            name: "TimePickerKit",
            dependencies: [],
            path: "Sources/TimePickerKit"
        ),
        .testTarget(
            name: "TimePickerKitTests",
            dependencies: ["TimePickerKit"],
            path: "Tests/TimePickerKitTests"
        ),
    ]
)
