import Foundation
import SwiftUI
import UniformTypeIdentifiers
import PDFKit

class DocumentPickerViewModel: ObservableObject {
    @Published var showingPicker = false
    @Published var isAnalyzing = false
    @Published var error: String?
    @Published var shouldDismiss = false
    @Published var toastMessage = ""
    @Published var showToast = false
    @Published var toastType: ToastModifier.ToastType = .info
    
    private let historyManager = HistoryManager.shared
    
    func analyzeDocument(at url: URL) async {
        await MainActor.run {
            isAnalyzing = true
            error = nil
        }
        
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
                isAnalyzing = false
                shouldDismiss = true
                
                // Başarılı analiz toast mesajı
                toastMessage = "Analiz başarıyla tamamlandı"
                toastType = .success
                showToast = true
            }
        } catch {
            await MainActor.run {
                self.error = "Dosya analiz edilirken bir hata oluştu: \(error.localizedDescription)"
                self.isAnalyzing = false
                
                // Hata durumu toast mesajı
                toastMessage = "Analiz sırasında hata oluştu"
                toastType = .error
                showToast = true
            }
        }
    }
}

extension UTType {
    static let pdf = UTType(importedAs: "com.adobe.pdf")
    static let docx = UTType(importedAs: "org.openxmlformats.wordprocessingml.document")
    static let doc = UTType(importedAs: "com.microsoft.word.doc")
    
    static let supportedTypes: [UTType] = [.pdf, .docx, .doc, .text, .plainText]
} 