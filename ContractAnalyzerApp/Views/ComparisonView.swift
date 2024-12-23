import SwiftUI

struct ComparisonView: View {
    let firstContract: Contract.AnalyzedContract
    let secondContract: Contract.AnalyzedContract
    @State private var differences: [Contract.ContractDifference] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Sözleşme Bilgileri
                HStack {
                    VStack(alignment: .leading) {
                        Text(firstContract.fileName)
                            .font(.headline)
                        Text("vs")
                            .foregroundColor(.secondary)
                        Text(secondContract.fileName)
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                if isLoading {
                    ProgressView("Karşılaştırılıyor...")
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Farklılıklar
                    ForEach(differences) { difference in
                        DifferenceView(difference: difference)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Karşılaştırma")
        .onAppear {
            compareContracts()
        }
    }
    
    private func compareContracts() {
        isLoading = true
        errorMessage = nil
        
        // Örnek farklılıklar (gerçek uygulamada AI ile karşılaştırma yapılacak)
        differences = [
            Contract.ContractDifference(
                title: "Madde 1 Değişikliği",
                description: "İlk sözleşmede farklı bir ifade kullanılmış",
                firstVersion: "Taraflar anlaşmıştır ki...",
                secondVersion: "Taraflar mutabık kalmıştır ki...",
                importance: .medium,
                articleNumber: "1.1"
            ),
            Contract.ContractDifference(
                title: "Ek Madde",
                description: "İkinci sözleşmede yeni bir madde eklenmiş",
                firstVersion: nil,
                secondVersion: "Yeni eklenen madde içeriği...",
                importance: .high,
                articleNumber: "2.3"
            )
        ]
        
        isLoading = false
    }
}

struct DifferenceView: View {
    let difference: Contract.ContractDifference
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(difference.title)
                    .font(.headline)
                Spacer()
                Text("Madde \(difference.articleNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(difference.description)
                .foregroundColor(.secondary)
            
            if let first = difference.firstVersion {
                VStack(alignment: .leading) {
                    Text("Eski Versiyon:")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Text(first)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            
            if let second = difference.secondVersion {
                VStack(alignment: .leading) {
                    Text("Yeni Versiyon:")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text(second)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
            
            ImportanceLabel(importance: difference.importance)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        ComparisonView(
            firstContract: Contract.AnalyzedContract(
                fileName: "Sözleşme v1.pdf",
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
            ),
            secondContract: Contract.AnalyzedContract(
                fileName: "Sözleşme v2.pdf",
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
            )
        )
    }
} 