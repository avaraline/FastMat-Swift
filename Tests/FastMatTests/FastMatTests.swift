import Testing

@testable import CFastMat
@testable import FastMat

// Assuming we don't deal with super large magnitude floats.
let fixedFloatRange = Float(Fixed.min / 65536)...Float(Fixed.max / 65536)

let smallFixedRange = -Fixed(1 << 15)...Fixed(1 << 15)
let mediumFixedRange = -Fixed(1 << 22)...Fixed(1 << 22)

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

@Test func testTrig() async throws {
    CFastMat.InitMatrix()

    for _ in 0..<1000 {
        let a = Fixed.random(in: smallFixedRange)
        let b = Fixed.random(in: smallFixedRange)
        #expect(FastMat.FRadSin(a) == CFastMat.FRadSin(a))
        #expect(FastMat.FRadCos(a) == CFastMat.FRadCos(a))
        #expect(FastMat.FRadTan(a) == CFastMat.FRadTan(a))
        #expect(FastMat.FDegSin(a) == CFastMat.FDegSin(a))
        #expect(FastMat.FDegCos(a) == CFastMat.FDegCos(a))
        #expect(FastMat.FDegTan(a) == CFastMat.FDegTan(a))
        #expect(FastMat.FOneSin(a) == CFastMat.FOneSin(a))
        #expect(FastMat.FOneCos(a) == CFastMat.FOneCos(a))
        #expect(FastMat.FOneTan(a) == CFastMat.FOneTan(a))
        #expect(FastMat.FRadArcCos(a) == CFastMat.FRadArcCos(a))
        #expect(FastMat.FRadArcSin(a) == CFastMat.FRadArcSin(a))
        #expect(FastMat.FRadArcTan2(a, b) == CFastMat.FRadArcTan2(a, b))
        #expect(FastMat.FOneArcTan2(a, b) == CFastMat.FOneArcTan2(a, b))
    }
}

@Test func testSpaceAngle() async throws {
    CFastMat.InitMatrix()

    for _ in 0..<1000 {
        let x = Fixed.random(in: mediumFixedRange)
        let y = Fixed.random(in: mediumFixedRange)
        let z = Fixed.random(in: mediumFixedRange)
        let w = Fixed.random(in: mediumFixedRange)
        let v = FastMat.Vector(x, y, z, w)
        var vc = CFastMat.Vector(x, y, z, w)
        var h: Fixed = 0
        var p: Fixed = 0
        var hc: Fixed = 0
        var pc: Fixed = 0
        v.spaceAngle(&h, &p)
        CFastMat.FindSpaceAngle(V2F(&vc), &hc, &pc)
        #expect(h == hc)
        #expect(p == pc)
    }
}

@Test func testSquares() async throws {
    for _ in 0..<1000 {
        let a = Fixed.random(in: mediumFixedRange)
        #expect(FastMat.FSqrt(a) == CFastMat.FSqrt(a))
    }

    let cAcc = CFastMat.MakeAccumulator()
    var acc = SquareAccumulator()

    for _ in 0..<3 {
        let v = FastMat.ToFixed(Float.random(in: 1...40))
        acc.accumulate(v)
        CFastMat.FSquareAccumulate(v, cAcc)
        #expect(Int32(bitPattern: acc.highBits) == CFastMat.AccHigh(cAcc))
        #expect(Int32(bitPattern: acc.lowBits) == CFastMat.AccLow(cAcc))
    }

    #expect(acc.squareRoot() == CFastMat.FSqroot(cAcc))

    for _ in 0..<4 {
        let v = FastMat.ToFixed(Float.random(in: 1...40))
        acc.subtract(v)
        CFastMat.FSquareSubtract(v, cAcc)
        #expect(Int32(bitPattern: acc.highBits) == CFastMat.AccHigh(cAcc))
        #expect(Int32(bitPattern: acc.lowBits) == CFastMat.AccLow(cAcc))
    }

    #expect(acc.squareRoot() == CFastMat.FSqroot(cAcc))
    CFastMat.FreeAccumulator(cAcc)
}

func vectorEquals(_ v: FastMat.Vector, _ cv: CFastMat.Vector) -> Bool {
    v.x == cv.0 && v.y == cv.1 && v.z == cv.2 && v.w == cv.3
}

@Test func testVectors() async throws {
    for _ in 0..<1000 {
        let x = Fixed.random(in: mediumFixedRange)
        let y = Fixed.random(in: mediumFixedRange)
        let z = Fixed.random(in: mediumFixedRange)
        let w = Fixed.random(in: mediumFixedRange)
        var v1 = FastMat.Vector(x, y, z, w)
        var v2 = CFastMat.Vector(x, y, z, w)
        #expect(vectorEquals(v1, v2))
        let l1 = v1.normalize()
        let l2 = CFastMat.NormalizeVector(3, V2F(&v2))
        #expect(vectorEquals(v1, v2))
        #expect(l1 == l2)
    }
}

func zeroMatrix() -> CFastMat.Matrix {
    return CFastMat.Matrix(
        (Int32(0), Int32(0), Int32(0), Int32(0)),
        (Int32(0), Int32(0), Int32(0), Int32(0)),
        (Int32(0), Int32(0), Int32(0), Int32(0)),
        (Int32(0), Int32(0), Int32(0), Int32(0))
    )
}

func matrixEquals(_ m1: FastMat.Matrix, _ m2: CFastMat.Matrix) -> Bool {
    m1[0][0] == m2.0.0 && m1[0][1] == m2.0.1 && m1[0][2] == m2.0.2 && m1[0][3] == m2.0.3
        && m1[1][0] == m2.1.0 && m1[1][1] == m2.1.1 && m1[1][2] == m2.1.2 && m1[1][3] == m2.1.3
        && m1[2][0] == m2.2.0 && m1[2][1] == m2.2.1 && m1[2][2] == m2.2.2 && m1[2][3] == m2.2.3
        && m1[3][0] == m2.3.0 && m1[3][1] == m2.3.1 && m1[3][2] == m2.3.2 && m1[3][3] == m2.3.3
}

@Test func testMatrix() async throws {
    var cm = zeroMatrix()
    var cmi = zeroMatrix()
    CFastMat.OneMatrix(&cm)

    var m = FastMat.Matrix()
    var i = FastMat.Matrix()
    m.reset(to: .identity)

    #expect(matrixEquals(m, cm))

    let dx = mediumFixedRange.randomElement()!
    let dy = mediumFixedRange.randomElement()!
    let dz = mediumFixedRange.randomElement()!

    CFastMat.MTranslate(dx, dy, dz, &cm)
    m.translate(dx, dy, dz)

    #expect(matrixEquals(m, cm))

    let s = CFastMat.FRadSin(mediumFixedRange.randomElement()!)
    let c = CFastMat.FRadCos(mediumFixedRange.randomElement()!)

    CFastMat.MRotateX(s, c, &cm)
    m.rotateX(s, c)
    #expect(matrixEquals(m, cm))

    CFastMat.MRotateY(s, c, &cm)
    m.rotateY(s, c)
    #expect(matrixEquals(m, cm))

    CFastMat.MRotateZ(s, c, &cm)
    m.rotateZ(s, c)
    #expect(matrixEquals(m, cm))

    CFastMat.InverseTransform(&cm, &cmi)
    i.inverse(of: m)
    #expect(matrixEquals(i, cmi))
}
