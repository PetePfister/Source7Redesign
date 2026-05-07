// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Source7",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Source7",
            path: "Sources/Source7"
        )
    ]
)
