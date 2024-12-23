import SwiftUI

// MARK: - Risk UI Protocol
public protocol RiskUI {
    var uiColor: Color { get }
    var uiIcon: String { get }
}

// MARK: - Risk Level Extensions
extension Contract.RiskLevel: RiskUI {
    public var uiColor: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    public var uiIcon: String {
        switch self {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
}

// MARK: - Importance Extensions
extension Contract.Importance: RiskUI {
    public var uiColor: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    public var uiIcon: String {
        switch self {
        case .high: return "exclamationmark.circle.fill"
        case .medium: return "arrow.up.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
}

// MARK: - Severity Extensions
extension Contract.Severity: RiskUI {
    public var uiColor: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    public var uiIcon: String {
        switch self {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "info.circle.fill"
        }
    }
}

// MARK: - Priority Extensions
extension Contract.Priority: RiskUI {
    public var uiColor: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    public var uiIcon: String {
        switch self {
        case .high: return "1.circle.fill"
        case .medium: return "2.circle.fill"
        case .low: return "3.circle.fill"
        }
    }
}

// Diğer enum'lar için benzer extension'lar... 
