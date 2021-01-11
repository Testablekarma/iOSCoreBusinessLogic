import Foundation

public protocol URLRequestTransformer {
    func transform(urlRequest: URLRequest) throws -> URLRequest
}
