//
//  File.swift
//  
//
//  Created by Mark Webb on 06/01/2022.
//

import Foundation

public class Decoder<T: Decodable> {
    
    public func decode(data: Data) throws -> T {
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch DecodingError.dataCorrupted {
            throw NetworkHttpService.Errors.decodingError(message: "dataCorrupted")
        } catch let DecodingError.keyNotFound(key, context) {
            let errorString = "Key '\(key)' not found: \(context.debugDescription)"
            throw NetworkHttpService.Errors.decodingError(message: errorString)
        } catch let DecodingError.valueNotFound(value, context) {
            let errorString = "Value '\(value)' not found: \(context.debugDescription)"
            throw NetworkHttpService.Errors.decodingError(message: errorString)
        } catch let DecodingError.typeMismatch(type, context)  {
            let errorString = "Type '\(type)' mismatch: \(context.debugDescription)"
            throw NetworkHttpService.Errors.decodingError(message: errorString)
        } catch {
            throw NetworkHttpService.Errors.decodingError(message: "Unknown")
        }
    }
    
}
