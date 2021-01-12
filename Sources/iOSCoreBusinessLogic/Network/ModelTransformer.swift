import Foundation

open class ModelTransformer<D: Decodable, M> {
    open func transform(dto: D) -> M {
        fatalError("Should be subclassed")
    }
}
