import Foundation
import Combine

open class RequestTransformingHttpService: HttpService {

    private let httpService: HttpService
    private let urlRequestTransformer: URLRequestTransformer

    init(httpService: HttpService, urlRequestTransformer: URLRequestTransformer) {

        self.httpService = httpService
        self.urlRequestTransformer = urlRequestTransformer
    }

    public func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkHttpService.Errors> {
        let urlRequest = try! urlRequestTransformer.transform(urlRequest: request)
        return httpService.performRequest(urlRequest)
    }
}
