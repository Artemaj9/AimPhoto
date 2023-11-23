//
//  Coordinates.swift
//

import Foundation

class Coordinates: CustomStringConvertible {
    
    var block = false
    var x: CGFloat = 0
    var y: CGFloat = 0
    var imageX: CGFloat = 0
    var imageY: CGFloat = 0
    var description: String {
    """
    x: \(String(format: "%.1f", x)), y: \(String(format: "%.1f", y))
    x0: \(String(format: "%.1f", x - imageX)), y0: \(String(format: "%.1f", y - imageY))
    """
    }
}

