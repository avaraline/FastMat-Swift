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

    public func length() -> Fixed {
        0
    }

    public func normalize(_ terms: Int = 3) -> Fixed {
        0
    }
}
