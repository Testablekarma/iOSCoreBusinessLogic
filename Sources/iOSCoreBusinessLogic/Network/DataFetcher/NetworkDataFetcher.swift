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
    
    public override func fetchAsync(request: URLRequest) async throws -> Result<T, NetworkHttpService.Errors> {
        let result = try await fetchA(request: request)
        
        switch result {
        case let .success(object):
            return .success(object)
        case let .failure(error):
            if let networkError = error as? NetworkHttpService.Errors {
                return .failure(networkError)
            } else {
                throw error
            }
        }
    }
}

private extension NetworkDataFetcher {
    func fetchA(request: URLRequest) async throws -> Result<T, Error> {
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
        
        return await task.result
    }
}
