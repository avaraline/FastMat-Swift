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

nonisolated(unsafe) var arcTanTable: [Fixed] = .init(repeating: 0, count: ARCUSTABLESIZE)
nonisolated(unsafe) var arcTanOneTable: [Fixed] = .init(repeating: 0, count: ARCUSTABLESIZE)

func InitTrigTables() {
    for i in 0..<ARCUSTABLESIZE {
        let a = ToFixed(atan2(Float(i), Float(ARCUSTABLESIZE - 1)))
        arcTanTable[i] = a
        arcTanOneTable[i] = FRadToOne(a)
    }
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
