import Foundation

class Serializer {
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    
    static func from<T: Encodable>(_ value: T) throws -> String {
        guard let data = try? encoder.encode(value), let string = String(data: data, encoding: .utf8) else { throw IPCClientError.serializeError }
        return string
    }
    
    static func to<T: Decodable>(_ value: String) throws -> T {
        if T.self == String.self { return value as! T }
        guard let data = value.data(using: .utf8), let value: T = try? decoder.decode(T.self, from: data) else { throw IPCClientError.deserializeError }
        return value
    }
 
}

struct CPackage: Codable {
    let data: String
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct HPackage: Codable {
    let data: String?
    let error: String?
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case error = "error"
    }
}


enum IPCHostError:  Error {
    case alreadySubscribedToEvent
}

enum IPCClientError: Error {
    case deserializeError
    case serializeError
    case notSubscribedToEvent
    case undefined(_ message: String)
    static func values() -> [IPCClientError] { [.serializeError,.deserializeError, .notSubscribedToEvent] }
    static func value(of value: String) -> IPCClientError { values().first{ $0.serialized == value } ?? .undefined(value) }
}

extension Error {
    var serialized: String { (self as? IPCClientError)?.serialized ?? "\(self)"}
}

extension IPCClientError {
    var serialized: String {
        switch self {
        case .deserializeError: return "deserializeError"
        case .serializeError: return "serializeError"
        case .notSubscribedToEvent: return "notSubscribedToEvent"
        case .undefined(let message): return message
        }
    }
}
