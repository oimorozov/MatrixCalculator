import Foundation

struct Matrix: Equatable {
    // модель данных
    
    let rows: Int
    let cols: Int
    var grid: [[Double]]
    
    
    init(rows: Int, cols: Int, fill: Double = 0.0) {
        self.rows = max(1, rows)
        self.cols = max(1, cols)
        self.grid = Array(repeating: Array(repeating: fill, count: self.cols), count: self.rows)
    }
    // индексатор
    subscript(row: Int, col: Int) -> Double {
        get {
            return grid[row][col]
        }
        set {
            grid[row][col] = newValue
        }
    }
    // ==========
    // перегрузки
    // ==========
    
    // сложение
    static func +(left: Matrix, right: Matrix) throws -> Matrix {
        guard left.cols == right.cols && left.rows == right.rows else {
            throw MError.dimensionsMismatch
        }
        var res = Matrix(rows: left.rows, cols: left.cols)
        for i in 0..<left.rows {
            for j in 0..<left.cols {
                res[i, j] = left[i, j] + right[i, j]
            }
        }
        return res
    }
    // умножение
    static func *(left: Matrix, right: Matrix) throws -> Matrix {
        guard left.cols == right.rows else {
            throw MError.dimensionsMismatch
        }
        var res = Matrix(rows: left.rows, cols: left.cols)
        for i in 0..<left.rows {
            for j in 0..<right.cols {
                var sum = 0.0
                for k in 0..<left.cols {
                    sum += left[i, k] * right[k, j]
                }
                res[i, j] = sum
            }
        }
        return res
    }
    // умножение на скаляр с двух сторон
    static func *(scalar: Double, matr: Matrix) -> Matrix {
        var res = Matrix(rows: matr.rows, cols: matr.cols)
        for i in 0..<matr.rows {
            for j in 0..<matr.cols {
                res[i, j] = scalar * matr[i, j]
            }
        }
        return res
    }
    static func *(matr: Matrix, scalar: Double) -> Matrix {
        return scalar * matr
    }
}
