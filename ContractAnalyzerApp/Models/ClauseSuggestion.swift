import Foundation

public struct ClauseSuggestion: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let content: String
    public let description: String
    public let importance: Contract.Importance
    public let category: String
    
    public init(id: UUID = UUID(),
                title: String,
                content: String,
                description: String,
                importance: Contract.Importance,
                category: String) {
        self.id = id
        self.title = title
        self.content = content
        self.description = description
        self.importance = importance
        self.category = category
    }
} 