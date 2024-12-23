import SwiftUI

struct ShareView: View {
    let analysis: Contract.AnalysisResult
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFormat: ExportFormat = .pdf
    @State private var isExporting = false
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Format Seçimi
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dışa Aktarma Formatı")
                        .font(.headline)
                    FormatPicker(selectedFormat: $selectedFormat)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                
                // Paylaşım Seçenekleri
                VStack(spacing: 15) {
                    ShareButton(
                        title: "Detaylı Rapor",
                        subtitle: "Tüm analiz detaylarıyla birlikte",
                        icon: "doc.text.fill"
                    ) {
                        shareDetailedReport()
                    }
                    
                    ShareButton(
                        title: "Hızlı Özet",
                        subtitle: "Sadece önemli noktalar",
                        icon: "text.quote"
                    ) {
                        shareQuickSummary()
                    }
                }
                
                if isExporting {
                    ProgressView("Rapor hazırlanıyor...")
                }
                
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Paylaş")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func shareDetailedReport() {
        isExporting = true
        error = nil
        
        Task {
            do {
                let url = try ShareUtils.shared.generateShareableFile(
                    from: analysis,
                    format: selectedFormat
                )
                
                await MainActor.run {
                    isExporting = false
                    presentShareSheet(with: [url])
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    private func shareQuickSummary() {
        let summary = generateQuickSummary()
        presentShareSheet(with: [summary])
    }
    
    private func generateQuickSummary() -> String {
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
    
    private func presentShareSheet(with items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
        }
        
        rootVC.present(activityVC, animated: true)
    }
}

struct ShareButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ShareView(analysis: Contract.AnalysisResult(
        summary: "Örnek özet",
        keyPoints: [
            Contract.KeyPoint(
                title: "Önemli Madde",
                description: "Açıklama",
                importance: .high,
                articleNumber: "1.1"
            )
        ],
        risks: [
            Contract.Risk(
                title: "Risk",
                description: "Risk açıklaması",
                severity: .medium,
                relatedArticle: "1.2",
                suggestedAction: "Öneri"
            )
        ],
        recommendations: ["Öneri 1", "Öneri 2"],
        riskAssessment: nil,
        riskLevel: .medium,
        formattedRiskScore: "65"
    ))
} 