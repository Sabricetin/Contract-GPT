import SwiftUI

struct ContractDetailView: View {
    let contract: Contract.AnalyzedContract
    @State private var showingShareSheet = false
    @State private var selectedLanguage = "tr"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Dosya Bilgileri
                VStack(alignment: .leading, spacing: 8) {
                    Text(contract.fileName)
                        .font(.title2)
                        .bold()
                    Text("Analiz Tarihi: \(contract.analyzedDate.formatted())")
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Analiz Sonuçları
                AnalysisResultView(analysis: contract.analysis)
            }
            .padding()
        }
        .navigationTitle("Sözleşme Detayı")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareView(analysis: contract.analysis)
        }
    }
}

#Preview {
    NavigationView {
        ContractDetailView(contract: Contract.AnalyzedContract(
            fileName: "Örnek Sözleşme.pdf",
            analyzedDate: Date(),
            analysis: Contract.AnalysisResult(
                summary: "Örnek özet",
                keyPoints: [],
                risks: [],
                recommendations: [],
                riskAssessment: nil,
                riskLevel: .medium,
                formattedRiskScore: "65"
            ),
            isFavorite: false
        ))
    }
} 