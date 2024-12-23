import SwiftUI

struct ImportanceLabel: View {
    let importance: Contract.Importance
    
    var color: Color {
        switch importance {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    var body: some View {
        Text(importance.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
} 