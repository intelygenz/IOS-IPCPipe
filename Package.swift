// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IPCPipe",
    products: [
        .library(
            name: "IPCPipe",
            targets: ["IPCPipe"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IPCPipe",
            dependencies: ["eDistantObject"]),
        .testTarget(
            name: "IPCPipeTests",
            dependencies: ["IPCPipe"]),
        .binaryTarget(
            name: "eDistantObject",
            path: "ThirdParty/eDistantObject.xcframework")
    ]
)
