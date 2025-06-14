//
//  Matrix.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

extension MutableCollection {
    mutating func updateEach(_ update: (inout Element) -> Void) {
        for i in indices {
            update(&self[i])
        }
    }
}

public struct Matrix {
    public enum ResetType {
        case zero
        case identity

        func value(_ c: Int, _ r: Int) -> Fixed {
            switch self {
            case .zero:
                return 0
            case .identity:
                return c == r ? FIX1 : 0
            }
        }
    }

    //var columns: (Vector, Vector, Vector, Vector)
    var columns: [Vector]

    public init() {
        columns = [.init(), .init(), .init(), .init()]
    }

    subscript(i: Int) -> Vector {
        get { columns[i] }
        set { columns[i] = newValue }
    }

    public mutating func reset(to: ResetType) {
        for c in 0..<4 {
            for r in 0..<4 {
                columns[c][r] = to.value(c, r)
            }
        }
    }

    public mutating func translate(_ dx: Fixed, _ dy: Fixed, _ dz: Fixed) {
        columns[3][0] += dx
        columns[3][1] += dy
        columns[3][2] += dz
    }

    public mutating func rotateX(_ s: Fixed, _ c: Fixed) {
        columns.updateEach { col in
            let t1 = col[1]
            let t2 = col[2]
            col[1] = FMul(t1, c) - FMul(t2, s)
            col[2] = FMul(t1, s) + FMul(t2, c)
        }
    }

    public mutating func rotateY(_ s: Fixed, _ c: Fixed) {
        columns.updateEach { col in
            let t0 = col[0]
            let t2 = col[2]
            col[0] = FMul(t0, c) + FMul(t2, s)
            col[2] = FMul(t2, c) - FMul(t0, s)
        }
    }

    public mutating func rotateZ(_ s: Fixed, _ c: Fixed) {
        columns.updateEach { col in
            let t0 = col[0]
            let t1 = col[1]
            col[0] = FMul(t0, c) - FMul(t1, s)
            col[1] = FMul(t0, s) + FMul(t1, c)
        }
    }

    public mutating func inverse(of m: Matrix) {
        columns[0][0] = m[0][0]
        columns[0][1] = m[1][0]
        columns[0][2] = m[2][0]
        columns[0][3] = 0

        columns[1][0] = m[0][1]
        columns[1][1] = m[1][1]
        columns[1][2] = m[2][1]
        columns[1][3] = 0

        columns[2][0] = m[0][2]
        columns[2][1] = m[1][2]
        columns[2][2] = m[2][2]
        columns[2][3] = 0

        columns[3][0] = 0
        columns[3][1] = 0
        columns[3][2] = 0
        columns[3][3] = FIX1

        let temp = multiply(m[3])
        columns[3][0] = -temp[0]
        columns[3][1] = -temp[1]
        columns[3][2] = -temp[2]
    }

    public func multiply(_ v: Vector) -> Vector {
        var result = Vector()
        for i in 0..<4 {
            result[i] =
                FMul(v[0], columns[0][i])
                + FMul(v[1], columns[1][i])
                + FMul(v[2], columns[2][i])
                + FMul(v[3], columns[3][i])
        }
        return result
    }

    public func multiply(_ m: Matrix) -> Matrix {
        var result = Matrix()
        for i in 0..<4 {
            for j in 0..<4 {
                result[i][j] =
                    FMul(columns[0][i], m[0][j])
                    + FMul(columns[1][i], m[1][j])
                    + FMul(columns[2][i], m[2][j])
                    + FMul(columns[3][i], m[3][j])
            }
        }
        return result
    }
}
