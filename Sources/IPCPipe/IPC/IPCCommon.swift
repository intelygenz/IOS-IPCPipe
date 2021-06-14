import Foundation

@objc
public protocol Pipe {
    func sendThroughPipe(_ value: String) -> String
}

@objc
public protocol PipeConnector {
  func pipe() -> Pipe
}
