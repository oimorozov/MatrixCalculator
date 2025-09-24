import SwiftUI

struct CalcView: View {
    @StateObject private var viewModel = CalcViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }

                    HStack(alignment: .top, spacing: 15) {
                        // первая матрица
                        MInputView(
                            matrix: $viewModel.matrixA,
                            title: "Matrix A",
                            onAddRow: { viewModel.addRow(to: .A) },
                            onRemoveRow: { viewModel.removeRow(to: .A) },
                            onAddColumn: { viewModel.addColumn(to: .A) },
                            onRemoveColumn: { viewModel.removeColumn(to: .A) },
                            onClear: { viewModel.clearMatrix(.A) }
                        )
                        // вторая матрица
                        MInputView(
                            matrix: $viewModel.matrixB,
                            title: "Matrix B",
                            onAddRow: { viewModel.addRow(to: .B) },
                            onRemoveRow: { viewModel.removeRow(to: .B) },
                            onAddColumn: { viewModel.addColumn(to: .B) },
                            onRemoveColumn: { viewModel.removeColumn(to: .B) },
                            onClear: { viewModel.clearMatrix(.B) }
                        )
                    }
                    
                    VStack(spacing: 15) {
                        HStack {
                            Button("A + B", action: viewModel.performAddition)
                            Button("A * B", action: viewModel.performMultiplication)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        HStack {
                            Text("Scalar:")
                            TextField("Value", text: $viewModel.scalarString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                #if os(iOS)
                                .keyboardType(.decimalPad)
                                #endif
                                .frame(width: 80)
                        }
                        
                        HStack {
                            Button("A * Scalar") { viewModel.multiplyByScalar(.A) }
                            Button("B * Scalar") { viewModel.multiplyByScalar(.B) }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Divider().padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        Button {
                            viewModel.swapMatrices()
                        } label: {
                            Label("Поменять A и B местами", systemImage: "arrow.left.arrow.right.square")
                        }
                        .buttonStyle(.bordered)

                        HStack {
                            Text("Заполнить числом:")
                            TextField("Число", text: $viewModel.fillString)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                #if os(iOS)
                                .keyboardType(.decimalPad)
                                #endif
                                .frame(width: 60)
                            
                            Button("Заполнить A") { viewModel.fillMatrix(for: .A) }
                                .buttonStyle(.bordered)
                            
                            Button("Заполнить B") { viewModel.fillMatrix(for: .B) }
                                .buttonStyle(.bordered)
                        }
                    }
                    
                    if let result = viewModel.resultMatrix {
                        Divider().padding(.vertical)
                        ResultMView(matrix: result)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Matrix Calculator")
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 600)
        #endif
    }
}
