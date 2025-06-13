import Testing
@testable import FastMat
@testable import CFastMat

@Test func testLMul() async throws {
    for _ in 0..<1000 {
        let a = Int64.random(in: Int64.min..<Int64.max)
        let b = Fixed.random(in: Fixed.min..<Fixed.max)
        #expect(FastMat.LMul(a, b) == CFastMat.LMul(a, b))
    }
}

@Test func testFMul() async throws {
    for _ in 0..<1000 {
        let a = Fixed.random(in: Fixed.min..<Fixed.max)
        let b = Fixed.random(in: Fixed.min..<Fixed.max)
        #expect(FastMat.FMul(a, b) == CFastMat.FMul(a, b))
    }
}
