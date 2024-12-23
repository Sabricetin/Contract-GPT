import Foundation

class TemplateService {
    static let shared = TemplateService()
    
    private var templates: [ContractTemplate] = [
        ContractTemplate(
            id: UUID(),
            name: "İş Sözleşmesi",
            description: "Standart iş sözleşmesi şablonu",
            content: "İŞ SÖZLEŞMESİ\n\n1. TARAFLAR\n...",
            category: "İş Hukuku",
            tags: ["iş", "istihdam"]
        ),
        ContractTemplate(
            id: UUID(),
            name: "Kira Sözleşmesi",
            description: "Konut kira sözleşmesi şablonu",
            content: "KİRA SÖZLEŞMESİ\n\n1. TARAFLAR\n...",
            category: "Gayrimenkul",
            tags: ["kira", "emlak"]
        )
    ]
    
    func getTemplates() -> [ContractTemplate] {
        return templates
    }
    
    func getTemplate(byCategory category: String) -> [ContractTemplate] {
        return templates.filter { $0.category == category }
    }
} 