import Foundation

public protocol URLRequestTransformer {
    func transform(urlRequest: URLRequest) throws -> URLRequest
}

// This has to be a class as protocols do not allow for generic values
open class PostingURLRequestTransformer<E: Encodable> {
    func transform(urlRequest: URLRequest, body: E) throws -> URLRequest {
        fatalError("This should be subclassed")
    }
}
