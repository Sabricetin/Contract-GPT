import Foundation

class ContractSuggestionService {
    static let shared = ContractSuggestionService()
    
    func generateSuggestions(from analysis: Contract.AnalysisResult) -> [ClauseSuggestion] {
        var suggestions: [ClauseSuggestion] = []
        
        // Key points'lerden öneriler oluştur
        for point in analysis.keyPoints {
            suggestions.append(ClauseSuggestion(
                title: "Madde Önerisi: \(point.title)",
                content: generateClauseContent(from: point),
                description: point.description,
                importance: point.importance,
                category: "Önemli Maddeler"
            ))
        }
        
        // Risk'lerden öneriler oluştur
        for risk in analysis.risks where risk.severity == .high {
            if let action = risk.suggestedAction {
                suggestions.append(ClauseSuggestion(
                    title: "Risk Azaltma Maddesi",
                    content: action,
                    description: risk.description,
                    importance: .high,
                    category: "Risk Azaltma"
                ))
            }
        }
        
        return suggestions
    }
    
    private func generateClauseContent(from point: Contract.KeyPoint) -> String {
        // Burada point'in içeriğine göre madde metni oluşturulabilir
        return "Madde X: \(point.description)"
    }
} 