import Foundation
import Combine
import PDFKit

final class HistoryViewModel: ObservableObject {
    @Published var contracts: [Contract.AnalyzedContract] = []
    private let historyManager = HistoryManager.shared
    
    init() {
        // İlk yükleme
        contracts = historyManager.contracts
        
        // HistoryManager'ı dinle
        NotificationCenter.default.addObserver(self,
            selector: #selector(contractsDidChange),
            name: .contractsDidChange,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contractsDidChange() {
        DispatchQueue.main.async {
            self.contracts = self.historyManager.contracts
        }
    }
    
    func analyzeDocument(at url: URL) async {
        do {
            let text: String
            
            if url.pathExtension.lowercased() == "pdf" {
                guard let pdfDocument = PDFDocument(url: url) else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "PDF dosyası açılamadı"])
                }
                text = pdfDocument.string ?? ""
            } else {
                text = try String(contentsOf: url, encoding: .utf8)
            }
            
            guard !text.isEmpty else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dosya boş veya okunamadı"])
            }
            
            // 5 saniye bekle
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            
            // Test için mock analiz sonucu
            let analysis = Contract.AnalysisResult(
                summary: "Bu bir test sözleşme analizidir. Sözleşme içeriği okundu ve analiz edildi.",
                keyPoints: [
                    Contract.KeyPoint(
                        title: "Sözleşme Süresi",
                        description: "Sözleşme 12 ay süreyle geçerlidir.",
                        importance: .high,
                        articleNumber: "1.1"
                    ),
                    Contract.KeyPoint(
                        title: "Fesih Koşulları",
                        description: "30 gün önceden bildirimle feshedilebilir.",
                        importance: .medium,
                        articleNumber: "2.3"
                    )
                ],
                risks: [
                    Contract.Risk(
                        title: "Otomatik Yenileme",
                        description: "Sözleşme otomatik olarak yenilenebilir.",
                        severity: .medium,
                        relatedArticle: "3.1",
                        suggestedAction: "Yenileme tarihini takip edin"
                    )
                ],
                recommendations: [
                    "Fesih bildirim süresine dikkat edin",
                    "Ödeme koşullarını gözden geçirin"
                ],
                riskAssessment: nil,
                riskLevel: .medium,
                formattedRiskScore: "65"
            )
            
            let analyzedContract = Contract.AnalyzedContract(
                fileName: url.lastPathComponent,
                analyzedDate: Date(),
                analysis: analysis,
                isFavorite: false
            )
            
            await MainActor.run {
                historyManager.saveContract(analyzedContract)
                contracts = historyManager.contracts
            }
        } catch {
            print("Dosya analiz edilirken bir hata oluştu: \(error.localizedDescription)")
        }
    }
}

// Notification name extension
extension Notification.Name {
    static let contractsDidChange = Notification.Name("contractsDidChange")
} 
