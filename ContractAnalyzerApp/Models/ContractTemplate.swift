import Foundation

public struct ContractTemplate: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let description: String
    public let content: String
    public let category: String
    public let tags: [String]
    public let recommendedClauses: [String]
    public let warnings: [String]
    
    public init(id: UUID = UUID(),
                name: String,
                description: String,
                content: String,
                category: String,
                tags: [String],
                recommendedClauses: [String] = [],
                warnings: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.content = content
        self.category = category
        self.tags = tags
        self.recommendedClauses = recommendedClauses
        self.warnings = warnings
    }
} 