import Foundation

public typealias Fixed = Int32

public let FIX1: Fixed = 0x0001_0000
public let MINFIXED: Fixed = -0x8000_0000
public let MAXFIXED: Fixed = 0x7FFF_FFFF

public let PI: Float = 3.141592653589793238463

public let FHALFPI: Fixed = 102944
public let FONEPI: Fixed = 205887
public let FTWOPI: Fixed = 411775

@inlinable public func ToFloat(_ a: Fixed) -> Float { Float(a) / Float(FIX1) }
@inlinable public func ToFixed(_ a: Float) -> Fixed {
    // This avoids doing overflow checks, at the cost of assuming we don't work with floats outside
    // the bounds of a fixed int32.
    return Fixed(a * Float(FIX1))
    // let x = a * Float(FIX1)
    // if x >= Float(Fixed.max) { return Fixed.max }
    // if x <= Float(Fixed.min) { return Fixed.min }
    // return Fixed(x)
}
@inlinable public func Deg2Rad(_ deg: Float) -> Float { deg * PI / 180.0 }

@inlinable public func FIX(_ n: Int) -> Fixed { Fixed(n * 65536) }
@inlinable public func FIX3(_ n: Int) -> Fixed { Fixed(n * 8192 / 125) }

@inlinable public func FRound(_ n: Float) -> Fixed { Fixed(n.rounded()) }
@inlinable public func ToFixedRound(_ n: Float) -> Fixed { FRound(n * 65536) }

@inlinable public func LMul(_ a: Int64, _ b: Fixed) -> Int64 { (a &* Int64(b)) / Int64(FIX1) }
@inlinable public func FMul(_ a: Fixed, _ b: Fixed) -> Fixed {
    Fixed(truncatingIfNeeded: (Int64(a) &* Int64(b)) / Int64(FIX1))
}
@inlinable public func FDiv(_ a: Fixed, _ b: Fixed) -> Fixed { Fixed((Int64(a) << 16) / Int64(b)) }
@inlinable public func FMulDiv(_ a: Fixed, _ b: Fixed, _ c: Fixed) -> Fixed {
    Fixed(Double(a) * Double(b) / Double(c))
}

@inlinable public func FRadToDeg(_ angle: Fixed) -> Fixed { FMul(angle, 3_754_936) }
@inlinable public func FDegToRad(_ angle: Fixed) -> Fixed { FMul(angle, 1144) }
@inlinable public func FOneToDeg(_ angle: Fixed) -> Fixed { angle * 360 }
@inlinable public func FDegToOne(_ angle: Fixed) -> Fixed { angle / 360 }
@inlinable public func FOneToRad(_ angle: Fixed) -> Fixed { FMul(angle, 41175) }
@inlinable public func FRadToOne(_ angle: Fixed) -> Fixed { FMul(angle, 10430) }
