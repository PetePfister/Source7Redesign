import Foundation
import SwiftUI

// MARK: - Core Models

struct Product: Identifiable, Hashable {
    let id: String
    let source: ProductSource
    let title: String
    let shortDesc: String
    let longDesc: String
    let price: Double
    let easyPay: String
    let nextAir: AirDate
    let planner: String
    let buyer: String
    let relationships: Relationships
    let slots: [ImageSlot]
    let swatches: [Swatch]
    let futureScripts: [Script]
    let pullList: [PullRow]
    let lastChecked: String
    let lastCheckedExact: String

    static func == (lhs: Product, rhs: Product) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum ProductSource: String {
    case q = "Q"
    case h = "H"
    var label: String { rawValue }
}

struct AirDate {
    let date: String
    let hour: String
    let show: String
}

struct Relationships {
    let group: String?
    let groupItems: [String]
    let autoDelivery: String?
    let adItems: [String]
    let components: [String]

    var hasGroup: Bool { group != nil }
    var hasAD: Bool { autoDelivery != nil }
    var hasComponents: Bool { !components.isEmpty }
    var hasAny: Bool { hasGroup || hasAD || hasComponents }

    var allRows: [RelatedRow] {
        var rows: [RelatedRow] = []
        if hasGroup {
            groupItems.forEach { rows.append(.init(id: $0, kind: .group)) }
        }
        if hasAD {
            adItems.forEach { rows.append(.init(id: $0, kind: .autoDelivery)) }
        }
        components.forEach { rows.append(.init(id: $0, kind: .component)) }
        return rows
    }
}

struct RelatedRow: Identifiable {
    let id: String
    let kind: RelatedKind

    enum RelatedKind {
        case group, autoDelivery, component
        var label: String {
            switch self {
            case .group: return "GRP"
            case .autoDelivery: return "AD"
            case .component: return "COMP"
            }
        }
    }
}

struct ImageSlot: Identifiable {
    let id: String
    let status: SlotStatus
    let color: Color?
    let size: String?
    let dim: String?
    let date: String?

    enum SlotStatus {
        case used, available, unavailable
    }
}

struct Swatch: Identifiable {
    let id: String
    var code: String { id }
    let name: String
    let color: Color
    let s101: SlotImage?
    let s102: SlotImage?
    let okq: Int

    var bothLoaded: Bool { s101?.ok == true && s102?.ok == true }
    var missing: Bool { s101?.ok != true && s102?.ok != true }
    var partial: Bool { (s101?.ok == true || s102?.ok == true) && !bothLoaded }

    struct SlotImage {
        let ok: Bool
        let date: String?
    }
}

struct Script: Identifiable {
    let id = UUID()
    let date: String
    let hour: String
    let show: String
    let type: String
    let host: String?
    let guest: String?
    let appearance: String?
}

struct PullRow: Identifiable {
    let id = UUID()
    let color: String
    let photographer: String
    let output: Int
    let shot: Bool
    let dateShot: String?
    let retouched: Bool
}

struct HistoryItem: Identifiable {
    let id: String
    let name: String
    let checked: String
    let images: (used: Int, avail: Int, blocked: Int)
    let swatches: (ready: Int, missing: Int)
}

// MARK: - Stats helpers

extension Product {
    var slotStats: (used: Int, avail: Int, unavail: Int, total: Int) {
        let used = slots.filter { $0.status == .used }.count
        let avail = slots.filter { $0.status == .available }.count
        let unavail = slots.filter { $0.status == .unavailable }.count
        return (used, avail, unavail, slots.count)
    }

    var swatchStats: (ready: Int, partial: Int, missing: Int, total: Int) {
        let ready = swatches.filter { $0.bothLoaded }.count
        let partial = swatches.filter { $0.partial }.count
        let missing = swatches.filter { $0.missing }.count
        return (ready, partial, missing, swatches.count)
    }

    var missingFilenames: [(name: String, kind: String)] {
        var result: [(String, String)] = []
        for slot in slots where slot.status != .used {
            result.append(("\(id)_\(slot.id)", "slot"))
        }
        for swatch in swatches {
            if swatch.s101?.ok != true { result.append(("\(id)_\(swatch.code)_101", "swatch")) }
            if swatch.s102?.ok != true { result.append(("\(id)_\(swatch.code)_102", "swatch")) }
        }
        return result
    }
}
