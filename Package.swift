// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FastMat",
    products: [
        .library(
            name: "FastMat",
            targets: ["FastMat", "CFastMat"]
        )
    ],
    targets: [
        .target(
            name: "CFastMat",
            sources: ["FastMat.c"]
        ),
        .target(
            name: "FastMat",
            dependencies: ["CFastMat"]
        ),
        .testTarget(
            name: "FastMatTests",
            dependencies: ["FastMat", "CFastMat"]
        ),
    ]
)
