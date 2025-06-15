//
//  Squares.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

public func FSqrt(_ n: Fixed) -> Fixed {
    // https://github.com/chmike/fpsqrt/blob/master/fpsqrt.c
    var r: UInt32 = UInt32(bitPattern: n)
    var b: UInt32 = 0x4000_0000
    var q: UInt32 = 0
    while b > 0x40 {
        let t = q + b
        if r >= t {
            r -= t
            q = t + b  // equivalent to q += 2*b
        }
        r <<= 1
        b >>= 1
    }
    q >>= 8
    return Fixed(bitPattern: q)
}

public struct SquareAccumulator {
    public var acc: Int64 = 0

    var accBits: UInt64 { UInt64(bitPattern: acc) }
    var lowBits: UInt32 { UInt32(accBits & 0xFFFF_FFFF) } // acc[1]
    var highBits: UInt32 { UInt32(accBits >> 32) } // acc[0]

    public mutating func accumulate(_ n: Fixed) {
        acc &+= Int64(n) * Int64(n)
    }

    public mutating func subtract(_ n: Fixed) {
        acc &-= Int64(n) * Int64(n)
    }

    public func squareRoot() -> Fixed {
        var root: Fixed = 0
        var remHi: UInt32 = 0
        var remLo = highBits
        var remLoLo = lowBits

        for _ in 0..<32 {
            /* get 2 bits of arg  */
            remHi = (remHi << 2) | (remLo >> 30)
            remLo = (remLo << 2) | (remLoLo >> 30)
            remLoLo <<= 2

            root <<= 1 /* Get ready for the next bit in the root */
            let testDiv = UInt32(bitPattern: ((root << 1) + 1)) /* Test divisor */
            if remHi >= testDiv {
                remHi -= testDiv
                root += 1
            }
        }

        return root
    }
}
