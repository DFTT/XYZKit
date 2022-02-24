//
//  URL+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/2/16.
//

import Foundation

public extension URL {
    var queryItemsKVMap: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return [:]
        }
        return queryItems.reduce(into: [String: String]()) { res, item in
            res[item.name] = item.value
        }
    }
}
