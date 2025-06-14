//
//  Squares.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

func FSqrt(_ n: Fixed) -> Fixed {
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

struct SquareAccumulator {
    var low: Int32 = 0
    var high: Int32 = 0

    mutating func accumulate(_ n: Fixed) {
        let wn = Int64(n) * Int64(n)
        let wacc = (Int64(high) << 32 | Int64(low)) + wn
        low = Int32(wacc & 0xFFFFFFFF)
        high = Int32(wacc >> 32)
    }

    mutating func subtract(_ n: Fixed) {
        let wn = Int64(n) * Int64(n)
        let wacc = (Int64(high) << 32 | Int64(low)) - wn
        low = Int32(wacc & 0xFFFFFFFF)
        high = Int32(wacc >> 32)
    }
}
