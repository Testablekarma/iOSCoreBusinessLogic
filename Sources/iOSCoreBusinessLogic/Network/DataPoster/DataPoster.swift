import Foundation
import Combine

open class DataPoster<T: Decodable, E: Encodable, U: Error> {
    func post(request: URLRequest, body: E) -> AnyPublisher<T, U> {
        fatalError("No logic should be implemented.")
    }
}
