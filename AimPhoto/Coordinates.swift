//
//  Coordinates.swift
//

import Foundation

class Coordinates: CustomStringConvertible {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var imageX: CGFloat = 0
    var imageY: CGFloat = 0
    var description: String {
        """
        x: \(x), y: \(y)
        x0: \(x - imageX), y0: \(y - imageY)
        """
    }
}
