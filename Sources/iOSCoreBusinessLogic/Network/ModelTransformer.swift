import Foundation

open class ModelTransformer<D: Decodable, M> {
    public init() {}
    open func transform(dto: D) -> M {
        fatalError("Should be subclassed")
    }
}
