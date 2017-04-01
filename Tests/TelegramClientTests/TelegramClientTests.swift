import XCTest
@testable import TelegramClient

class TelegramClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(TelegramClient().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
