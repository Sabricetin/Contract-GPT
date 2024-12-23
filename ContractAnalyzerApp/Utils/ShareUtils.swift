import Foundation
import PDFKit
import UIKit
import UniformTypeIdentifiers
import SwiftUI

// Type aliases - Contract namespace'inden alıyoruz
public typealias ContractResult = Contract.AnalysisResult
public typealias ContractKeyPoint = Contract.KeyPoint
public typealias ContractRisk = Contract.Risk

public enum ShareError: LocalizedError {
    case formatNotSupported
    case dataGenerationFailed
    case exportFailed
    case tempFileCreationFailed
    
    public var errorDescription: String? {
        switch self {
        case .formatNotSupported:
            return "Bu format henüz desteklenmiyor"
        case .dataGenerationFailed:
            return "Rapor oluşturulamadı"
        case .exportFailed:
            return "Dışa aktarma başarısız oldu"
        case .tempFileCreationFailed:
            return "Geçici dosya oluşturulamadı"
        }
    }
}

public class ShareUtils {
    static let shared = ShareUtils()
    private init() {}
    
    func generateShareableFile(from analysis: Contract.AnalysisResult, format: ExportFormat) throws -> URL {
        let content = generateContent(from: analysis)
        
        switch format {
        case .pdf:
            return try generatePDF(from: content)
        case .docx:
            return try generateDOCX(from: content)
        case .txt:
            return try generateTXT(from: content)
        }
    }
    
    private func generateContent(from analysis: Contract.AnalysisResult) -> String {
        var content = """
        SÖZLEŞME ANALİZ RAPORU
        =====================
        
        ÖZET
        ----
        \(analysis.summary)
        
        ÖNEMLİ MADDELER
        --------------
        """
        
        for point in analysis.keyPoints {
            content += """
            
            \(point.title) (Madde \(point.articleNumber))
            Önem: \(point.importance.rawValue)
            \(point.description)
            """
        }
        
        content += "\n\nRİSKLER\n-------"
        
        for risk in analysis.risks {
            content += """
            
            \(risk.title)
            Şiddet: \(risk.severity.rawValue)
            İlgili Madde: \(risk.relatedArticle)
            \(risk.description)
            """
            
            if let action = risk.suggestedAction {
                content += "\nÖnerilen Aksiyon: \(action)"
            }
        }
        
        content += "\n\nÖNERİLER\n--------"
        for recommendation in analysis.recommendations {
            content += "\n• \(recommendation)"
        }
        
        if let assessment = analysis.riskAssessment {
            content += """
            
            RİSK DEĞERLENDİRMESİ
            -------------------
            Genel Risk Skoru: \(assessment.overallScore)
            
            Risk Kategorileri:
            """
            
            for category in assessment.categories {
                content += """
                
                \(category.name)
                Skor: \(category.score)
                Etki: \(category.impact.rawValue)
                """
            }
            
            content += "\n\nRisk Önerileri:"
            for recommendation in assessment.recommendations {
                content += """
                
                \(recommendation.title)
                Öncelik: \(recommendation.priority.rawValue)
                \(recommendation.description)
                """
            }
        }
        
        return content
    }
    
    private func generatePDF(from content: String) throws -> URL {
        let format = UIGraphicsPDFRendererFormat()
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")
        
        try renderer.writePDF(to: tempURL) { context in
            context.beginPage()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: paragraphStyle
            ]
            
            content.draw(with: CGRect(x: 20, y: 20,
                                    width: pageRect.width - 40,
                                    height: pageRect.height - 40),
                        options: .usesLineFragmentOrigin,
                        attributes: attributes,
                        context: nil)
        }
        
        return tempURL
    }
    
    private func generateDOCX(from content: String) throws -> URL {
        // Basit bir implementasyon - gerçek uygulamada DOCX oluşturma kütüphanesi kullanılmalı
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("docx")
        
        try content.write(to: tempURL, atomically: true, encoding: .utf8)
        return tempURL
    }
    
    private func generateTXT(from content: String) throws -> URL {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("txt")
        
        try content.write(to: tempURL, atomically: true, encoding: .utf8)
        return tempURL
    }
} 
