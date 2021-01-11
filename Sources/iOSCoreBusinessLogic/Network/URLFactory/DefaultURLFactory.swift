import Foundation

open class DefaultURLFactory: URLFactory {

    private let hostname: String
    
    public init(hostname: String) {
        self.hostname = hostname
    }
    
    public func makeURL(appending path: String) -> URL {
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Can't encode path")
        }

        let urlString = hostname + encodedPath

        guard let url = URL(string: urlString) else {
            fatalError("Can't transform URLString to URL")
        }

        return url
    }
}
