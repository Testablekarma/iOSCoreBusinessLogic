import Foundation
import Combine

open class NetworkDataFetcher<T: Decodable>: DataFetcher<T, NetworkHttpService.Errors> {

    private let httpService: HttpService
    private lazy var errorTransformer = NetworkErrorTransformer()

    public init(httpService: HttpService) {
        self.httpService = httpService
    }

    public override func fetch(request: URLRequest) -> AnyPublisher<T, NetworkHttpService.Errors>  {
        httpService.performRequest(request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { self.errorTransformer.transform(error: $0) }
            .eraseToAnyPublisher()
    }
}
