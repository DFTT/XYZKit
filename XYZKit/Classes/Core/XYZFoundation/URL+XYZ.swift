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

    init?(string: String, queryItems: [String: String]) {
        guard var comps = URLComponents(string: string) else { return nil }
        if queryItems.isEmpty == false {
            let newItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            var items = comps.queryItems ?? []
            items.append(contentsOf: newItems)
            comps.queryItems = items
        }
        guard let url = comps.url else { return nil }
        self = url
    }
}
