import SwiftUI

struct ResultMView: View {
    
    let matrix: Matrix

    var body: some View {
        VStack {
            Text("Результат")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                ForEach(0..<matrix.rows, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<matrix.cols, id: \.self) { col in
                            Text(String(format: "%.2f", matrix[row, col]))
                                .frame(minWidth: 50, alignment: .center)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

