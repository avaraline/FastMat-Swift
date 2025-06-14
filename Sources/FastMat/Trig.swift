//
//  Trig.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

import Foundation

let ARCUSTABLEBITS = 9
let ARCUSTABLESIZE = 1 + (1 << ARCUSTABLEBITS)
let TRIGTABLESIZE = 4096

let arcTanTable: [Fixed] = {
    var table: [Fixed] = .init(repeating: 0, count: ARCUSTABLESIZE)
    for i in 0..<ARCUSTABLESIZE {
        let a = ToFixed(atan2(Float(i), Float(ARCUSTABLESIZE - 1)))
        table[i] = a
    }
    return table
}()

let arcTanOneTable: [Fixed] = {
    var table: [Fixed] = .init(repeating: 0, count: ARCUSTABLESIZE)
    for i in 0..<ARCUSTABLESIZE {
        let a = ToFixed(atan2(Float(i), Float(ARCUSTABLESIZE - 1)))
        table[i] = FRadToOne(a)
    }
    return table
}()

// Full circle is 2 Pi (fixed point, of course)
@inlinable public func FRadSin(_ a: Fixed) -> Fixed {
    return Fixed(65536 * sin(Double(a) / 65536.0))
}
@inlinable public func FRadCos(_ a: Fixed) -> Fixed {
    return Fixed(65536 * cos(Double(a) / 65536.0))
}
@inlinable public func FRadTan(_ a: Fixed) -> Fixed {
    return Fixed(65536 * tan(Double(a) / 65536.0))
}

// Full circle is 360.0 (fixed point)
@inlinable public func FDegSin(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * sin(Double(a) / 3754936.206169363))
}
@inlinable public func FDegCos(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * cos(Double(a) / 3754936.206169363))
}
@inlinable public func FDegTan(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * tan(Double(a) / 3754936.206169363))
}

// Full circle is 1.0 (fixed point)
@inlinable public func FOneSin(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * sin(Double(a) / 10430.3783505))
}
@inlinable public func FOneCos(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * cos(Double(a) / 10430.3783505))
}
@inlinable public func FOneTan(_ a: Fixed) -> Fixed {
    return Fixed(65536.0 * tan(Double(a) / 10430.3783505))
}

func FRadArcCos(_ n: Fixed) -> Fixed {
    FHALFPI - n - FMul(n, FMul(n, n)) / 6
}

func FRadArcSin(_ n: Fixed) -> Fixed {
    n + FMul(n, FMul(n, n)) / 6
}

func FRadArcTan2(_ x: Fixed, _ y: Fixed) -> Fixed {
    if x != 0 || y != 0 {
        let absX = x < 0 ? -x : x
        let absY = y < 0 ? -y : y
        var ratio = absX > absY ? FDiv(absY, absX) : FDiv(absX, absY)
        ratio += 1 << (15 - ARCUSTABLEBITS)
        ratio >>= 16 - ARCUSTABLEBITS

        var result = arcTanTable[Int(ratio)]

        if absY > absX {
            result = FHALFPI - result
        }
        if x < 0 {
            result = FONEPI - result
        }
        if y < 0 {
            result = -result
        }
        return result
    }

    return 0
}

func FOneArcTan2(_ x: Fixed, _ y: Fixed) -> Fixed {
    if x != 0 || y != 0 {
        let absX = x < 0 ? -x : x
        let absY = y < 0 ? -y : y
        var ratio = absX > absY ? FDiv(absY, absX) : FDiv(absX, absY)
        ratio += 1 << (15 - ARCUSTABLEBITS)
        ratio >>= 16 - ARCUSTABLEBITS

        var result = arcTanOneTable[Int(ratio)]

        if absY > absX {
            result = 0x0000_4000 - result
        }
        if x < 0 {
            result = 0x0000_8000 - result
        }
        if y < 0 {
            result = -result
        }
        return result
    }

    return 0
}
/*
void FindSpaceAngle(Fixed *delta, Fixed *heading, Fixed *pitch);
void FindSpaceAngleAndNormalize(Fixed *delta, Fixed *heading, Fixed *pitch);
*/
