import SwiftUI
import UniformTypeIdentifiers
import Lottie

struct DocumentPickerView: View {
    @ObservedObject var viewModel: DocumentPickerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isAnalyzing {
                    VStack(spacing: 20) {
                        LoadingAnimation(name: "loading.json")
                            .frame(width: 200, height: 200)
                        
                        Text("Sözleşme analiz ediliyor...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Analiz edilecek sözleşmeyi seçin")
                            .font(.headline)
                        
                        Text("PDF, Word veya metin dosyası yükleyebilirsiniz")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            viewModel.showingPicker = true
                        }) {
                            Label("Dosya Seç", systemImage: "doc.badge.plus")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Sözleşme Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                dismiss()
                viewModel.shouldDismiss = false
            }
        }
        .fileImporter(
            isPresented: $viewModel.showingPicker,
            allowedContentTypes: UTType.supportedTypes,
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        await viewModel.analyzeDocument(at: url)
                    }
                }
            case .failure(let error):
                viewModel.error = "Dosya seçilirken bir hata oluştu: \(error.localizedDescription)"
            }
        }
        .toast(isPresented: $viewModel.showToast, message: viewModel.toastMessage, type: viewModel.toastType)
    }
}

#Preview {
    DocumentPickerView(viewModel: DocumentPickerViewModel())
} 
