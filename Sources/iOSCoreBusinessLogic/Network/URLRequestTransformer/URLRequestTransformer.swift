import Foundation

protocol URLRequestTransformer {
    func transform(urlRequest: URLRequest) throws -> URLRequest
}
