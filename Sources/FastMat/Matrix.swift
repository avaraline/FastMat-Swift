//
//  Matrix.swift
//  FastMat
//
//  Created by Daniel Watson on 6/13/25.
//

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

    var cols: [Vector]

    public init() {
        cols = [.init(), .init(), .init(), .init()]
    }

    subscript(i: Int) -> Vector {
        get { cols[i] }
        set { cols[i] = newValue }
    }

    public mutating func reset(to: ResetType) {
        for c in 0..<4 {
            for r in 0..<4 {
                cols[c][r] = to.value(c, r)
            }
        }
    }

    public mutating func translate(_ dx: Fixed, _ dy: Fixed, _ dz: Fixed) {
        cols[3][0] += dx
        cols[3][1] += dy
        cols[3][2] += dz
    }

    public mutating func rotateX(_ s: Fixed, _ c: Fixed) {
        for var col in cols {
            let t = col[1]
            col[1] = FMul(t, c) - FMul(col[2], s)
            col[2] = FMul(t, s) + FMul(col[2], c)
        }
    }

    public mutating func rotateY(_ s: Fixed, _ c: Fixed) {
        for var col in cols {
            let t = col[0]
            col[0] = FMul(t, c) + FMul(col[2], s)
            col[2] = FMul(col[2], c) - FMul(t, s)
        }
    }

    public mutating func rotateZ(_ s: Fixed, _ c: Fixed) {
        for var col in cols {
            let t = col[0]
            col[0] = FMul(t, c) - FMul(col[1], s)
            col[1] = FMul(t, s) + FMul(col[1], c)
        }
    }

    public func multiply(_ v: Vector) -> Vector {
        var result = Vector()
        for i in 0..<4 {
            result[i] =
                FMul(v[0], cols[0][i])
                + FMul(v[1], cols[1][i])
                + FMul(v[2], cols[2][i])
                + FMul(v[3], cols[3][i])
        }
        return result
    }

    public func multiply(_ m: Matrix) -> Matrix {
        var result = Matrix()
        for i in 0..<4 {
            for j in 0..<4 {
                result[i][j] =
                    FMul(cols[0][i], m[0][j])
                    + FMul(cols[1][i], m[1][j])
                    + FMul(cols[2][i], m[2][j])
                    + FMul(cols[3][i], m[3][j])
            }
        }
        return result
    }
}
