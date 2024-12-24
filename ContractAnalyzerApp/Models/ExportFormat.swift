import Foundation

public enum ExportFormat: String, CaseIterable {
    case pdf = "PDF"
    case text = "Metin"
    
    var icon: String {
        switch self {
        case .pdf: return "doc.pdf"
        case .text: return "doc.text"
        }
    }
    
    var description: String {
        switch self {
        case .pdf: return "Detaylı PDF raporu"
        case .text: return "Düz metin formatı"
        }
    }
} 