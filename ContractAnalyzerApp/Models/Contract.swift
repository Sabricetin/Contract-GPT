import Foundation
import SwiftUI

// MARK: - Core Namespace
public enum Contract {
    // MARK: - Core Models
    public struct AnalysisResult: Codable, Hashable {
        public let summary: String
        public let keyPoints: [KeyPoint]
        public let risks: [Risk]
        public let recommendations: [String]
        public let riskAssessment: RiskAssessment?
        public let riskLevel: RiskLevel
        public let formattedRiskScore: String
        
        public init(
            summary: String,
            keyPoints: [KeyPoint],
            risks: [Risk],
            recommendations: [String],
            riskAssessment: RiskAssessment?,
            riskLevel: RiskLevel,
            formattedRiskScore: String
        ) {
            self.summary = summary
            self.keyPoints = keyPoints
            self.risks = risks
            self.recommendations = recommendations
            self.riskAssessment = riskAssessment
            self.riskLevel = riskLevel
            self.formattedRiskScore = formattedRiskScore
        }
    }
    
    public struct KeyPoint: Codable, Identifiable, Hashable {
        public let id: UUID
        public let title: String
        public let description: String
        public let importance: Importance
        public let articleNumber: String
        
        public init(
            id: UUID = UUID(),
            title: String,
            description: String,
            importance: Importance,
            articleNumber: String
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.importance = importance
            self.articleNumber = articleNumber
        }
    }
    
    public struct Risk: Codable, Identifiable, Hashable {
        public let id: UUID
        public let title: String
        public let description: String
        public let severity: Severity
        public let relatedArticle: String
        public let suggestedAction: String?
        
        public init(
            id: UUID = UUID(),
            title: String,
            description: String,
            severity: Severity,
            relatedArticle: String,
            suggestedAction: String? = nil
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.severity = severity
            self.relatedArticle = relatedArticle
            self.suggestedAction = suggestedAction
        }
    }
    
    public struct RiskAssessment: Codable, Hashable {
        public let overallScore: Double
        public let categories: [RiskCategory]
        public let recommendations: [String]
        
        public init(
            overallScore: Double,
            categories: [RiskCategory],
            recommendations: [String]
        ) {
            self.overallScore = overallScore
            self.categories = categories
            self.recommendations = recommendations
        }
    }
    
    public struct RiskCategory: Codable, Identifiable, Hashable {
        public let id: UUID
        public let name: String
        public let score: Double
        public let impact: RiskImpact
        
        public init(
            id: UUID = UUID(),
            name: String,
            score: Double,
            impact: RiskImpact
        ) {
            self.id = id
            self.name = name
            self.score = score
            self.impact = impact
        }
    }
    
    public enum RiskLevel: String, Codable, Hashable {
        case low = "Düşük"
        case medium = "Orta"
        case high = "Yüksek"
    }
    
    public enum Importance: String, Codable, Hashable {
        case low = "Düşük"
        case medium = "Orta"
        case high = "Yüksek"
    }
    
    public enum Severity: String, Codable, Hashable {
        case low = "Düşük"
        case medium = "Orta"
        case high = "Yüksek"
    }
    
    public enum RiskImpact: String, Codable, Hashable {
        case low = "Düşük"
        case medium = "Orta"
        case high = "Yüksek"
    }
    
    public struct AnalyzedContract: Identifiable, Codable, Hashable {
        public let id: UUID
        public let fileName: String
        public let analyzedDate: Date
        public let analysis: AnalysisResult
        public var isFavorite: Bool
        
        public init(
            id: UUID = UUID(),
            fileName: String,
            analyzedDate: Date,
            analysis: AnalysisResult,
            isFavorite: Bool = false
        ) {
            self.id = id
            self.fileName = fileName
            self.analyzedDate = analyzedDate
            self.analysis = analysis
            self.isFavorite = isFavorite
        }
    }
    
    // MARK: - Contract Difference
    public struct ContractDifference: Identifiable, Codable, Hashable {
        public let id: UUID
        public let title: String
        public let description: String
        public let firstVersion: String?
        public let secondVersion: String?
        public let importance: Importance
        public let articleNumber: String
        
        public init(
            id: UUID = UUID(),
            title: String,
            description: String,
            firstVersion: String?,
            secondVersion: String?,
            importance: Importance,
            articleNumber: String
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.firstVersion = firstVersion
            self.secondVersion = secondVersion
            self.importance = importance
            self.articleNumber = articleNumber
        }
    }
}

// MARK: - UI Extensions
extension Contract.RiskLevel {
    public var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
} 
