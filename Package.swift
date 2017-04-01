// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "TelegramClient",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-Request.git", majorVersion: 0)
    ]
)
