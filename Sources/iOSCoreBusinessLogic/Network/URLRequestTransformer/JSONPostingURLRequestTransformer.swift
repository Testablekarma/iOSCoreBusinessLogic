import Foundation

public class JSONPostingURLRequestTransformer<E: Encodable>: PostingURLRequestTransformer<E> {
    
    override func transform(urlRequest: URLRequest, body: E) throws -> URLRequest {
        var request = urlRequest
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
}
