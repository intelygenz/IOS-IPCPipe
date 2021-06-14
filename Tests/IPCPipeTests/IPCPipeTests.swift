import XCTest
@testable import IPCPipe

final class IPCPipeTests: XCTestCase {
    
    func testCreateHost() {
        _ = PipeHost<MyCodable>(1111) { print($0) }
    }
    
    func testClientSend() throws {
        _ = PipeHost<MyCodable>(1111) { print($0) }
        let pipeClient = PipeClient<MyCodable>(1111)
        try pipeClient.send(MyCodable(message: "Hello world!"))
    }

    static var allTests = [
        ("testCreateHost", testCreateHost),
        ("testClientSend", testClientSend),
    ]
}

struct MyCodable: Codable {
    let message: String
}
