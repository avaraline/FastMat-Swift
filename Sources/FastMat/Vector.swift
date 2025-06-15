//
//  Vector.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

import Foundation

public typealias Vector = SIMD4<Fixed>

extension Vector {
    /// Convenience initializer for creating a Vector from a set of 3 floats.
    /// - Parameters:
    ///   - v: an array of 3 Floats
    ///   - w: an optional w param, defaults to `FIX1`
    public init(_ v: [Float], w: Fixed = FIX1) {
        self.init(
            ToFixed(v[0]),
            ToFixed(v[1]),
            ToFixed(v[2]),
            w
        )
    }

    public func length(_ terms: Int = 3) -> Fixed {
        var acc = SquareAccumulator()
        for i in 0..<terms {
            acc.accumulate(self[i])
        }
        return acc.squareRoot()
    }

    public mutating func normalize(_ terms: Int = 3) -> Fixed {
        let l = self.length(terms)
        for i in 0..<terms {
            self[i] = FDiv(self[i], l)
        }
        return l
    }

    func spaceAngle(_ heading: inout Fixed, _ pitch: inout Fixed) {
        var sideLen: Fixed
        let headingA = FOneArcTan2(self[2], self[0])

        if ((headingA - 0x0000_2000) & 0x0000_4000) != 0 {
            sideLen = FDiv(self[2], FOneCos(headingA))
        } else {
            sideLen = FDiv(self[0], FOneSin(headingA))
        }

        heading = headingA
        pitch = FOneArcTan2(sideLen, -self[1])
    }

}
