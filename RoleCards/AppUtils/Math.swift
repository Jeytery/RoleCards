//
//  Math.swift
//  RoleCards
//
//  Created by Jeytery on 22.02.2022.
//

import Foundation
import UIKit

class Math {
    static func mapDiaposons<Type: FloatingPoint>(
        value: Type ,
        from diaposonA: ClosedRange<Type>,
        to diaposonB: ClosedRange<Type>
    ) -> Type {
        return (value - diaposonA.upperBound) / (diaposonA.lowerBound - diaposonA.upperBound) * (diaposonB.lowerBound - diaposonB.upperBound) + diaposonB.upperBound
    }
    
    static func getRadian(degree: CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180
    }
}
