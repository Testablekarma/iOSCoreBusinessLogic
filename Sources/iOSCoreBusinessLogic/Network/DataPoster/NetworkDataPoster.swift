import Foundation
import Combine

open class NetworkDataPoster<T: Decodable, E: Encodable>: DataPoster<T, E, NetworkHttpService.Errors> {
    
    private let httpService: HttpService
    private lazy var errorTransformer = NetworkErrorTransformer()
    private lazy var decoder = Decoder<T>()
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
    
    public override func post(request: URLRequest, body: E) throws -> T {
                
        Task { () -> T in
            let postRequest = try postingUrlRequestTransformer.transform(urlRequest: request, body: body)
            return try await postAsync(request: postRequest)
        } as! T
    }

}

private extension NetworkDataPoster {
    func postAsync(request: URLRequest) async throws -> T {
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
