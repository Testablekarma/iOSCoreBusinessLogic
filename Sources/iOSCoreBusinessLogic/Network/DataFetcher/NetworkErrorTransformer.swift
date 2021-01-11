import Foundation

open class NetworkErrorTransformer: ErrorTransformer<NetworkHttpService.Errors> {
    
    public override init() {}
    
    override func transform(error: Error) -> NetworkHttpService.Errors {
        if let networkError = error as? NetworkHttpService.Errors {
            return networkError
        } else if error is DecodingError {
            return NetworkHttpService.Errors.decodingError
        }

        return .unknown
    }
}
