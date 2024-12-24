import Foundation

class TranslationService {
    static let shared = TranslationService()
    
    private init() {}
    
    // MARK: - Public Methods
    func translateToTurkish(_ text: String) async throws -> String {
        let prompt = """
        Aşağıdaki metni Türkçe'ye çevir:
        \(text)
        
        Sadece çeviriyi döndür, ekstra açıklama ekleme.
        """
        
        return try await ChatGPTService.shared.sendPrompt(prompt)
    }
    
    func translateAnalysisResult(_ result: Contract.AnalysisResult, to language: SupportedLanguage) async throws -> Contract.AnalysisResult {
        let translatedSummary = try await translateToLanguage(result.summary, to: language.rawValue)
        let translatedKeyPoints = try await translateKeyPoints(result.keyPoints, to: language.rawValue)
        let translatedRisks = try await translateRisks(result.risks, to: language.rawValue)
        let translatedRecommendations = try await translateArray(result.recommendations, to: language.rawValue)
        
        return Contract.AnalysisResult(
            summary: translatedSummary,
            keyPoints: translatedKeyPoints,
            risks: translatedRisks,
            recommendations: translatedRecommendations,
            riskAssessment: result.riskAssessment,
            riskLevel: result.riskLevel,
            formattedRiskScore: result.formattedRiskScore
        )
    }
    
    // MARK: - Private Methods
    private func translateArray(_ texts: [String], to language: String) async throws -> [String] {
        var translatedTexts: [String] = []
        for text in texts {
            let translated = try await translateToLanguage(text, to: language)
            translatedTexts.append(translated)
        }
        return translatedTexts
    }
    
    private func translateKeyPoints(_ keyPoints: [Contract.KeyPoint], to language: String) async throws -> [Contract.KeyPoint] {
        var translatedPoints: [Contract.KeyPoint] = []
        
        for point in keyPoints {
            let translatedTitle = try await translateToLanguage(point.title, to: language)
            let translatedDescription = try await translateToLanguage(point.description, to: language)
            
            let translatedPoint = Contract.KeyPoint(
                title: translatedTitle,
                description: translatedDescription,
                importance: point.importance,
                articleNumber: point.articleNumber
            )
            
            translatedPoints.append(translatedPoint)
        }
        
        return translatedPoints
    }
    
    private func translateRisks(_ risks: [Contract.Risk], to language: String) async throws -> [Contract.Risk] {
        var translatedRisks: [Contract.Risk] = []
        
        for risk in risks {
            let translatedTitle = try await translateToLanguage(risk.title, to: language)
            let translatedDescription = try await translateToLanguage(risk.description, to: language)
            
            let translatedAction: String?
            if let action = risk.suggestedAction {
                translatedAction = try await translateToLanguage(action, to: language)
            } else {
                translatedAction = nil
            }
            
            let translatedRisk = Contract.Risk(
                title: translatedTitle,
                description: translatedDescription,
                severity: risk.severity,
                relatedArticle: risk.relatedArticle,
                suggestedAction: translatedAction
            )
            
            translatedRisks.append(translatedRisk)
        }
        
        return translatedRisks
    }
    
    private func translateToLanguage(_ text: String, to language: String) async throws -> String {
        let prompt = """
        Translate the following text to \(language):
        \(text)
        """
        
        return try await ChatGPTService.shared.sendPrompt(prompt)
    }
} 