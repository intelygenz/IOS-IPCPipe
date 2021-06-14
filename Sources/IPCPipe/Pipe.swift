import Foundation

public class PipeHost<C: Decodable> {
    private let host: InteractivePipeHost<C, String>
    public init(_ port: Int, _ onSubscribe: @escaping (C) throws -> Void) {
        self.host = InteractivePipeHost(port) { try onSubscribe($0); return "" }
    }
}

public class InteractivePipeHost<C: Decodable, H: Encodable> {
    private let host: InnerPipeHost
    public init(_ port: Int, _ onSubscribe: @escaping (C) throws -> H) {
        self.host = InnerPipeHost(port) { cPackage in try HPackage(data: Serializer.from(onSubscribe(Serializer.to(cPackage.data))), error: nil) }
    }
    
    class InnerPipeHost {
        private let host: IPCHost
        init(_ port: Int, _ onSubscribe: @escaping (CPackage) throws -> HPackage) {
            self.host = IPCHost(port) {
                do {
                    return try Serializer.from(onSubscribe(Serializer.to($0)))
                } catch {
                    return "{ \"error\": \"\(error.serialized)\" }"
                }
            }
        }
    }
}

public class PipeClient<C: Encodable> {
    private let client: InteractivePipeClient<C, String>
    public init(_ port: Int) { self.client = InteractivePipeClient(port) }
    public func send(_ data: C) throws { _ = try client.send(data)}
}

public class InteractivePipeClient<C: Encodable, H: Decodable> {
    private let client: InnerPipeClient
    public init(_ port: Int) { self.client = InnerPipeClient(port) }
    
    public func send(_ data: C) throws -> H {
        let hPackage = try client.send(CPackage(data: Serializer.from(data)))
        return try Serializer.to(hPackage.data!)
    }
    
    class InnerPipeClient {
        private let client: IPCClient
        init(_ port: Int) { self.client = IPCClient(port) }
        func send(_ cPackage: CPackage) throws -> HPackage {
            let hPackage: HPackage = try Serializer.to(client.sendThrowPipe(Serializer.from(cPackage)))
            guard let _ = hPackage.data else { throw IPCClientError.value(of: hPackage.error ?? "Not received data" )}
            return hPackage
        }
    }
}
