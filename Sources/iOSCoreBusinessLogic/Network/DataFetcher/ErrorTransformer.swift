import Foundation

open class ErrorTransformer<U: Error> {
    func transform(error: Error) -> U {
        fatalError("No logic should be implemented")
    }
}
