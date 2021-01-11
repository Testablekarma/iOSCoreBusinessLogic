import Foundation
import Combine

public protocol HttpService {
    func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkHttpService.Errors>
}
