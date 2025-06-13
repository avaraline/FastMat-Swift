import Testing
@testable import FastMat
@testable import CFastMat

// Assuming we don't deal with super large magnitude floats.
let fixedFloatRange = Float(Fixed.min / 65536) ... Float(Fixed.max / 65536)

let smallFixedRange = -Fixed(1 << 15) ... Fixed(1 << 15)
let mediumFixedRange = -Fixed(1 << 22) ... Fixed(1 << 22)

@Test func testToFloat() async throws {
    for _ in 0..<1000 {
        let a = Fixed.random(in: Fixed.min..<Fixed.max)
        #expect(FastMat.ToFloat(a) == CFastMat.ToFloat(a))
    }
}

@Test func testToFixedAndOtherFloatStuff() async throws {
    for _ in 0..<1000 {
        let a = Float.random(in: fixedFloatRange)
        #expect(FastMat.ToFixed(a) == CFastMat.ToFixed(a))
        #expect(FastMat.FRound(a) == CFastMat.FRound(a))
        #expect(FastMat.ToFixedRound(a) == CFastMat.ToFixedRound(a))
    }
}

@Test func testLMul() async throws {
    for _ in 0..<1000 {
        let a = Int64.random(in: Int64.min..<Int64.max)
        let b = Fixed.random(in: Fixed.min..<Fixed.max)
        #expect(FastMat.LMul(a, b) == CFastMat.LMul(a, b))
    }
}

@Test func testFMulAndFriends() async throws {
    for _ in 0..<1000 {
        let a = Fixed.random(in: smallFixedRange)
        let b = Fixed.random(in: smallFixedRange)
        let c = Fixed.random(in: smallFixedRange)
        if b == 0 || c == 0 { continue }
        #expect(FastMat.FMul(a, b) == CFastMat.FMul(a, b))
        #expect(FastMat.FDiv(a, b) == CFastMat.FDiv(a, b))
        #expect(FastMat.FMulDiv(a, b, c) == CFastMat.FMulDiv(a, b, c))
    }
}

@Test func testAngleOps() async throws {
    for _ in 0..<1000 {
        let a = Fixed.random(in: mediumFixedRange)
        #expect(FastMat.FRadToDeg(a) == CFastMat.FRadToDeg(a))
        #expect(FastMat.FDegToRad(a) == CFastMat.FDegToRad(a))
        #expect(FastMat.FOneToDeg(a) == CFastMat.FOneToDeg(a))
        #expect(FastMat.FDegToOne(a) == CFastMat.FDegToOne(a))
        #expect(FastMat.FOneToRad(a) == CFastMat.FOneToRad(a))
        #expect(FastMat.FRadToOne(a) == CFastMat.FRadToOne(a))
    }
}
