//
//  Array+Extensions.swift
//  ImageFeed
//
//  Created by Anastasiia Ki on 26.10.2024.
//

import Foundation

extension Array {
    func withReplaced(itemAt: Int, newValue: Element) -> [Element] {
        var array = self
        array[itemAt] = newValue
        return array
    }
}
