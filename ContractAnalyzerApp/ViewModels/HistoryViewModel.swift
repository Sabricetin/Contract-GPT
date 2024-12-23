import Foundation

final class HistoryViewModel: ObservableObject {
    @Published var contracts: [Contract.AnalyzedContract] = []
    private let historyManager = HistoryManager.shared
    
    init() {
        contracts = historyManager.contracts
        
        // HistoryManager'dan güncellemeleri dinle
        NotificationCenter.default.addObserver(self,
            selector: #selector(contractsDidChange),
            name: .contractsDidChange,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contractsDidChange() {
        contracts = historyManager.contracts
    }
}

// Notification name extension
extension Notification.Name {
    static let contractsDidChange = Notification.Name("contractsDidChange")
} 