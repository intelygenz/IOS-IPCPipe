import Foundation
import eDistantObject

class IPCHost {
    private let queue = DispatchQueue(label: "IPCHost")
    private let rootObject: RootObject
    private let service: EDOHostService
    
    init(_ port: Int, _ onSent: @escaping (String) -> String) {
        self.rootObject = RootObject(onSent)
        self.service = EDOHostService(port: UInt16(port), rootObject: self.rootObject, queue: queue)
        print("EDOService is valid: \(self.service.isValid). Listening on port \(self.service.port.port)")
    }
    
    func release() {
        service.invalidate()
    }
    
    @objc
    class HostPipe: NSObject, Pipe {
        private let onSent: (String) -> String
        init(_ onSent: @escaping (String) -> String) { self.onSent = onSent}
        func sendThroughPipe(_ value: String) -> String { onSent(value) }
    }
    
    @objc
    class RootObject: NSObject, PipeConnector {
        private let onSent: (String) -> String
        init(_ onSent: @escaping (String) -> String) { self.onSent = onSent}
        func pipe() -> Pipe { IPCHost.HostPipe(onSent) }
    }
    
}


