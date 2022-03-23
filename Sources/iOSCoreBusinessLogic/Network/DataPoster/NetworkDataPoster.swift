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
    
    public override func postAsync(request: URLRequest, body: E) async throws -> Result<T, NetworkHttpService.Errors> {
        let postRequest = try postingUrlRequestTransformer.transform(urlRequest: request, body: body)
        let result = try await postAsync(request: postRequest)
        
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

private extension NetworkDataPoster {
    func postAsync(request: URLRequest) async throws -> Result<T, Error> {
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
