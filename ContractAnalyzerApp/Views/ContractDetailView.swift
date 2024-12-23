import SwiftUI

struct ContractDetailView: View {
    let contract: Contract.AnalyzedContract
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
                ShareLink(item: generateShareText(from: contract.analysis))
            }
        }
    }
    
    private func generateShareText(from analysis: Contract.AnalysisResult) -> String {
        """
        SÖZLEŞME ANALİZ RAPORU
        
        Risk Skoru: \(analysis.formattedRiskScore)
        Risk Seviyesi: \(analysis.riskLevel.rawValue)
        
        ÖZET:
        \(analysis.summary)
        
        ÖNEMLİ MADDELER:
        \(analysis.keyPoints.map { "• \($0.title)" }.joined(separator: "\n"))
        
        RİSKLER:
        \(analysis.risks.map { "• \($0.title) (\($0.severity.rawValue))" }.joined(separator: "\n"))
        
        ÖNERİLER:
        \(analysis.recommendations.map { "• \($0)" }.joined(separator: "\n"))
        """
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