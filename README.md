# IPCPipe

This framework allows us to communicate the TestsBundle with the App in order to interchange some data.
It is based on the [eDistantObject](https://github.com/google/eDistantObject) interprocess communication framework, and provides a simple abstraction to exchange Codable data structures.


## How to use

This framework requires the implementation of two components, one in the App Bundle (Host) and other in the Tests Bundle (Client).

For the App:

```swift
    let pipeHost = PipeHost<HostDataStructure>(1111) { (data: HostDataStructure) in print("PipeHost called! \(data)") }
    ...

    struct HostDataStructure: Codable {
        var data: String
        enum CodingKeys: String, CodingKey {
            case data = "data"
        }
    }
```

For the Tests:

```swift
    let pipeClient = PipeClient<ClientDataStructure>(1111)
    pipeClient.send(ClientDataStructure(data: "Hello"))
    ...

    struct ClientDataStructure: Codable {
        var data: String
        enum CodingKeys: String, CodingKey {
            case data = "data"
        }
    }
```

Note that the data structure is transformed into JSON before sending it, so there is no need to share the same Codable between bundles, just that both Codables match with the required JSON keys.
