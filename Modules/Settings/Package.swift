// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SettingsApp", targets: ["SettingsApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Dependencies", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "4.2.3")),
        
        .package(path: "../../Common")
    ],
    targets: [
       
        .target(
            name: "SettingsCore",
            path: "Sources/Core"
        ),
        
        .target(
            name: "SettingsUI",
            dependencies: [
                .product(name: "PulseUI", package: "Pulse"),
                .product(name: "CommonUI", package: "Common")
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "SettingsServices",
            dependencies: [
                .product(name: "Dependencies", package: "Dependencies"),
            ],
            path: "Sources/Services"
        ),
        
        .target(
            name: "SettingsApp",
            dependencies: [
                "SettingsCore", "SettingsUI", "SettingsServices",
                .product(name: "Redux", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies"),
                
                .product(name: "CommonUI", package: "Common"),
                .product(name: "CommonServices", package: "Common")
            ],
            path: "Sources/App"
        ),
            
        
        .testTarget(
            name: "SettingsTests",
            dependencies: ["SettingsApp"]
        )
    ]
)
