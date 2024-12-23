import Foundation

class TemplateViewModel: ObservableObject {
    @Published var templates: [ContractTemplate] = []
    @Published var searchText: String = ""
    
    private let templateService = TemplateService.shared
    
    init() {
        loadTemplates()
    }
    
    private func loadTemplates() {
        templates = templateService.getTemplates()
    }
    
    func filteredTemplates() -> [ContractTemplate] {
        if searchText.isEmpty {
            return templates
        }
        return templates.filter { template in
            template.name.localizedCaseInsensitiveContains(searchText) ||
            template.description.localizedCaseInsensitiveContains(searchText) ||
            template.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
} 