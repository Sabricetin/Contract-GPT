import Foundation

public enum SupportedLanguage: String, CaseIterable {
    case turkish = "tr"
    case english = "en"
    case german = "de"
    
    var displayName: String {
        switch self {
        case .turkish: return "Türkçe"
        case .english: return "English"
        case .german: return "Deutsch"
        }
    }
} 