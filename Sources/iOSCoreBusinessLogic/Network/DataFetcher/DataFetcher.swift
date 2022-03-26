import Foundation
import Combine

open class DataFetcher<T: Decodable, U: Error> {
    func fetch(request: URLRequest) -> AnyPublisher<T, U> {
        fatalError("No logic should be implemented.")
    }
    
    func fetchAsync(request: URLRequest) async throws -> Result<T, U> {
        fatalError("No logic should be implemented.")
    }
}
