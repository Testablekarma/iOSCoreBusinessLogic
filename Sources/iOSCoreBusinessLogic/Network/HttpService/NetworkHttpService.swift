import Foundation
import Combine

open class NetworkHttpService: HttpService {

    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func performRequest(_ request: URLRequest) -> AnyPublisher<Data, NetworkHttpService.Errors> {
        session.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { self.transformError(urlError: $0) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Handle response error.

public extension NetworkHttpService {

    private func transformError(urlError: URLError) -> Errors {

        switch urlError {
        case URLError.badServerResponse:
            return Errors.serverError
        case URLError.userAuthenticationRequired:
            return Errors.unauthorized
        case URLError.notConnectedToInternet:
            return Errors.noConnection
        case URLError.fileDoesNotExist:
            return Errors.doesNotExist
        default:
            return Errors.unknown
        }
    }

    private func errorForResponse(_ response: URLResponse?, _ data: Data?) -> Error? {

        guard let httpResponse = response as? HTTPURLResponse else {
            return Errors.emptyResponse
        }

        guard !StatusCodes.success.contains(httpResponse.statusCode) else {
            return nil
        }

        switch httpResponse.statusCode {
        case StatusCodes.unauthorized:
            return Errors.unauthorized
        case StatusCodes.serverError:
            return Errors.serverError
        default:
            return Errors.badResponseCode(code: httpResponse.statusCode, payload: data)
        }
    }
}

public extension NetworkHttpService {

    private struct StatusCodes {
        static let success = 200..<300
        static let unauthorized = 401
        static let serverError = 500
    }

    enum Errors: Error {
        case emptyResponse
        case badResponseCode(code: Int, payload: Data?)
        case unauthorized
        case serverError
        case noConnection
        case doesNotExist
        case unknown
        case decodingError
        case encodingError
    }
}
