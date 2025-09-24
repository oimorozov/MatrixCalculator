import Foundation

enum MError: Error, LocalizedError {
    // кастомные типы ошибок
    case dimensionsMismatch
    case nonPositiveDimensions
    case invalidScalar
    case invalidFillValue

    var errorDescription: String? {
        switch self {
        case .dimensionsMismatch:
            return "Операция не может быть выполнена с матрицами таких размеров"
        case .nonPositiveDimensions:
            return "Размер матриц - положительные числа"
        case .invalidScalar:
            return "Скаляр невалиден"
        case .invalidFillValue:
            return "Введенное значение для заполнения некорректно."
        }
    }
}
