import Foundation
import Combine

open class DataFetcher<T: Decodable, U: Error> {
    func fetch(request: URLRequest) -> AnyPublisher<T, U> {
        fatalError("No logic should be implemented.")
    }
}
