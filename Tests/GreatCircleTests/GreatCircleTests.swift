import XCTest
@testable import GreatCircle

final class GreatCircleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GreatCircle().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
