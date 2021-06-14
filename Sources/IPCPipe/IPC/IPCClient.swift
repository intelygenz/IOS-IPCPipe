import Foundation
import eDistantObject

class IPCClient {
    private let pipe: Pipe
    init(_ port: Int) {
        let rootObject = EDOClientService<PipeConnector>.rootObject(withPort: UInt16(port))
        self.pipe = rootObject.pipe()

    }
    
    func sendThrowPipe(_ value: String) -> String { pipe.sendThroughPipe(value) }
}
