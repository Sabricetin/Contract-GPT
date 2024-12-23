import SwiftUI
import Charts

struct AnalysisResultView: View {
    let analysis: Contract.AnalysisResult
    @State private var selectedFormat: ExportFormat = .pdf
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Risk Skoru
                HStack {
                    VStack(alignment: .leading) {
                        Text("Risk Skoru: \(analysis.formattedRiskScore)")
                            .font(.title3)
                            .bold()
                        Text("Risk Seviyesi: \(analysis.riskLevel.rawValue)")
                            .foregroundColor(analysis.riskLevel.uiColor)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
                
                // Önemli Maddeler
                VStack(alignment: .leading, spacing: 10) {
                    Label("Önemli Maddeler", systemImage: "list.bullet")
                        .font(.title2)
                        .bold()
                    
                    ForEach(analysis.keyPoints) { point in
                        KeyPointView(keyPoint: point)
                    }
                }
                
                // Özet
                VStack(alignment: .leading) {
                    Label("Özet", systemImage: "doc.text")
                        .font(.title2)
                        .bold()
                    Text(analysis.summary)
                        .padding(.top, 4)
                }
                
                // Riskler
                VStack(alignment: .leading, spacing: 10) {
                    Label("Riskler", systemImage: "exclamationmark.triangle")
                        .font(.title2)
                        .bold()
                    
                    ForEach(analysis.risks) { risk in
                        RiskView(risk: risk)
                    }
                }
                
                // Öneriler
                if !analysis.recommendations.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Öneriler", systemImage: "lightbulb")
                            .font(.title2)
                            .bold()
                        
                        ForEach(analysis.recommendations, id: \.self) { recommendation in
                            Text("• \(recommendation)")
                                .padding(.vertical, 4)
                        }
                    }
                }
                
                // Risk Değerlendirmesi
                if let riskAssessment = analysis.riskAssessment {
                    RiskVisualizationView(assessment: riskAssessment)
                }
                
                // Dışa Aktarma
                VStack(alignment: .leading, spacing: 10) {
                    Text("Dışa Aktar")
                        .font(.headline)
                    FormatPicker(selectedFormat: $selectedFormat)
                    
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Paylaş", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Analiz Sonucu")
        .sheet(isPresented: $showingShareSheet) {
            ShareView(analysis: analysis)
        }
    }
}

struct KeyPointView: View {
    let keyPoint: Contract.KeyPoint
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(keyPoint.title)
                .font(.headline)
            Text(keyPoint.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct RiskView: View {
    let risk: Contract.Risk
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(risk.title)
                .font(.headline)
            Text(risk.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationView {
        AnalysisResultView(analysis: Contract.AnalysisResult(
            summary: "Örnek özet metni",
            keyPoints: [
                Contract.KeyPoint(
                    title: "Örnek Madde",
                    description: "Madde açıklaması",
                    importance: .medium,
                    articleNumber: "1.1"
                )
            ],
            risks: [
                Contract.Risk(
                    title: "Örnek Risk",
                    description: "Risk açıklaması",
                    severity: .medium,
                    relatedArticle: "1.2",
                    suggestedAction: "Öneri"
                )
            ],
            recommendations: ["Öneri 1", "Öneri 2"],
            riskAssessment: nil,
            riskLevel: .medium,
            formattedRiskScore: "65"
        ))
    }
}