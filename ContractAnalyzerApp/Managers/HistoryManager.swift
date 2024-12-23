import Foundation
import SwiftUI

public class HistoryManager: ObservableObject {
    public static let shared = HistoryManager()
    
    @Published public private(set) var contracts: [Contract.AnalyzedContract] = []
    private let defaults = UserDefaults.standard
    private let contractsKey = "analyzedContracts"
    
    private init() {
        loadContracts()
    }
    
    public func saveContract(_ contract: Contract.AnalyzedContract) {
        contracts.append(contract)
        saveToDefaults()
    }
    
    public func toggleFavorite(_ contract: Contract.AnalyzedContract) {
        if let index = contracts.firstIndex(where: { $0.id == contract.id }) {
            var updatedContract = contract
            updatedContract.isFavorite.toggle()
            contracts[index] = updatedContract
            saveToDefaults()
        }
    }
    
    private func saveToDefaults() {
        if let encoded = try? JSONEncoder().encode(contracts) {
            defaults.set(encoded, forKey: contractsKey)
        }
        NotificationCenter.default.post(name: .contractsDidChange, object: nil)
    }
    
    private func loadContracts() {
        if let data = defaults.data(forKey: contractsKey),
           let decoded = try? JSONDecoder().decode([Contract.AnalyzedContract].self, from: data) {
            contracts = decoded
        }
    }
} 