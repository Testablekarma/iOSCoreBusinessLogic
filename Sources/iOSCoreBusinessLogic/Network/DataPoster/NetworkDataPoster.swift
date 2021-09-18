import Foundation
import Combine

open class NetworkDataPoster<T: Decodable, E: Encodable>: DataPoster<T, E, NetworkHttpService.Errors> {
    
    private let httpService: HttpService
    private lazy var errorTransformer = NetworkErrorTransformer()
    private let postingUrlRequestTransformer = JSONPostingURLRequestTransformer<E>()

    public init(httpService: HttpService) {
        self.httpService = httpService
    }

    public override func post(request: URLRequest, body: E) -> AnyPublisher<T, NetworkHttpService.Errors>  {
        do {
            let request = try postingUrlRequestTransformer.transform(urlRequest: request, body: body)
            
            return httpService.performRequest(request)
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { self.errorTransformer.transform(error: $0) }
                .eraseToAnyPublisher()
        } catch {
            return Result.Publisher(.encodingError).eraseToAnyPublisher()
        }
    }
}
