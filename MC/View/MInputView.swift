import SwiftUI

struct MInputView: View {
    @Binding var matrix: Matrix
    let title: String
    
    let onAddRow: () -> Void
    let onRemoveRow: () -> Void
    let onAddColumn: () -> Void
    let onRemoveColumn: () -> Void
    let onClear: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)

            VStack(spacing: 5) {
                ForEach(0..<matrix.rows, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(0..<matrix.cols, id: \.self) { col in
                            TextField("", text: binding(for: row, col: col))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                #if os(iOS) // для мультиплатформенности
                                .keyboardType(.decimalPad)
                                #endif
                                .frame(width: 50)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            
            HStack {
                Button(action: onAddRow) { Image(systemName: "plus.rectangle") }
                Button(action: onRemoveRow) { Image(systemName: "minus.rectangle") }
                Text("Rows").font(.caption)
            }
            
            HStack {
                Button(action: onAddColumn) { Image(systemName: "plus.rectangle") }
                Button(action: onRemoveColumn) { Image(systemName: "minus.rectangle") }
                Text("Cols").font(.caption)
            }
            
            Button("Clear", action: onClear)
                .buttonStyle(.bordered)
                .tint(.red)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    // вспомогательная дл форматирования
    private func binding(for row: Int, col: Int) -> Binding<String> {
        return Binding<String>(
            get: {
                // To avoid showing ".0" for whole numbers
                let value = self.matrix[row, col]
                return value.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", value) : String(value)
            },
            set: {
                if let value = Double($0) {
                    self.matrix[row, col] = value
                }
            }
        )
    }
}
