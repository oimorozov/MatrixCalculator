import Foundation
import Combine

@MainActor
class CalcViewModel: ObservableObject {
    
    @Published var matrixA: Matrix
    @Published var matrixB: Matrix
    @Published var resultMatrix: Matrix? // может быть nil
    @Published var scalarString: String = "1.0"
    @Published var errorMessage: String?
    @Published var fillString: String = "0"
    
    enum MatrixIdentifier {
        case A, B
    }

    init() {
        self.matrixA = Matrix(rows: 2, cols: 2)
        self.matrixB = Matrix(rows: 2, cols: 2)
    }
    
    // заполнить матрицы числом
    func fillMatrix(for identifier: MatrixIdentifier) {
        resetState()
        guard let fillValue = Double(fillString) else {
            errorMessage = MError.invalidFillValue.localizedDescription
            return
        }
        updateMatrix(identifier) { matrix in
            Matrix(rows: matrix.rows, cols: matrix.cols, fill: fillValue)
        }
    }
    
    // поменять матрицы местами
    func swapMatrices() {
        resetState()
        (matrixA, matrixB) = (matrixB, matrixA)
    }
    
    // сложение
    func performAddition() {
        resetState()
        do {
            resultMatrix = try matrixA + matrixB
        } catch {
            handle(error)
        }
    }
    // умножение
    func performMultiplication() {
        resetState()
        do {
            resultMatrix = try matrixA * matrixB
        } catch {
            handle(error)
        }
    }
    // умножение на скаляр
    func multiplyByScalar(_ identifier: MatrixIdentifier) {
        resetState()
        guard let scalarValue = Double(scalarString) else {
            errorMessage = MError.invalidScalar.localizedDescription
            return
        }
        
        switch identifier {
        case .A:
            resultMatrix = matrixA * scalarValue
        case .B:
            resultMatrix = matrixB * scalarValue
        }
    }
    // добавить строку
    func addRow(to identifier: MatrixIdentifier) {
        updateMatrix(identifier) { matrix in
            var newMatrix = Matrix(rows: matrix.rows + 1, cols: matrix.cols)
            for r in 0..<matrix.rows {
                for c in 0..<matrix.cols {
                    newMatrix[r, c] = matrix[r, c]
                }
            }
            return newMatrix
        }
    }
    // убрать строку
    func removeRow(to identifier: MatrixIdentifier) {
        updateMatrix(identifier) { matrix in
            guard matrix.rows > 1 else { return matrix }
            var newMatrix = Matrix(rows: matrix.rows - 1, cols: matrix.cols)
            for r in 0..<newMatrix.rows {
                for c in 0..<matrix.cols {
                    newMatrix[r, c] = matrix[r, c]
                }
            }
            return newMatrix
        }
    }
    // добавить столбец
    func addColumn(to identifier: MatrixIdentifier) {
        updateMatrix(identifier) { matrix in
            var newMatrix = Matrix(rows: matrix.rows, cols: matrix.cols + 1)
            for r in 0..<matrix.rows {
                for c in 0..<matrix.cols {
                    newMatrix[r, c] = matrix[r, c]
                }
            }
            return newMatrix
        }
    }
    // убрать столбец
    func removeColumn(to identifier: MatrixIdentifier) {
        updateMatrix(identifier) { matrix in
            guard matrix.cols > 1 else { return matrix }
            var newMatrix = Matrix(rows: matrix.rows, cols: matrix.cols - 1)
            for r in 0..<matrix.rows {
                for c in 0..<newMatrix.cols {
                    newMatrix[r, c] = matrix[r, c]
                }
            }
            return newMatrix
        }
    }
    // очистить
    func clearMatrix(_ identifier: MatrixIdentifier) {
        updateMatrix(identifier) { matrix in
            Matrix(rows: matrix.rows, cols: matrix.cols, fill: 0.0)
        }
    }
    
    private func updateMatrix(_ identifier: MatrixIdentifier, transform: (Matrix) -> Matrix) {
        resetState()
        switch identifier {
        case .A:
            matrixA = transform(matrixA)
        case .B:
            matrixB = transform(matrixB)
        }
    }
    // вспомогательная для очистки состояния
    private func resetState() {
        errorMessage = nil
        resultMatrix = nil
    }
    // вспомогательная для обработки исключения
    private func handle(_ error: Error) {
        if let matrixError = error as? MError {
            self.errorMessage = matrixError.localizedDescription
        } else {
            self.errorMessage = "An unexpected error occurred."
        }
    }
}
