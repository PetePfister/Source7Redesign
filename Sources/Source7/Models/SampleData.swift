import SwiftUI

// MARK: - Sample Data matching the design prototype

let sampleProducts: [String: Product] = {
    var dict: [String: Product] = [:]
    for p in [product_A729200, product_A556954, product_922303] {
        dict[p.id] = p
    }
    return dict
}()

let product_A729200 = Product(
    id: "A729200",
    source: .q,
    title: "Revitalign Orthotic Washable Canvas Sneakers - Aster",
    shortDesc: "Revitalign Orthotic Washable Canvas Sneakers - Aster",
    longDesc: "Revitalign Orthotic Washable Canvas Sneakers - Aster. Featuring embroidered eyelet or breathable canvas uppers and is fully washable. Traditional laces customize your fit. New & improved orthotic insole with arch support and a cushioned heel cup.",
    price: 79.92,
    easyPay: "4 Easy Pays of $19.98",
    nextAir: AirDate(date: "05/08/2026", hour: "00:00", show: "RFC"),
    planner: "S. CHEN",
    buyer: "M. RIVERA",
    relationships: Relationships(
        group: "G-RVTLN-25",
        groupItems: ["A729198", "A729199", "A729201"],
        autoDelivery: nil,
        adItems: [],
        components: []
    ),
    slots: [
        ImageSlot(id: "001", status: .used, color: Color(hex: "#fcc4d4"), size: "371 KB", dim: "2000×1778", date: "May 06, 10:01 AM"),
        ImageSlot(id: "002", status: .used, color: Color(hex: "#ff5577"), size: "308 KB", dim: "2000×1778", date: "Mar 04, 3:11 PM"),
        ImageSlot(id: "003", status: .used, color: Color(hex: "#ff3366"), size: "295 KB", dim: "2000×1778", date: "Mar 04, 3:11 PM"),
        ImageSlot(id: "004", status: .used, color: Color(hex: "#ff5577"), size: "337 KB", dim: "2000×1778", date: "Mar 04, 3:11 PM"),
        ImageSlot(id: "005", status: .used, color: Color(hex: "#fff8f0"), size: "214 KB", dim: "2000×1778", date: "Mar 04, 3:11 PM"),
        ImageSlot(id: "006", status: .used, color: Color(hex: "#ff5577"), size: "353 KB", dim: "2000×1779", date: "Mar 04, 3:11 PM"),
        ImageSlot(id: "007", status: .used, color: Color(hex: "#d4c8a8"), size: "628 KB", dim: "2000×1778", date: "Apr 21, 1:04 PM"),
        ImageSlot(id: "008", status: .used, color: Color(hex: "#88c8d4"), size: "370 KB", dim: "1604×1426", date: "May 06, 10:01 AM"),
    ],
    swatches: [
        Swatch(id: "012", name: "Black",             color: Color(hex: "#1a1a1a"), s101: .init(ok: true,  date: "Mar 04"), s102: .init(ok: true,  date: "Mar 04"), okq: 4467),
        Swatch(id: "I90", name: "Watermelon",        color: Color(hex: "#ff7088"), s101: .init(ok: true,  date: "Mar 04"), s102: .init(ok: true,  date: "Mar 04"), okq: 3773),
        Swatch(id: "PNO", name: "Vintage Khaki",     color: Color(hex: "#bfa888"), s101: .init(ok: true,  date: "Mar 04"), s102: .init(ok: true,  date: "Mar 04"), okq: 7960),
        Swatch(id: "UFZ", name: "White Eyelet",      color: Color(hex: "#f0ece4"), s101: .init(ok: true,  date: "May 06"), s102: .init(ok: true,  date: "May 06"), okq: 12157),
        Swatch(id: "UGA", name: "Blueberry Eyelet",  color: Color(hex: "#5a7ec8"), s101: .init(ok: true,  date: "Mar 04"), s102: .init(ok: true,  date: "Mar 04"), okq: 9628),
        Swatch(id: "UGB", name: "PnkLemnde Eyelet",  color: Color(hex: "#f5cfd6"), s101: .init(ok: true,  date: "May 06"), s102: .init(ok: true,  date: "May 06"), okq: 10138),
    ],
    futureScripts: [
        Script(date: "05/09/2026", hour: "10:00", show: "SMQ", type: "Live Traditional Unedited", host: "AP/AC", guest: "JM",  appearance: "In-studio"),
        Script(date: "05/08/2026", hour: "00:00", show: "RFC", type: "Live Traditional Unedited", host: "JT",    guest: nil,   appearance: nil),
        Script(date: "05/08/2026", hour: "03:00", show: "RFC", type: "Previously Aired Traditional Unedited",   host: nil,    guest: nil,   appearance: nil),
        Script(date: "05/08/2026", hour: "06:00", show: "RFC", type: "Previously Aired Traditional Unedited",   host: nil,    guest: nil,   appearance: nil),
        Script(date: "05/08/2026", hour: "07:00", show: "FR7", type: "Live Traditional Unedited", host: "LW",   guest: "DP",  appearance: "In-studio"),
        Script(date: "05/08/2026", hour: "10:00", show: "RFC", type: "Live Traditional Unedited", host: "AC",   guest: nil,   appearance: nil),
        Script(date: "05/08/2026", hour: "12:00", show: "QCH", type: "Live Traditional Unedited", host: "AC",   guest: "DP",  appearance: "In-studio"),
        Script(date: "05/08/2026", hour: "15:00", show: "EYS", type: "Live Traditional Unedited", host: "VB",   guest: "DP",  appearance: "In-studio"),
        Script(date: "05/08/2026", hour: "17:00", show: "FSE", type: "Live Traditional Unedited", host: "AH/AP",guest: "DP",  appearance: "In-studio"),
        Script(date: "05/08/2026", hour: "20:00", show: "OVF", type: "Live Traditional Unedited", host: "SK",   guest: "DP",  appearance: "In-studio"),
    ],
    pullList: [
        PullRow(color: "UFZ - White Eyelet",       photographer: "STEPHANIE HERTZ", output: 1, shot: true, dateShot: "03-03-2026 17:13", retouched: true),
        PullRow(color: "PNO - Vintage Khaki",      photographer: "STEPHANIE HERTZ", output: 1, shot: true, dateShot: "03-03-2026 18:20", retouched: true),
        PullRow(color: "I90 - Watermelon",         photographer: "STEPHANIE HERTZ", output: 6, shot: true, dateShot: "03-03-2026 17:13", retouched: true),
        PullRow(color: "012 - Black",              photographer: "STEPHANIE HERTZ", output: 1, shot: true, dateShot: "03-03-2026 18:20", retouched: true),
        PullRow(color: "UGB - PnkLemndeEyelet",   photographer: "STEPHANIE HERTZ", output: 1, shot: true, dateShot: "03-03-2026 18:20", retouched: true),
        PullRow(color: "UGA - BlueberryEyelet",   photographer: "STEPHANIE HERTZ", output: 1, shot: true, dateShot: "03-03-2026 18:20", retouched: true),
    ],
    lastChecked: "23 hours ago",
    lastCheckedExact: "Yesterday, 10:14 AM"
)

let product_A556954 = Product(
    id: "A556954",
    source: .q,
    title: "ELEMIS Toner Duo",
    shortDesc: "ELEMIS Pro-Collagen Glow Boost Toner Duo",
    longDesc: "Two-piece toner duo with brightening botanicals to refresh and tone skin between cleanse and serum.",
    price: 56.00,
    easyPay: "2 Easy Pays of $28.00",
    nextAir: AirDate(date: "05/12/2026", hour: "14:00", show: "BTY"),
    planner: "K. PARK",
    buyer: "L. AHMED",
    relationships: Relationships(
        group: nil,
        groupItems: [],
        autoDelivery: "AD-ELEMIS-Q",
        adItems: ["M139910", "M139766"],
        components: ["A556955", "A556956"]
    ),
    slots: [
        ImageSlot(id: "001", status: .used,        color: Color(hex: "#f5e8d8"), size: "201 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "002", status: .available,   color: nil,                  size: nil,       dim: nil,         date: nil),
        ImageSlot(id: "003", status: .used,        color: Color(hex: "#e8d8c0"), size: "188 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "004", status: .used,        color: Color(hex: "#f0e0c8"), size: "175 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "005", status: .used,        color: Color(hex: "#e0d0b8"), size: "192 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "006", status: .used,        color: Color(hex: "#d8c8b0"), size: "168 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "007", status: .used,        color: Color(hex: "#e8d8c0"), size: "184 KB", dim: "2000×1778", date: "Apr 12, 2:01 PM"),
        ImageSlot(id: "008", status: .unavailable, color: nil,                  size: nil,       dim: nil,         date: nil),
    ],
    swatches: [
        Swatch(id: "001", name: "Default",        color: Color(hex: "#f5e8d8"), s101: .init(ok: true,  date: "Apr 12"), s102: .init(ok: true,  date: "Apr 12"), okq: 2104),
        Swatch(id: "002", name: "Travel Size",    color: Color(hex: "#ead8c0"), s101: .init(ok: true,  date: "Apr 12"), s102: .init(ok: false, date: nil),      okq: 0),
        Swatch(id: "003", name: "Refill",         color: Color(hex: "#dfc8a8"), s101: .init(ok: true,  date: "Apr 12"), s102: .init(ok: true,  date: "Apr 12"), okq: 856),
        Swatch(id: "004", name: "Limited Edition",color: Color(hex: "#c8b890"), s101: .init(ok: false, date: nil),      s102: .init(ok: false, date: nil),      okq: 124),
    ],
    futureScripts: [
        Script(date: "05/12/2026", hour: "14:00", show: "BTY", type: "Live Traditional Unedited", host: "VB", guest: "EM", appearance: "In-studio"),
        Script(date: "05/14/2026", hour: "09:00", show: "AMS", type: "Live Traditional Unedited", host: "JT", guest: nil,  appearance: nil),
    ],
    pullList: [
        PullRow(color: "001 - Default",  photographer: "JANE DOE", output: 1, shot: true,  dateShot: "04-12-2026 14:01", retouched: true),
        PullRow(color: "003 - Refill",   photographer: "JANE DOE", output: 1, shot: true,  dateShot: "04-12-2026 14:30", retouched: true),
        PullRow(color: "004 - Limited",  photographer: "—",        output: 0, shot: false, dateShot: nil,                retouched: false),
    ],
    lastChecked: "5 minutes ago",
    lastCheckedExact: "Today, 9:08 AM"
)

let product_922303 = Product(
    id: "922303",
    source: .h,
    title: "Joy Metallic Handbag",
    shortDesc: "Joy Mangano Metallic Crossbody Handbag",
    longDesc: "Compact crossbody with adjustable strap and signature metallic finish.",
    price: 45.00,
    easyPay: "3 Flexpays of $15.00",
    nextAir: AirDate(date: "05/10/2026", hour: "11:00", show: "AMQ"),
    planner: "T. WONG",
    buyer: "R. PATEL",
    relationships: Relationships(
        group: "G-JOY-MTL",
        groupItems: ["922301", "922302", "922304"],
        autoDelivery: nil,
        adItems: [],
        components: []
    ),
    slots: [
        ImageSlot(id: "main", status: .used, color: Color(hex: "#d4c4a0"), size: "412 KB", dim: "2000×2000", date: "May 01, 11:22 AM"),
        ImageSlot(id: "alt1", status: .used, color: Color(hex: "#c8b890"), size: "388 KB", dim: "2000×2000", date: "May 01, 11:22 AM"),
        ImageSlot(id: "alt2", status: .used, color: Color(hex: "#b8a880"), size: "402 KB", dim: "2000×2000", date: "May 01, 11:22 AM"),
        ImageSlot(id: "alt3", status: .used, color: Color(hex: "#a89870"), size: "395 KB", dim: "2000×2000", date: "May 01, 11:22 AM"),
        ImageSlot(id: "alt4", status: .used, color: Color(hex: "#988860"), size: "401 KB", dim: "2000×2000", date: "May 01, 11:22 AM"),
    ],
    swatches: [
        Swatch(id: "GLD", name: "Gold",      color: Color(hex: "#d4af37"), s101: .init(ok: true,  date: "May 01"), s102: .init(ok: true,  date: "May 01"), okq: 3201),
        Swatch(id: "SLV", name: "Silver",    color: Color(hex: "#c0c0c0"), s101: .init(ok: true,  date: "May 01"), s102: .init(ok: true,  date: "May 01"), okq: 2104),
        Swatch(id: "RGD", name: "Rose Gold", color: Color(hex: "#b76e79"), s101: .init(ok: true,  date: "May 01"), s102: .init(ok: true,  date: "May 01"), okq: 1845),
        Swatch(id: "BRZ", name: "Bronze",    color: Color(hex: "#cd7f32"), s101: .init(ok: true,  date: "May 01"), s102: .init(ok: true,  date: "May 01"), okq: 0),
        Swatch(id: "PWT", name: "Pewter",    color: Color(hex: "#8a9090"), s101: .init(ok: false, date: nil),      s102: .init(ok: false, date: nil),      okq: 0),
    ],
    futureScripts: [
        Script(date: "05/10/2026", hour: "11:00", show: "AMQ", type: "Live Traditional Unedited", host: "JM", guest: nil, appearance: "In-studio"),
    ],
    pullList: [
        PullRow(color: "GLD - Gold",   photographer: "M. KOWALSKI", output: 1, shot: true, dateShot: "05-01-2026 11:22", retouched: true),
        PullRow(color: "SLV - Silver", photographer: "M. KOWALSKI", output: 1, shot: true, dateShot: "05-01-2026 11:22", retouched: true),
    ],
    lastChecked: "2 minutes ago",
    lastCheckedExact: "Today, 9:14 AM"
)

// MARK: - History

let sampleHistory: [HistoryItem] = [
    HistoryItem(id: "A729200", name: "Revitalign Orthotic Washable Canvas Sneakers - Aster",         checked: "Today, 9:09 AM",      images: (8, 0, 0),  swatches: (6, 0)),
    HistoryItem(id: "M142630", name: "Corky's BBQ 6 Count Microwave Heat & Eat BBQ Dinners",          checked: "Today, 9:09 AM",      images: (0, 8, 0),  swatches: (0, 4)),
    HistoryItem(id: "M142632", name: "Corky's BBQ 6 Count Microwave Heat & Eat BBQ Dinners",          checked: "Today, 9:08 AM",      images: (0, 8, 0),  swatches: (0, 4)),
    HistoryItem(id: "A719266", name: "bareMinerals Original Pressed Powder Foundation Primer & Brush", checked: "Today, 8:58 AM",      images: (8, 0, 0),  swatches: (30, 0)),
    HistoryItem(id: "A726328", name: "Liberty Belles by Kim Gravel French Terry Hoodie",               checked: "Today, 8:07 AM",      images: (6, 2, 0),  swatches: (4, 0)),
    HistoryItem(id: "924399",  name: "DG Flutter Sleeve Stitch Top",                                   checked: "Today, 8:06 AM",      images: (3, 0, 0),  swatches: (3, 0)),
    HistoryItem(id: "924400",  name: "DG Embellished Denim Tote",                                      checked: "Yesterday, 5:10 PM",  images: (0, 0, 0),  swatches: (0, 6)),
    HistoryItem(id: "A556954", name: "ELEMIS Toner Duo",                                               checked: "Yesterday, 5:08 PM",  images: (1, 7, 0),  swatches: (4, 0)),
    HistoryItem(id: "A728290", name: "Susan Graver Essenials Rayon Allure Knit Ballet Neck Top",       checked: "Yesterday, 4:45 PM",  images: (6, 2, 0),  swatches: (4, 1)),
    HistoryItem(id: "A727845", name: "AnyBody Washed Cotton V-Neck Seamed Top with Cap Sleeve",        checked: "Yesterday, 4:22 PM",  images: (5, 3, 0),  swatches: (4, 0)),
    HistoryItem(id: "A463114", name: "Susan Graver Modern Essentials Regular Liquid Knit Tunic",       checked: "Yesterday, 3:39 PM",  images: (6, 2, 0),  swatches: (12, 3)),
    HistoryItem(id: "M139912", name: "Geoffrey Zakarian (12) 750ml Bottles Essential Wines A-D",       checked: "Yesterday, 2:14 PM",  images: (3, 5, 0),  swatches: (3, 0)),
    HistoryItem(id: "926607",  name: "Sharif Legacy Beaded Motiff",                                    checked: "Yesterday, 12:34 PM", images: (0, 0, 0),  swatches: (0, 5)),
    HistoryItem(id: "A692476", name: "tarte Shape Tape Blur Hydrating Concealer Stick with Brush",     checked: "Yesterday, 12:31 PM", images: (8, 0, 0),  swatches: (48, 0)),
    HistoryItem(id: "A716826", name: "Doll 10 Peptide Blur Stick Foundation with Brush",               checked: "Yesterday, 12:30 PM", images: (8, 0, 0),  swatches: (10, 0)),
    HistoryItem(id: "A689911", name: "Denim & Co. EasyWear French Terry Capri",                       checked: "Yesterday, 12:29 PM", images: (6, 2, 0),  swatches: (0, 7)),
    HistoryItem(id: "A689888", name: "Denim & Co. Regular EasyWear French Terry Capri",               checked: "Yesterday, 12:29 PM", images: (6, 2, 0),  swatches: (7, 0)),
    HistoryItem(id: "M139910", name: "A-D Geoffrey Zakarian (12) CA Reserve Wine Auto-Delivery",       checked: "Yesterday, 12:28 PM", images: (3, 5, 0),  swatches: (3, 0)),
    HistoryItem(id: "922303",  name: "Joy Metallic Handbag",                                           checked: "May 01, 11:22 AM",    images: (5, 0, 0),  swatches: (8, 0)),
]
