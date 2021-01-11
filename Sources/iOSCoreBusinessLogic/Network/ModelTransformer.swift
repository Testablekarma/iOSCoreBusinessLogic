import Foundation

open class ModelTransformer<D: Decodable, M> {
    func transform(dto: D) -> M {
        fatalError("Should be subclassed")
    }
}
