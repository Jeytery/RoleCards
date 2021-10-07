//
//  Lums.swift
//  RoleCards
//
//  Created by Jeytery on 06.10.2021.
//

import UIKit

class Luma {
    static func forColor(_ color: UIColor) -> CGFloat {
        let red = CIColor(color: color).red
        let green = CIColor(color: color).green
        let blue = CIColor(color: color).blue
        let luma = ((0.2126 * red) + (0.7152 * green) + (0.0722 * blue))
        return luma
    }
    
    static func blackOrWhite(_ color: UIColor) -> UIColor {
        if Luma.forColor(color) > 0.6 { return .black }
        return .white
    }
}
