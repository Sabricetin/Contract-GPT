import Foundation
import PDFKit

class PDFProcessor {
    func extractText(from url: URL) throws -> String {
        guard let document = PDFDocument(url: url) else {
            throw PDFProcessorModels.Error.invalidDocument
        }
        
        let pageCount = document.pageCount
        var text = ""
        
        for i in 0..<pageCount {
            guard let page = document.page(at: i) else { continue }
            text += page.string ?? ""
        }
        
        if text.isEmpty {
            throw PDFProcessorModels.Error.textExtractionFailed
        }
        
        return text
    }
    
    func prepareForAnalysis(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum PDFProcessorModels {
    enum Error: LocalizedError {
        case invalidDocument
        case textExtractionFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidDocument:
                return "PDF belgesi açılamadı"
            case .textExtractionFailed:
                return "PDF'den metin çıkarılamadı"
            }
        }
    }
} 