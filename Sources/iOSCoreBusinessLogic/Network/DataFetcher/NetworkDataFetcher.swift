import Foundation
import Combine

open class NetworkDataFetcher<T: Decodable>: DataFetcher<T, NetworkHttpService.Errors> {

    private let httpService: HttpService
    private lazy var errorTransformer = NetworkErrorTransformer()
    private lazy var decoder = Decoder<T>()

    public init(httpService: HttpService) {
        self.httpService = httpService
    }

    public override func fetch(request: URLRequest) -> AnyPublisher<T, NetworkHttpService.Errors>  {
        httpService.performRequest(request)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { self.errorTransformer.transform(error: $0) }
            .eraseToAnyPublisher()
    }
    
    public override func fetch(request: URLRequest) throws -> T {
        
        Task {
            try await fetchAsync(request: request)
        } as! T
    }
}

private extension NetworkDataFetcher {
    func fetchAsync(request: URLRequest) async throws -> T {
        let task = Task { () -> T in
            do {
                let requestResult = try await httpService.performAsyncRequest(request)
                
                switch requestResult {
                case let .success(data):
                    return try decoder.decode(data: data)
                    
                case let .failure(error):
                    throw error
                }
            } catch {
                throw NetworkHttpService.Errors.unknown
            }
        }
        
        return try await task.value
    }
}
