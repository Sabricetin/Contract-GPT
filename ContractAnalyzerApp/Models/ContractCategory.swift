import Foundation

enum ContractCategory: String, Codable, CaseIterable {
    case employment = "İş Sözleşmesi"
    case lease = "Kira Sözleşmesi"
    case sales = "Satış Sözleşmesi"
    case service = "Hizmet Sözleşmesi"
    case nda = "Gizlilik Sözleşmesi"
    case other = "Diğer"
} 