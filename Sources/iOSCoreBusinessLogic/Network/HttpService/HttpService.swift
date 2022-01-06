import Foundation
import Combine

public protocol HttpService {
    func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkHttpService.Errors>
    func performAsyncRequest(_ request: URLRequest) async throws -> Result<Data, NetworkHttpService.Errors>
}
