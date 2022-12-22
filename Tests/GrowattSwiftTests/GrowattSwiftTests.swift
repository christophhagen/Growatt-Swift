import XCTest
@testable import GrowattSwift

final class Growatt_SwiftTests: XCTestCase {

    func testExample() async throws {
        let client = try GrowattClient(path: "/dev/ttyUSB0")
        let config = try await client.readConfiguration()
        print(config)
    }
}
