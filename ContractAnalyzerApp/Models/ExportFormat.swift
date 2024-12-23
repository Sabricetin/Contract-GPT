import Foundation

public enum ExportFormat: String, CaseIterable {
    case pdf = "PDF"
    case docx = "Word"
    case txt = "Text"
    
    var systemImage: String {
        switch self {
        case .pdf: return "doc.fill"
        case .docx: return "doc.text.fill"
        case .txt: return "doc.plaintext.fill"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .pdf: return "pdf"
        case .docx: return "docx"
        case .txt: return "txt"
        }
    }
    
    var mimeType: String {
        switch self {
        case .pdf: return "application/pdf"
        case .docx: return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case .txt: return "text/plain"
        }
    }
} 