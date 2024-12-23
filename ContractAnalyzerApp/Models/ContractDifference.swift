import Foundation

public struct ContractDifference: Identifiable {
    public let id: UUID
    public let category: String
    public let description: String
    
    public init(id: UUID = UUID(), category: String, description: String) {
        self.id = id
        self.category = category
        self.description = description
    }
} 