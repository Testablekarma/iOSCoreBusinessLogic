import Foundation
import Combine

protocol HttpService {
    func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkHttpService.Errors>
}
