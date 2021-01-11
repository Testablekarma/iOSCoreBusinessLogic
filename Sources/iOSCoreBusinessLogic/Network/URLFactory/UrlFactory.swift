//
//  UrlFactory.swift
//  BitriseDashboard
//
//  Created by Mark Webb on 30/01/2020.
//  Copyright © 2020 BackflipMedia. All rights reserved.
//

import Foundation

public protocol URLFactory {
    func makeURL(appending path: String) -> URL
}
