import SwiftUI

struct SeverityLabel: View {
    let severity: Contract.Severity
    
    var color: Color {
        switch severity {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    var body: some View {
        Text(severity.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
} 